#!/usr/bin/env python3
"""Integer native Chimera model with explicit physical RNG substitution."""
from __future__ import annotations
import hashlib
import inspect
import json
import math
from pathlib import Path
import random
import sys
import numpy as np
ROOT = Path(__file__).resolve().parent
NATIVE = ROOT.parents[1] / 'software' / 'chimera_native'
GRAPH = json.loads((ROOT / 'graph.json').read_text())
SPEC = json.loads((ROOT / 'software_spec.json').read_text())
EDGES = GRAPH['edges']
COLORS = np.asarray(GRAPH['colors'])
GROUPS = [np.flatnonzero(COLORS == c) for c in (0, 1)]
NORMALIZER = max(abs(w) for _, _, w in EDGES)
assert NORMALIZER == 3
ADJ = np.zeros((128, 128), dtype=np.int16)
for u, v, w in EDGES:
    ADJ[u, v] = ADJ[v, u] = w
LUT = np.asarray([min(round((1 / (1 + math.exp(-i / 4))) * 2**32), 2**32-1) if i <= 83 else 2**32-1 for i in range(128)], dtype=np.uint64)
# The 32-step transform is affine over bits. Table chunks speed reference only;
# generated RTL applies the recurrence directly, without any trajectory table.
def advance_scalar(value):
    for _ in range(32):
        value = ((value << 1) | (1 ^ ((value >> 31) ^ (value >> 21) ^ (value >> 1) ^ value) & 1)) & 0xffffffff
    return value
OFFSET = advance_scalar(0)
ADVANCE_TABLE = np.asarray([[advance_scalar(v << (8*b)) ^ OFFSET for v in range(256)] for b in range(4)], dtype=np.uint32)
def advance(values):
    out = np.full(values.shape, OFFSET, dtype=np.uint32)
    for b in range(4):
        out ^= ADVANCE_TABLE[b, (values >> (8*b)) & 255]
    return out

def score(state):
    return sum(w * int(state[u] != state[v]) for u, v, w in EDGES)

def initial(trial):
    seed = 2026091401280000 + trial
    rng = random.Random(seed)
    seeds = np.asarray([rng.getrandbits(32) for _ in range(128)], dtype=np.uint32)
    seeds[seeds == 0xffffffff] = 0 # XNOR all-ones lock-up is excluded.
    init_words = np.asarray([rng.getrandbits(32) for _ in range(128)], dtype=np.uint64)
    return seed, seeds, init_words

