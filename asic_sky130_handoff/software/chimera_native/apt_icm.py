#!/usr/bin/env python3
"""Matched exact-only IID/EPIC adaptive parallel tempering with ICM.

The implementation is self-contained except for NumPy and runs across CPU
environments. All stochastic mechanisms use
separate deterministic streams.  Local p-bit words may be reused only by the
EPIC controller. Initialization, replica exchange, and cluster moves always
consume fresh counted 32-bit words.
"""

from __future__ import annotations

import hashlib
import json
import math
import resource
import sys
import time
from collections import Counter, deque
from dataclasses import dataclass
from typing import Iterable

import numpy as np

from exact_bit_rng import ExactBitReservoir


U32_SCALE = 1 << 32
U32_MASK = U32_SCALE - 1
FIELD_SCALE = 8
FIELD_LIMIT = 127
LUT_SATURATION_ADDRESS = 83
AGE_COUNTER_MAX = 65535
KING_OFFSETS = ((0, 1), (1, -1), (1, 0), (1, 1))


def sigmoid_scalar(value: float) -> float:
    if value >= 0:
        e = math.exp(-value)
        return 1.0 / (1.0 + e)
    e = math.exp(value)
    return e / (1.0 + e)


def lut_threshold(field_magnitude: int) -> int:
    address = min(max(int(field_magnitude), 0), FIELD_LIMIT)
    if address > LUT_SATURATION_ADDRESS:
        return U32_MASK
    threshold = round(sigmoid_scalar(2.0 * address / FIELD_SCALE) * U32_SCALE)
    return min(threshold, U32_MASK)


LUT_TABLE = np.asarray(
    [lut_threshold(i) for i in range(FIELD_LIMIT + 1)], dtype=np.uint64
)


@dataclass(frozen=True)
class KingsInstance:
    name: str
    side: int
    n: int
    edge_u: np.ndarray
    edge_v: np.ndarray
    edge_w: np.ndarray
    neigh_idx: np.ndarray
    neigh_w: np.ndarray
    colors: np.ndarray
    adjacency: tuple[tuple[int, ...], ...]


def kings_edges(side: int) -> list[tuple[int, int]]:
    edges: list[tuple[int, int]] = []
    for row in range(side):
        for col in range(side):
            for dr, dc in KING_OFFSETS:
                rr, cc = row + dr, col + dc
                if 0 <= rr < side and 0 <= cc < side:
                    edges.append((row * side + col, rr * side + cc))
    return edges


def make_instance(name: str, protocol: dict) -> KingsInstance:
    family, suffix = name.rsplit(".", 1)
    side = int(protocol["kings_side"][family])
    n = side * side
    target_n = int(protocol["targets"][name]["n"])
    if n != target_n:
        raise ValueError(f"{name}: generated n={n}, manifest n={target_n}")
    seed = (
        int(protocol["instance_seed_base"])
        + int(protocol["family_base"][family])
        + int(suffix)
    )
    rng = np.random.default_rng(seed)
    edges = kings_edges(side)
    edge_u = np.asarray([edge[0] for edge in edges], dtype=np.int32)
    edge_v = np.asarray([edge[1] for edge in edges], dtype=np.int32)
    edge_w = rng.choice(np.asarray([-1, 1], dtype=np.int8), size=len(edges))
    neigh_idx = np.full((n, 8), n, dtype=np.int32)
    neigh_w = np.zeros((n, 8), dtype=np.int8)
    fill = np.zeros(n, dtype=np.int8)
    adjacency_lists: list[list[int]] = [[] for _ in range(n)]
    for raw_u, raw_v, raw_w in zip(edge_u, edge_v, edge_w):
        u, v, w = int(raw_u), int(raw_v), int(raw_w)
        for a, b in ((u, v), (v, u)):
            neigh_idx[a, fill[a]] = b
            neigh_w[a, fill[a]] = w
            fill[a] += 1
            adjacency_lists[a].append(b)
    rows = np.arange(n) // side
    cols = np.arange(n) % side
    colors = ((rows % 2) * 2 + cols % 2).astype(np.int8)
    return KingsInstance(
        name=name,
        side=side,
        n=n,
        edge_u=edge_u,
        edge_v=edge_v,
        edge_w=edge_w,
        neigh_idx=neigh_idx,
        neigh_w=neigh_w,
        colors=colors,
        adjacency=tuple(tuple(sorted(v)) for v in adjacency_lists),
    )


