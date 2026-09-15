#!/usr/bin/env python3
"""Frozen colored-Gibbs annealer with best-so-far and final-state scoring."""

from __future__ import annotations

import hashlib
import json

import numpy as np

from apt_icm import (
    AGE_COUNTER_MAX,
    FIELD_LIMIT,
    FIELD_SCALE,
    LUT_TABLE,
    U32_MASK,
    bits_sha256,
    cut_bits_adjacency,
    cut_bits_direct,
    fresh_u32,
    instance_digest,
    stream_rng,
)
from exact_bit_rng import ExactBitReservoir


METHODS = {
    "iid_sa",
    "epic_sa",
    "guarded_rescue4_sa",
    "exact_bit_sa",
}


def _rescue_active(sweep: int) -> bool:
    return (sweep - 1) % 4 == 3


def run_colored_anneal_dual(
    *,
    inst,
    target: int,
    trial: int,
    seed: int,
    method: str,
    beta_values,
    sweeps_per_beta: int,
    field_refresh_delta: float = 0.05,
    max_hold_age: int = 2,
) -> dict:
    """Run one fixed-budget trajectory and retain both scoring conventions.

    ``exact_hit`` and ``best_cut`` are best-so-far quantities.  ``final_cut``
    and ``final_exact_hit`` score only the state after the final sweep.  Both
    witnesses are retained so an evaluator can rescore them independently.
    """
    if method not in METHODS:
        raise ValueError(f"unknown annealing method {method}")
    if sweeps_per_beta < 1:
        raise ValueError("sweeps_per_beta must be positive")
    betas = tuple(float(value) for value in beta_values)
    if not betas or any(value <= 0 for value in betas):
        raise ValueError("beta schedule must be positive")
    normalizer = max((abs(int(value)) for value in inst.edge_w), default=0)
    if normalizer < 1:
        raise ValueError("instance has no active coupling")

    init_rng = stream_rng(seed, 1)
    local_rng = stream_rng(seed, 2)
    init_words = fresh_u32(init_rng, inst.n)
    state = (init_words & np.uint64(1)).astype(np.int8)
    initialization_hash = hashlib.sha256(state.tobytes()).hexdigest()
    stored_word = np.zeros(inst.n, dtype=np.uint64)
    stored_bfield = np.zeros(inst.n, dtype=np.float64)
    age = np.zeros(inst.n, dtype=np.uint16)
    valid = np.zeros(inst.n, dtype=bool)
    reservoir = ExactBitReservoir(local_rng) if method == "exact_bit_sa" else None

    local_words = 0
    local_bits = 0
    visits = 0
    fired_cycles = 0
    fresh_flips = 0
    cached_flips = 0
    fresh_events = 0
    cached_events = 0
    first_exact_sweep = None
    best_witness = None
    current_cut = cut_bits_direct(inst, state)
    best_cut = current_cut
    if best_cut == target:
        first_exact_sweep = 0
        best_witness = state.copy()

    sweep = 0
    for beta in betas:
        for _ in range(sweeps_per_beta):
            sweep += 1
            in_rescue = method == "guarded_rescue4_sa" and _rescue_active(sweep)
            for color in (0, 1):
                group = np.flatnonzero(inst.colors == color)
                spins = 2 * state.astype(np.int16) - 1
                spins_pad = np.concatenate((spins, np.zeros(1, dtype=np.int16)))
                neighbors = inst.neigh_idx[group]
                raw_local = -np.sum(
                    inst.neigh_w[group] * spins_pad[neighbors],
                    axis=1,
                    dtype=np.int32,
                )
                bfield = beta * raw_local.astype(np.float64) / float(normalizer)
                field_input = np.clip(
                    np.rint(FIELD_SCALE * bfield), -FIELD_LIMIT, FIELD_LIMIT
                ).astype(np.int16)
                threshold = LUT_TABLE[np.abs(field_input)]
                nonnegative = field_input >= 0
                current = state[group]
                before_group = current.copy()
                visits += len(group)

                if method == "exact_bit_sa":
                    assert reservoir is not None
                    words_before = reservoir.words_drawn
                    bits_before = reservoir.bits_consumed
                    positive = threshold.astype(np.uint64)
                    negative = np.uint64(U32_MASK) - threshold.astype(np.uint64)
                    counts = np.where(nonnegative, positive, negative)
                    next_state = np.fromiter(
                        (int(reservoir.bernoulli_count(int(count))) for count in counts),
                        dtype=np.int8,
                        count=len(group),
                    )
                    local_words += reservoir.words_drawn - words_before
                    local_bits += reservoir.bits_consumed - bits_before
                    fresh_events += len(group)
                    flips = next_state != current
                    fresh_flips += int(np.sum(flips))
                    fired_cycles += len(group)
                    state[group] = next_state
                else:
                    supported = nonnegative == (current == 1)
                    changed = np.abs(bfield - stored_bfield[group]) >= field_refresh_delta
                    expired = age[group] >= max_hold_age
                    use_epic = method in {"epic_sa", "guarded_rescue4_sa"} and not in_rescue
                    refresh = (~valid[group]) | (~supported) | changed | expired
                    if not use_epic:
                        refresh = np.ones(len(group), dtype=bool)
                    fresh_count = int(np.sum(refresh))
                    candidates = np.zeros(len(group), dtype=np.uint64)
                    if fresh_count:
                        candidates[refresh] = fresh_u32(local_rng, fresh_count)
                    local_words += fresh_count
                    local_bits += 32 * fresh_count
                    words = np.where(refresh, candidates, stored_word[group])
                    next_state = np.where(
                        nonnegative, threshold > words, words > threshold
                    ).astype(np.int8)
                    skip = use_epic & (~refresh) & (next_state == current)
                    fire = ~skip
                    flip = fire & (next_state != current)
                    fresh_events += fresh_count
                    cached_events += int(np.sum(~refresh))
                    fresh_flips += int(np.sum(flip & refresh))
                    cached_flips += int(np.sum(flip & (~refresh)))
                    fired_cycles += int(np.sum(fire))
                    current[fire] = next_state[fire]
                    state[group] = current
                    refreshed_nodes = group[refresh]
                    reused_nodes = group[~refresh]
                    if len(refreshed_nodes):
                        stored_word[refreshed_nodes] = candidates[refresh]
                        stored_bfield[refreshed_nodes] = bfield[refresh]
                        age[refreshed_nodes] = 0
                        valid[refreshed_nodes] = True
                    if len(reused_nodes):
                        age[reused_nodes] = np.minimum(
                            age[reused_nodes].astype(np.uint32) + 1,
                            AGE_COUNTER_MAX,
                        ).astype(np.uint16)

                state_pad = np.concatenate((state, np.zeros(1, dtype=np.int8)))
                neighbor_bits = state_pad[neighbors]
                before_disagreement = before_group[:, None] != neighbor_bits
                after_disagreement = state[group, None] != neighbor_bits
                delta = int(np.sum(
                    inst.neigh_w[group].astype(np.int64)
                    * (
                        after_disagreement.astype(np.int64)
                        - before_disagreement.astype(np.int64)
                    )
                ))
                current_cut += delta
                if current_cut > target:
                    raise AssertionError("annealer exceeded certified optimum")
                if current_cut > best_cut:
                    best_cut = current_cut
                if first_exact_sweep is None and current_cut == target:
                    first_exact_sweep = sweep
                    best_witness = state.copy()

    final_cut_direct = cut_bits_direct(inst, state)
    final_cut_adjacency = cut_bits_adjacency(inst, state)
    if current_cut != final_cut_direct or final_cut_direct != final_cut_adjacency:
        raise AssertionError("final-state incremental or independent scoring drifted")
    if best_witness is not None:
        if not (
            cut_bits_direct(inst, best_witness) == target
            and cut_bits_adjacency(inst, best_witness) == target
        ):
            raise AssertionError("best-so-far witness failed independent rescoring")
    final_exact = final_cut_direct == target
    if final_exact and first_exact_sweep is None:
        raise AssertionError("final-state hit was not present in best-so-far history")

    final_bits = "".join(str(int(value)) for value in state)
    total_sweeps = len(betas) * sweeps_per_beta
    return {
        "instance": inst.name,
        "instance_digest": instance_digest(inst),
        "n": inst.n,
        "target": int(target),
        "target_kind": "exact_planted",
        "method": method,
        "trial": int(trial),
        "seed": int(seed),
        "beta_values_json": json.dumps(betas, separators=(",", ":")),
        "sweeps_per_beta": int(sweeps_per_beta),
        "total_sweeps": int(total_sweeps),
        "normalization_max_abs_coupling": int(normalizer),
        "field_refresh_delta": float(field_refresh_delta),
        "max_hold_age": int(max_hold_age),
        "first_exact_hit_sweep": first_exact_sweep,
        "exact_hit": int(first_exact_sweep is not None),
        "best_cut": int(best_cut),
        "exact_witness_bits": "" if best_witness is None else "".join(str(int(value)) for value in best_witness),
        "exact_witness_sha256": "" if best_witness is None else bits_sha256(best_witness),
        "final_cut": int(final_cut_direct),
        "final_exact_hit": int(final_exact),
        "final_state_bits": final_bits,
        "final_state_sha256": bits_sha256(state),
        "initialization_rng_words": int(inst.n),
        "local_fresh_rng_words": int(local_words),
        "local_rng_bits_consumed": int(local_bits),
        "local_rng_bits_unused": int(reservoir.unused_bits if reservoir is not None else 0),
        "total_rng_words": int(inst.n + local_words),
        "total_node_visits": int(visits),
        "fired_cycles": int(fired_cycles),
        "fresh_events": int(fresh_events),
        "cached_events": int(cached_events),
        "fresh_flips": int(fresh_flips),
        "cached_flips": int(cached_flips),
        "initial_state_sha256": initialization_hash,
        "best_so_far_scoring": True,
        "final_state_scoring": True,
    }