def run(trial, mode, sweeps_per_beta=937, beta_count=14):
    seed, seeds, init_words = initial(trial)
    state = (init_words & 1).astype(np.int8)
    initial_state = state.copy()
    rng = seeds.copy()
    saved = np.zeros(128, dtype=np.int16)
    age = np.zeros(128, dtype=np.uint16)
    valid = np.zeros(128, dtype=bool)
    best = score(state)
    first = 0 if best == 68 else 0xffffffff
    witness = state.copy() if best == 68 else np.zeros(128, dtype=np.int8)
    events = []
    batches = []
    policy_events = []
    words = fired = fresh_flips = cached_flips = visits = cached = 0
    events.append((0, state.copy(), best, best, words, visits, fired, first))
    sweep = 0
    for beta_step in range(1, beta_count + 1):
        for _ in range(sweeps_per_beta):
            sweep += 1
            for color, group in enumerate(GROUPS):
                raw = -(ADJ[group] @ (2*state.astype(np.int16)-1))
                numerator = (raw * beta_step).astype(np.int16)
                address = np.minimum((4*np.abs(numerator)+1)//3, 127)
                nonnegative = numerator >= 0
                refresh = (~valid[group]) | (state[group] != nonnegative) | (saved[group] != numerator) | (age[group] >= 2)
                if mode == 'baseline':
                    refresh[:] = True
                fresh_nodes = group[refresh]
                if len(fresh_nodes):
                    rng[fresh_nodes] = advance(rng[fresh_nodes])
                    batches.append(rng[fresh_nodes].astype(np.uint64).copy())
                selected_words = rng[group].astype(np.uint64)
                samples = np.where(nonnegative, LUT[address] > selected_words, selected_words > LUT[address]).astype(np.int8)
                flip = samples != state[group]
                fire = refresh | flip
                words += int(refresh.sum())
                visits += len(group)
                cached += int((~refresh).sum())
                fired += int(fire.sum())
                fresh_flips += int((flip & refresh).sum())
                cached_flips += int((flip & ~refresh).sum())
                state[group] = samples
                saved[fresh_nodes] = numerator[refresh]
                valid[fresh_nodes] = True
                age[fresh_nodes] = 0
                age[group[~refresh]] += 1
                policy_events.append((refresh.copy(), numerator.copy(), age[group].copy()))
                current = score(state)
                assert current <= 68
                best = max(best, current)
                if current == 68 and first == 0xffffffff:
                    first = sweep
                    witness = state.copy()
                events.append((1 + color, state.copy(), current, best, words, visits, fired, first))
    result = dict(trial=trial, seed=seed, mode=mode, success=int(first != 0xffffffff), final_success=int(score(state) == 68),
        best_cut=best, final_cut=score(state), first_exact_sweep=first, sweeps=sweep,
        local_words=words, visits=visits, fired_cycles=fired, fresh_flips=fresh_flips, cached_flips=cached_flips,
        cached_events=cached, initial_state_sha256=hashlib.sha256(initial_state.tobytes()).hexdigest(),
        seed_state_sha256=hashlib.sha256(seeds.astype('<u4').tobytes()).hexdigest(),
        final_state_sha256=hashlib.sha256(state.tobytes()).hexdigest())
    return dict(result=result, seeds=seeds, init_words=init_words, initial=initial_state, final=state, witness=witness, events=events, batches=batches, policy_events=policy_events)

def validate_native(record, sweeps_per_beta=937, beta_count=14):
    """Inject lane-selected raw words into unchanged native update operations.

    A read-only observer is inserted immediately after native group scoring;
    all state, threshold, refresh, age and score operations remain native.
    """
    sys.path.insert(0, str(NATIVE))
    import frustrated_loop_sa_dual_v4 as native
    import frustrated_loop_instances as instances
    import apt_icm
    instance = instances._build_instance(GRAPH['name'], 4, {(u, v): w for u, v, w in EDGES})
    assert np.array_equal(instance.colors, COLORS)
    assert np.array_equal(LUT, apt_icm.LUT_TABLE)
    for step in range(1, 15):
        for raw in range(-10, 11):
            integer_address = min((4 * abs(step*raw) + 1)//3, 127)
            native_address = abs(int(np.clip(np.rint(8*(step/2)*raw/3), -127, 127)))
            assert integer_address == native_address
    index = 0
    batch_index = 0
    def fresh(_rng, size=None):
        nonlocal batch_index
        if _rng == 1:
            assert size == 128
            return record['init_words'].copy()
        if batch_index >= len(record['batches']):
            raise AssertionError('native requested extra fresh-word batch')
        values = record['batches'][batch_index]
        batch_index += 1
        assert size == len(values), (batch_index, size, len(values))
        return values.copy()
    def observe(state, current_cut, sweep, color, local_words, visits, fired_cycles, refresh, bfield, field_input, age_group):
        nonlocal index
        index += 1
        event = record['events'][index]
        mask, numerator, expected_age = record['policy_events'][index-1]
        assert np.array_equal(mask, refresh), ('native refresh mask', index)
        assert np.allclose(numerator/6, bfield, rtol=0, atol=1e-14), ('native unrounded field', index)
        expected_input = np.minimum((4*np.abs(numerator)+1)//3, 127)*np.where(numerator>=0,1,-1)
        assert np.array_equal(expected_input, field_input), ('native quantized field', index)
        assert np.array_equal(expected_age, age_group), ('native age', index)
        assert event[0] == color+1 and np.array_equal(event[1], state), ('native state', index)
        assert (event[2], event[4], event[5], event[6]) == (current_cut, local_words, visits, fired_cycles), ('native counters', index)
    namespace = dict(vars(native), fresh_u32=fresh, stream_rng=lambda seed, stream: stream, observe=observe)
    code = inspect.getsource(native.run_colored_anneal_dual)
    marker = '                current_cut += delta\n'
    assert code.count(marker) == 1
    code = code.replace(marker, marker + '                observe(state, current_cut, sweep, color, local_words, visits, fired_cycles, refresh, bfield, field_input, age[group])\n')
    exec(compile(code, str(NATIVE / 'frustrated_loop_sa_dual_v4.py'), 'exec'), namespace)
    out = namespace['run_colored_anneal_dual'](inst=instance, target=68, trial=record['result']['trial'], seed=record['result']['seed'],
        method='iid_sa' if record['result']['mode']=='baseline' else 'epic_sa', beta_values=[i/2 for i in range(1,beta_count+1)],
        sweeps_per_beta=sweeps_per_beta, field_refresh_delta=.05, max_hold_age=2)
    checks = {'best_cut':'best_cut','final_cut':'final_cut','exact_hit':'success','final_exact_hit':'final_success',
        'local_fresh_rng_words':'local_words','total_node_visits':'visits','fired_cycles':'fired_cycles','fresh_flips':'fresh_flips',
        'cached_flips':'cached_flips','cached_events':'cached_events','final_state_sha256':'final_state_sha256'}
    for native_key, own_key in checks.items():
        assert out[native_key] == record['result'][own_key], (native_key, out[native_key], record['result'][own_key])
    assert (out['first_exact_hit_sweep'] if out['first_exact_hit_sweep'] is not None else 0xffffffff) == record['result']['first_exact_sweep']
    assert out['exact_witness_bits'] == (''.join(map(str, record['witness'])) if out['exact_hit'] else '')
    assert index == len(record['events'])-1 and batch_index == len(record['batches'])
    return dict(passed=True, compared_color_states=index, checked_fresh_batches=batch_index, native_source_sha256=hashlib.sha256((NATIVE/'frustrated_loop_sa_dual_v4.py').read_bytes()).hexdigest(), injected_physical_rng=True)