def instance_digest(inst: KingsInstance) -> str:
    digest = hashlib.sha256()
    for array in (inst.edge_u, inst.edge_v, inst.edge_w):
        digest.update(np.ascontiguousarray(array).tobytes())
    return digest.hexdigest()


def bits_sha256(bits: np.ndarray) -> str:
    return hashlib.sha256(np.asarray(bits, dtype=np.uint8).tobytes()).hexdigest()


def cut_bits_direct(inst: KingsInstance, bits: np.ndarray) -> int:
    values = np.asarray(bits, dtype=np.int8)
    return int(np.sum(
        inst.edge_w.astype(np.int64)
        * (values[inst.edge_u] != values[inst.edge_v]).astype(np.int64)
    ))


def cut_bits_adjacency(inst: KingsInstance, bits: np.ndarray) -> int:
    """Independent scorer that traverses adjacency and divides by two."""
    values = np.asarray(bits, dtype=np.int8)
    total = 0
    for node, neighbors in enumerate(inst.adjacency):
        for slot, neighbor in enumerate(inst.neigh_idx[node]):
            neighbor = int(neighbor)
            if neighbor >= inst.n:
                continue
            if values[node] != values[neighbor]:
                total += int(inst.neigh_w[node, slot])
    if total % 2:
        raise AssertionError(f"{inst.name}: adjacency cut sum is not even")
    return total // 2


def cut_many(inst: KingsInstance, state: np.ndarray) -> np.ndarray:
    flat = np.asarray(state, dtype=np.int8).reshape(-1, inst.n)
    disagreements = flat[:, inst.edge_u] != flat[:, inst.edge_v]
    return disagreements.astype(np.int64) @ inst.edge_w.astype(np.int64)


def energy_from_cut(inst: KingsInstance, cuts: np.ndarray | int) -> np.ndarray:
    return int(np.sum(inst.edge_w)) - 2 * np.asarray(cuts, dtype=np.int64)


def ladder_id(betas: Iterable[float]) -> str:
    payload = json.dumps([float(x) for x in betas], separators=(",", ":"))
    return hashlib.sha256(payload.encode()).hexdigest()[:16]


def stream_rng(seed: int, stream: int) -> np.random.Generator:
    return np.random.default_rng(np.random.SeedSequence([int(seed), int(stream)]))


def fresh_u32(rng: np.random.Generator, size=None) -> np.ndarray | int:
    values = rng.integers(0, U32_SCALE, size=size, dtype=np.uint64)
    return int(values) if size is None else values


def initialize_bits(
    rng: np.random.Generator, shape: tuple[int, ...]
) -> tuple[np.ndarray, int]:
    total = int(np.prod(shape))
    words_needed = (total + 31) // 32
    words = fresh_u32(rng, words_needed)
    shifts = np.arange(32, dtype=np.uint64)
    bits = ((words[:, None] >> shifts[None, :]) & 1).astype(np.int8).ravel()
    return bits[:total].reshape(shape), words_needed


@dataclass
class ReplicaBank:
    state: np.ndarray
    stored_word: np.ndarray
    stored_bfield: np.ndarray
    age: np.ndarray
    valid: np.ndarray
    cuts: np.ndarray
    energies: np.ndarray
    walker_ids: np.ndarray


