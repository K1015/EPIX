#!/usr/bin/env python3
"""Certified planted frustrated-loop instances on Chimera graphs.

Each loop clause contains exactly one inconsistent signed edge relative to a
planted spin assignment.  A cycle cannot satisfy every edge of such a clause,
while the planted assignment satisfies all but the inconsistent edge.  The
planted assignment therefore maximizes every clause separately and is a
certificate for the optimum of their sum, including after duplicate edge
weights are aggregated.
"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from itertools import product

import numpy as np

from apt_icm import KingsInstance, cut_bits_adjacency, cut_bits_direct


@dataclass(frozen=True)
class FrustratedLoopRecord:
    instance: KingsInstance
    planted_bits: np.ndarray
    target: int
    certificate: dict


def chimera_node(side: int, row: int, col: int, shore: int, index: int) -> int:
    if not (
        0 <= row < side and 0 <= col < side
        and shore in (0, 1) and 0 <= index < 4
    ):
        raise ValueError("invalid Chimera coordinate")
    return (((row * side + col) * 2 + shore) * 4 + index)


def chimera_edges(side: int) -> list[tuple[int, int]]:
    """Return the standard open-boundary C_side Chimera edge set."""
    if side < 1:
        raise ValueError("Chimera side must be positive")
    edges: list[tuple[int, int]] = []
    for row in range(side):
        for col in range(side):
            for left in range(4):
                for right in range(4):
                    edges.append((
                        chimera_node(side, row, col, 0, left),
                        chimera_node(side, row, col, 1, right),
                    ))
            if row + 1 < side:
                for index in range(4):
                    edges.append((
                        chimera_node(side, row, col, 0, index),
                        chimera_node(side, row + 1, col, 0, index),
                    ))
            if col + 1 < side:
                for index in range(4):
                    edges.append((
                        chimera_node(side, row, col, 1, index),
                        chimera_node(side, row, col + 1, 1, index),
                    ))
    return sorted((min(u, v), max(u, v)) for u, v in edges)


def chimera_adjacency(side: int) -> tuple[tuple[int, ...], ...]:
    n = 8 * side * side
    adjacency: list[list[int]] = [[] for _ in range(n)]
    for u, v in chimera_edges(side):
        adjacency[u].append(v)
        adjacency[v].append(u)
    return tuple(tuple(sorted(neighbors)) for neighbors in adjacency)


def _sample_cycle(
    adjacency: tuple[tuple[int, ...], ...],
    rng: np.random.Generator,
    min_length: int,
    max_length: int,
    max_attempts: int = 20_000,
) -> tuple[int, ...]:
    """Sample a simple cycle via a non-backtracking random walk."""
    if min_length < 4 or max_length < min_length:
        raise ValueError("loop bounds must satisfy 4 <= min <= max")
    n = len(adjacency)
    for _ in range(max_attempts):
        start = int(rng.integers(n))
        path = [start]
        positions = {start: 0}
        previous = -1
        while len(path) <= max(4 * max_length, n):
            current = path[-1]
            choices = [node for node in adjacency[current] if node != previous]
            if not choices:
                break
            nxt = int(choices[int(rng.integers(len(choices)))])
            if nxt in positions:
                cycle = tuple(path[positions[nxt]:])
                if min_length <= len(cycle) <= max_length:
                    return cycle
                break
            positions[nxt] = len(path)
            path.append(nxt)
            previous = current
    raise RuntimeError(
        f"failed to sample a cycle of length [{min_length}, {max_length}]"
    )


def _cycle_edges(cycle: tuple[int, ...]) -> tuple[tuple[int, int], ...]:
    return tuple(
        (min(cycle[index], cycle[(index + 1) % len(cycle)]),
         max(cycle[index], cycle[(index + 1) % len(cycle)]))
        for index in range(len(cycle))
    )


def _build_instance(
    name: str,
    side: int,
    weights: dict[tuple[int, int], int],
) -> KingsInstance:
    n = 8 * side * side
    active = sorted((edge, weight) for edge, weight in weights.items() if weight)
    edge_u = np.asarray([edge[0][0] for edge in active], dtype=np.int32)
    edge_v = np.asarray([edge[0][1] for edge in active], dtype=np.int32)
    edge_w = np.asarray([edge[1] for edge in active], dtype=np.int16)
    neigh_idx = np.full((n, 8), n, dtype=np.int32)
    neigh_w = np.zeros((n, 8), dtype=np.int16)
    fill = np.zeros(n, dtype=np.int8)
    adjacency_lists: list[list[int]] = [[] for _ in range(n)]
    for raw_u, raw_v, raw_w in zip(edge_u, edge_v, edge_w):
        u, v, weight = int(raw_u), int(raw_v), int(raw_w)
        for source, destination in ((u, v), (v, u)):
            slot = int(fill[source])
            if slot >= 8:
                raise AssertionError("Chimera degree exceeded solver storage")
            neigh_idx[source, slot] = destination
            neigh_w[source, slot] = weight
            fill[source] += 1
            adjacency_lists[source].append(destination)

    colors = np.empty(n, dtype=np.int8)
    for row, col, shore, index in product(range(side), range(side), range(2), range(4)):
        node = chimera_node(side, row, col, shore, index)
        colors[node] = (row + col + shore) & 1
    if any(colors[u] == colors[v] for u, v in zip(edge_u, edge_v)):
        raise AssertionError("Chimera coloring is not proper")
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
        adjacency=tuple(tuple(sorted(values)) for values in adjacency_lists),
    )


def make_frustrated_loop_instance(
    *,
    name: str,
    side: int,
    alpha: float,
    min_loop_length: int,
    max_loop_length: int,
    seed: int,
) -> FrustratedLoopRecord:
    """Generate one planted instance and its compositional optimum proof."""
    if alpha <= 0:
        raise ValueError("alpha must be positive")
    n = 8 * side * side
    clause_count = max(1, int(round(alpha * n)))
    rng = np.random.default_rng(seed)
    planted = rng.integers(0, 2, size=n, dtype=np.int8)
    topology = set(chimera_edges(side))
    adjacency = chimera_adjacency(side)
    aggregate: dict[tuple[int, int], int] = {}
    clause_records = []
    sum_clause_max = 0

    for clause_index in range(clause_count):
        cycle = _sample_cycle(
            adjacency, rng, min_loop_length, max_loop_length
        )
        edges = _cycle_edges(cycle)
        if len(set(edges)) != len(edges) or any(edge not in topology for edge in edges):
            raise AssertionError("sampled walk is not a simple Chimera cycle")
        frustrated_slot = int(rng.integers(len(edges)))
        signed_weights = []
        for slot, edge in enumerate(edges):
            u, v = edge
            weight = 1 if planted[u] != planted[v] else -1
            if slot == frustrated_slot:
                weight = -weight
            signed_weights.append(weight)
            aggregate[edge] = aggregate.get(edge, 0) + weight

        negative_edges = sum(weight < 0 for weight in signed_weights)
        clause_max = len(edges) - 1 - negative_edges
        clause_value = sum(
            weight * int(planted[u] != planted[v])
            for (u, v), weight in zip(edges, signed_weights)
        )
        if clause_value != clause_max:
            raise AssertionError("planted assignment does not maximize loop clause")
        sum_clause_max += clause_max
        clause_records.append({
            "clause": clause_index,
            "length": len(edges),
            "frustrated_slot": frustrated_slot,
            "negative_edges": negative_edges,
            "maximum_signed_cut": clause_max,
        })

    inst = _build_instance(name, side, aggregate)
    target_direct = cut_bits_direct(inst, planted)
    target_adjacency = cut_bits_adjacency(inst, planted)
    if target_direct != sum_clause_max or target_adjacency != sum_clause_max:
        raise AssertionError("compositional planted certificate did not rescore")
    active_weights = [abs(int(value)) for value in aggregate.values() if value]
    certificate_payload = {
        "schema": "planted_frustrated_loop_certificate_v1",
        "proof": (
            "Each simple cycle has one inconsistent parity edge, so at most "
            "length-1 signed constraints can be satisfied. The planted state "
            "satisfies exactly length-1 in every clause; summing clause maxima "
            "therefore certifies the aggregate optimum."
        ),
        "seed": int(seed),
        "side": int(side),
        "n": int(n),
        "alpha": float(alpha),
        "clause_count": int(clause_count),
        "loop_length_bounds": [int(min_loop_length), int(max_loop_length)],
        "loop_length_histogram": {
            str(length): sum(row["length"] == length for row in clause_records)
            for length in sorted({row["length"] for row in clause_records})
        },
        "sum_clause_maximum_signed_cut": int(sum_clause_max),
        "planted_direct_cut": int(target_direct),
        "planted_adjacency_cut": int(target_adjacency),
        "active_edges": len(inst.edge_u),
        "cancelled_edges": sum(value == 0 for value in aggregate.values()),
        "maximum_absolute_coupling": max(active_weights, default=0),
        "planted_bits_sha256": hashlib.sha256(planted.tobytes()).hexdigest(),
    }
    certificate_payload["certificate_sha256"] = hashlib.sha256(
        json.dumps(certificate_payload, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()
    return FrustratedLoopRecord(
        instance=inst,
        planted_bits=planted,
        target=int(sum_clause_max),
        certificate=certificate_payload,
    )


def brute_force_maximum(inst: KingsInstance) -> int:
    """Independent exhaustive oracle for unit tests on tiny instances."""
    if inst.n > 24:
        raise ValueError("brute-force oracle is restricted to n <= 24")
    best = -10**18
    for value in range(1 << inst.n):
        bits = np.fromiter(
            ((value >> index) & 1 for index in range(inst.n)),
            dtype=np.int8,
            count=inst.n,
        )
        best = max(best, cut_bits_direct(inst, bits))
    return int(best)