@dataclass
class RoundTripTracker:
    origin: np.ndarray
    crossed: np.ndarray
    counts: np.ndarray

    @classmethod
    def create(cls, walkers: int) -> "RoundTripTracker":
        return cls(
            origin=np.full(walkers, -1, dtype=np.int8),
            crossed=np.zeros(walkers, dtype=bool),
            counts=np.zeros(walkers, dtype=np.int64),
        )

    def observe(self, walker_ids: np.ndarray) -> None:
        for extreme, temperature in ((0, 0), (1, walker_ids.shape[1] - 1)):
            for walker in walker_ids[:, temperature]:
                walker = int(walker)
                if self.origin[walker] < 0:
                    self.origin[walker] = extreme
                elif extreme != self.origin[walker]:
                    self.crossed[walker] = True
                elif self.crossed[walker]:
                    self.counts[walker] += 1
                    self.crossed[walker] = False


def initialize_bank(
    inst: KingsInstance,
    copies: int,
    temperatures: int,
    rng: np.random.Generator,
) -> tuple[ReplicaBank, int]:
    state, init_words = initialize_bits(rng, (copies, temperatures, inst.n))
    cuts = cut_many(inst, state).reshape(copies, temperatures)
    walkers = np.arange(copies * temperatures, dtype=np.int32).reshape(
        copies, temperatures
    )
    shape = state.shape
    return ReplicaBank(
        state=state,
        stored_word=np.zeros(shape, dtype=np.uint64),
        stored_bfield=np.zeros(shape, dtype=np.float64),
        age=np.zeros(shape, dtype=np.uint16),
        valid=np.zeros(shape, dtype=bool),
        cuts=cuts,
        energies=energy_from_cut(inst, cuts),
        walker_ids=walkers,
    ), init_words


def swap_probability(
    beta_left: float, beta_right: float, energy_left: int, energy_right: int
) -> float:
    exponent = (beta_left - beta_right) * (energy_left - energy_right)
    return 1.0 if exponent >= 0.0 else math.exp(max(exponent, -745.0))


def exchange_replicas(
    bank: ReplicaBank, copy: int, left: int, right: int
) -> None:
    """Exchange two temperature slots and invalidate local EPIC caches."""
    for array in (bank.state, bank.cuts, bank.energies, bank.walker_ids):
        array[copy, [left, right]] = array[copy, [right, left]]
    bank.valid[copy, [left, right], :] = False


def connected_disagreement_component(
    inst: KingsInstance, disagreement: np.ndarray, seed_node: int
) -> np.ndarray:
    if not disagreement[seed_node]:
        raise ValueError("cluster seed is outside the disagreement set")
    seen = np.zeros(inst.n, dtype=bool)
    seen[seed_node] = True
    queue = deque([int(seed_node)])
    component: list[int] = []
    while queue:
        node = queue.popleft()
        component.append(node)
        for neighbor in inst.adjacency[node]:
            if disagreement[neighbor] and not seen[neighbor]:
                seen[neighbor] = True
                queue.append(neighbor)
    return np.asarray(component, dtype=np.int32)


def affected_nodes(inst: KingsInstance, cluster: np.ndarray) -> np.ndarray:
    affected = set(int(node) for node in cluster)
    for node in cluster:
        affected.update(inst.adjacency[int(node)])
    return np.asarray(sorted(affected), dtype=np.int32)


def attempt_icm(
    inst: KingsInstance,
    bank: ReplicaBank,
    temperature: int,
    rng: np.random.Generator,
    max_disagreement_fraction: float,
    max_cluster_fraction: float,
) -> tuple[bool, int, int, str]:
    """Attempt one low-temperature ICM and return accepted, size, words, and reason."""
    selector = fresh_u32(rng)
    words = 1
    left = bank.state[0, temperature]
    right = bank.state[1, temperature]
    disagreement = left != right
    nodes = np.flatnonzero(disagreement)
    if len(nodes) == 0:
        return False, 0, words, "no_disagreement"
    if len(nodes) / inst.n > max_disagreement_fraction:
        return False, 0, words, "percolating_disagreement"
    seed_node = int(nodes[selector % len(nodes)])
    cluster = connected_disagreement_component(inst, disagreement, seed_node)
    if len(cluster) / inst.n > max_cluster_fraction:
        return False, len(cluster), words, "percolating_cluster"
    before = int(bank.energies[0, temperature] + bank.energies[1, temperature])
    bank.state[:, temperature, cluster] ^= 1
    pair_cuts = cut_many(inst, bank.state[:, temperature, :])
    pair_energies = energy_from_cut(inst, pair_cuts)
    after = int(np.sum(pair_energies))
    if after != before:
        raise AssertionError(
            f"{inst.name}: ICM changed pair energy {before} -> {after}"
        )
    bank.cuts[:, temperature] = pair_cuts
    bank.energies[:, temperature] = pair_energies
    invalid = affected_nodes(inst, cluster)
    bank.valid[:, temperature, invalid] = False
    return True, len(cluster), words, "accepted"


def certified_hit_witness(
    inst: KingsInstance, bank: ReplicaBank, target: int
) -> np.ndarray | None:
    """Return a doubly scored exact witness from the bank, if one exists."""
    locations = np.argwhere(bank.cuts >= target)
    if len(locations) == 0:
        return None
    copy, temperature = (int(x) for x in locations[0])
    candidate = bank.state[copy, temperature].copy()
    direct = cut_bits_direct(inst, candidate)
    independent = cut_bits_adjacency(inst, candidate)
    if direct != independent or direct != target:
        raise AssertionError(
            f"{inst.name}: claimed exact hit target={target}, "
            f"direct={direct}, adjacency={independent}"
        )
    return candidate


def update_color(
    inst: KingsInstance,
    bank: ReplicaBank,
    betas: np.ndarray,
    color: int,
    rng: np.random.Generator,
    method: str,
    epic_enabled: bool,
    field_refresh_delta: float,
    max_hold_age: int,
    bit_reservoir: ExactBitReservoir | None = None,
) -> tuple[int, int, int, int]:
    copies, temperatures, n = bank.state.shape
    chains = copies * temperatures
    group = np.flatnonzero(inst.colors == color)
    state = bank.state.reshape(chains, n)
    stored_word = bank.stored_word.reshape(chains, n)
    stored_bfield = bank.stored_bfield.reshape(chains, n)
    age = bank.age.reshape(chains, n)
    valid = bank.valid.reshape(chains, n)
    spins = 2 * state.astype(np.int16) - 1
    spins_pad = np.concatenate(
        (spins, np.zeros((chains, 1), dtype=np.int16)), axis=1
    )
    neighbors = inst.neigh_idx[group]
    local = -np.sum(
        inst.neigh_w[group][None, :, :]
        * spins_pad[:, neighbors],
        axis=2,
        dtype=np.int32,
    )
    chain_betas = np.tile(np.asarray(betas, dtype=np.float64), copies)
    bfield = chain_betas[:, None] * local
    field_input = np.clip(
        np.rint(FIELD_SCALE * bfield), -FIELD_LIMIT, FIELD_LIMIT
    ).astype(np.int16)
    threshold = LUT_TABLE[np.abs(field_input)]
    nonnegative = field_input >= 0
    current = state[:, group]
    visits = chains * len(group)
    if method == "exact_bit_apt_icm":
        if bit_reservoir is None:
            raise ValueError("exact-bit method requires a bit reservoir")
        words_before = bit_reservoir.words_drawn
        bits_before = bit_reservoir.bits_consumed
        positive_counts = threshold.astype(np.uint64)
        negative_counts = np.uint64(U32_MASK) - threshold.astype(np.uint64)
        success_counts = np.where(
            nonnegative, positive_counts, negative_counts
        ).reshape(-1)
        next_state = np.fromiter(
            (int(bit_reservoir.bernoulli_count(int(count)))
             for count in success_counts),
            dtype=np.int8,
            count=visits,
        ).reshape(current.shape)
        current[:] = next_state
        state[:, group] = current
        return (
            visits,
            visits,
            bit_reservoir.words_drawn - words_before,
            bit_reservoir.bits_consumed - bits_before,
        )
    supported = nonnegative == (current == 1)
    changed = np.abs(bfield - stored_bfield[:, group]) >= field_refresh_delta
    expired = age[:, group] >= max_hold_age
    use_epic = method == "epic_apt_icm" and epic_enabled
    refresh = (~valid[:, group]) | (~supported) | changed | expired
    if not use_epic:
        refresh = np.ones(refresh.shape, dtype=bool)
    fresh = int(np.sum(refresh))
    candidates = np.zeros(refresh.shape, dtype=np.uint64)
    if fresh:
        candidates[refresh] = fresh_u32(rng, fresh)
    words = np.where(refresh, candidates, stored_word[:, group])
    next_state = np.where(
        nonnegative, threshold > words, words > threshold
    ).astype(np.int8)
    skip = use_epic & (~refresh) & (next_state == current)
    fire = ~skip
    current[fire] = next_state[fire]
    state[:, group] = current
    for chain in range(chains):
        refreshed = group[refresh[chain]]
        reused = group[~refresh[chain]]
        if len(refreshed):
            stored_word[chain, refreshed] = candidates[chain, refresh[chain]]
            stored_bfield[chain, refreshed] = bfield[chain, refresh[chain]]
            age[chain, refreshed] = 0
            valid[chain, refreshed] = True
        if len(reused):
            age[chain, reused] = np.minimum(
                age[chain, reused].astype(np.uint32) + 1, AGE_COUNTER_MAX
            ).astype(np.uint16)
    return visits, int(np.sum(fire)), fresh, fresh * 32


def checkpoint_grid(max_sweeps: int, requested: Iterable[int]) -> tuple[int, ...]:
    points = sorted({int(x) for x in requested if 0 < int(x) <= max_sweeps})
    if not points or points[-1] != max_sweeps:
        points.append(max_sweeps)
    return tuple(points)


def run_apt_icm(
    inst: KingsInstance,
    target: int,
    target_kind: str,
    method: str,
    trial: int,
    seed: int,
    betas: Iterable[float],
    max_sweeps: int,
    checkpoint_sweeps: Iterable[int],
    copies: int = 2,
    icm_interval: int = 4,
    icm_beta_min: float = 1.2,
    max_disagreement_fraction: float = 0.5,
    max_cluster_fraction: float = 0.5,
    epic_enabled: bool = True,
    field_refresh_delta: float = 0.1,
    max_hold_age: int = 2,
    stop_on_exact: bool = True,
) -> dict:
    if method not in {"iid_apt_icm", "epic_apt_icm", "exact_bit_apt_icm"}:
        raise ValueError(f"unknown method {method}")
    if copies != 2:
        raise ValueError("ICM protocol requires exactly two copies per temperature")
    betas = np.asarray(tuple(float(x) for x in betas), dtype=np.float64)
    if len(betas) < 2 or np.any(np.diff(betas) <= 0):
        raise ValueError("beta ladder must be strictly increasing")
    if target_kind not in {
        "exact_dp", "exact_cplex", "exact_bipartite", "exact_planted",
        "validation"
    }:
        raise ValueError(f"target kind is not exact-eligible: {target_kind}")
    checkpoints = checkpoint_grid(max_sweeps, checkpoint_sweeps)
    init_rng = stream_rng(seed, 1)
    local_rng = stream_rng(seed, 2)
    bit_reservoir = (
        ExactBitReservoir(local_rng) if method == "exact_bit_apt_icm" else None
    )
    swap_rng = stream_rng(seed, 3)
    icm_rng = stream_rng(seed, 4)
    bank, init_words = initialize_bank(inst, copies, len(betas), init_rng)
    tracker = RoundTripTracker.create(copies * len(betas))
    tracker.observe(bank.walker_ids)
    started_wall = time.perf_counter()
    started_process = time.process_time()

    total_updates = 0
    fired_cycles = 0
    local_fresh_words = 0
    local_rng_bits = 0
    swap_words = 0
    icm_words = 0
    swap_attempts = 0
    swap_accepts = 0
    adjacent_attempts = np.zeros(len(betas) - 1, dtype=np.int64)
    adjacent_accepts = np.zeros(len(betas) - 1, dtype=np.int64)
    cluster_attempts = 0
    cluster_accepts = 0
    cluster_size_counts: Counter[int] = Counter()
    cluster_rejections: Counter[str] = Counter()
    first_sweep = None
    first_phase = None
    first_color = None
    witness_bits = None
    best_cut = int(np.max(bank.cuts))
    checkpoint_records: list[dict] = []

    def inspect_exact(sweep: int, phase: str, color: int | None = None) -> bool:
        nonlocal first_sweep, first_phase, first_color, witness_bits, best_cut
        current_best = int(np.max(bank.cuts))
        best_cut = max(best_cut, current_best)
        if first_sweep is not None or current_best < target:
            return first_sweep is not None
        candidate = certified_hit_witness(inst, bank, target)
        if candidate is None:
            raise AssertionError("best-cut accounting disagrees with bank state")
        first_sweep = int(sweep)
        first_phase = phase
        first_color = color
        witness_bits = candidate
        return True

    inspect_exact(0, "initialization")
    sweeps_executed = 0
    for sweep_index in range(max_sweeps):
        if first_sweep is not None and stop_on_exact:
            break
        sweep = sweep_index + 1
        sweeps_executed = sweep
        for color in range(4):
            visits, fired, fresh, fresh_bits = update_color(
                inst,
                bank,
                betas,
                color,
                local_rng,
                method,
                epic_enabled,
                field_refresh_delta,
                max_hold_age,
                bit_reservoir,
            )
            total_updates += visits
            fired_cycles += fired
            local_fresh_words += fresh
            local_rng_bits += fresh_bits
            cuts = cut_many(inst, bank.state).reshape(copies, len(betas))
            bank.cuts[:] = cuts
            bank.energies[:] = energy_from_cut(inst, cuts)
            if inspect_exact(sweep, "local_color", color) and stop_on_exact:
                break
        if first_sweep is not None and stop_on_exact:
            pass
        elif icm_interval > 0 and sweep % icm_interval == 0:
            for temperature, beta in enumerate(betas):
                if beta < icm_beta_min:
                    continue
                cluster_attempts += 1
                accepted, size, words, reason = attempt_icm(
                    inst,
                    bank,
                    temperature,
                    icm_rng,
                    max_disagreement_fraction,
                    max_cluster_fraction,
                )
                icm_words += words
                if accepted:
                    cluster_accepts += 1
                    cluster_size_counts[size] += 1
                    if inspect_exact(sweep, "icm") and stop_on_exact:
                        break
                else:
                    cluster_rejections[reason] += 1
        if first_sweep is None or not stop_on_exact:
            phase = sweep_index & 1
            for copy in range(copies):
                for left in range(phase, len(betas) - 1, 2):
                    right = left + 1
                    probability = swap_probability(
                        float(betas[left]),
                        float(betas[right]),
                        int(bank.energies[copy, left]),
                        int(bank.energies[copy, right]),
                    )
                    word = fresh_u32(swap_rng)
                    swap_words += 1
                    swap_attempts += 1
                    adjacent_attempts[left] += 1
                    threshold = int(probability * U32_SCALE)
                    if probability >= 1.0 or word < threshold:
                        swap_accepts += 1
                        adjacent_accepts[left] += 1
                        exchange_replicas(bank, copy, left, right)
            tracker.observe(bank.walker_ids)
        if sweep in checkpoints or (first_sweep == sweep and stop_on_exact):
            checkpoint_records.append({
                "sweep": sweep,
                "exact_hit": int(first_sweep is not None),
                "replica_node_updates": total_updates,
                "local_fresh_rng_words": local_fresh_words,
                "swap_rng_words": swap_words,
                "icm_rng_words": icm_words,
                "total_rng_words": init_words + local_fresh_words + swap_words + icm_words,
                "fired_cycles": fired_cycles,
            })
        if first_sweep is not None and stop_on_exact:
            break

    elapsed_process = time.process_time() - started_process
    elapsed_wall = time.perf_counter() - started_wall
    peak_rss_raw = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    peak_rss_kib = int(peak_rss_raw / 1024) if sys.platform == "darwin" else int(peak_rss_raw)
    exact_hit = first_sweep is not None
    cluster_total = sum(size * count for size, count in cluster_size_counts.items())
    return {
        "instance": inst.name,
        "n": inst.n,
        "target": int(target),
        "target_kind": target_kind,
        "method": method,
        "trial": int(trial),
        "seed": int(seed),
        "temperatures": len(betas),
        "copies_per_temperature": copies,
        "replicas": copies * len(betas),
        "beta_ladder_id": ladder_id(betas),
        "beta_ladder_json": json.dumps(betas.tolist(), separators=(",", ":")),
        "icm_cadence": icm_interval,
        "icm_beta_min": icm_beta_min,
        "maximum_sweeps": int(max_sweeps),
        "sweeps_executed": int(sweeps_executed),
        "first_exact_hit_sweep": first_sweep,
        "first_exact_hit_phase": first_phase,
        "first_exact_hit_color": first_color,
        "exact_hit": int(exact_hit),
        "best_cut": int(best_cut),
        "exact_witness_bits": (
            "" if witness_bits is None else "".join(str(int(x)) for x in witness_bits)
        ),
        "exact_witness_sha256": "" if witness_bits is None else bits_sha256(witness_bits),
        "total_replica_node_updates": int(total_updates),
        "initialization_rng_words": int(init_words),
        "local_fresh_rng_words": int(local_fresh_words),
        "local_rng_bits_consumed": int(local_rng_bits),
        "local_rng_bits_unused": int(
            bit_reservoir.unused_bits if bit_reservoir is not None else 0
        ),
        "swap_rng_words": int(swap_words),
        "icm_rng_words": int(icm_words),
        "total_rng_words": int(init_words + local_fresh_words + swap_words + icm_words),
        "fired_cycles": int(fired_cycles),
        "swap_attempts": int(swap_attempts),
        "swap_accepts": int(swap_accepts),
        "adjacent_swap_attempts_json": json.dumps(adjacent_attempts.tolist()),
        "adjacent_swap_accepts_json": json.dumps(adjacent_accepts.tolist()),
        "cluster_attempts": int(cluster_attempts),
        "cluster_accepts": int(cluster_accepts),
        "cluster_size_sum": int(cluster_total),
        "cluster_size_mean": (
            cluster_total / cluster_accepts if cluster_accepts else None
        ),
        "cluster_size_max": max(cluster_size_counts, default=0),
        "cluster_sizes_histogram_json": json.dumps(
            {str(k): v for k, v in sorted(cluster_size_counts.items())},
            separators=(",", ":"),
        ),
        "cluster_rejections_json": json.dumps(
            dict(sorted(cluster_rejections.items())), separators=(",", ":")
        ),
        "round_trips": int(np.sum(tracker.counts)),
        "checkpoint_metrics_json": json.dumps(
            checkpoint_records, separators=(",", ":")
        ),
        "elapsed_process_seconds": elapsed_process,
        "elapsed_wall_seconds": elapsed_wall,
        "process_peak_rss_kib": peak_rss_kib,
        "epic_enabled": int(epic_enabled),
        "field_refresh_delta": field_refresh_delta,
        "max_hold_age": max_hold_age,
        "stop_on_exact": int(stop_on_exact),
        "instance_digest": instance_digest(inst),
        "final_state_sha256": hashlib.sha256(bank.state.tobytes()).hexdigest(),
    }
