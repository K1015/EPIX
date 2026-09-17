"""Generate SAT and XOR-SAT reference traces."""

import hashlib
import json
import math
import random

BETAS = [0.25 + 7.75 * k / 15 for k in range(16)]


def check_instance(d):
    """Check node indices, weights and factor data."""
    n = d['n']
    assert isinstance(n, int) and n > 0
    assert d['family'] in ('sat', 'xorsat')
    assert d['factors']
    for f in d['factors']:
        assert len(f['nodes']) == len(set(f['nodes'])) == 3
        assert all(isinstance(i, int) and 0 <= i < n for i in f['nodes'])
        assert isinstance(f['weight'], int) and f['weight'] > 0
        if d['family'] == 'sat':
            assert len(f['signs']) == 3 and all(s in (-1, 1) for s in f['signs'])
        else:
            assert f['parity'] in (0, 1)


def energy(d, bits):
    """Calculate the problem objective. This is not electrical energy."""
    assert len(bits) == d['n'] and all(b in (0, 1) for b in bits)
    if d['family'] == 'sat':
        return sum(
            f['weight']
            for f in d['factors']
            if not any(bits[i] == (s > 0) for i, s in zip(f['nodes'], f['signs']))
        )
    return sum(
        f['weight']
        for f in d['factors']
        if (sum(bits[i] for i in f['nodes']) & 1) != f['parity']
    )


def compiled_rows(d):
    """Group each site's neighboring factors."""
    out = [[] for _ in range(d['n'])]
    for f in d['factors']:
        for k, i in enumerate(f['nodes']):
            other = [j for j in range(3) if j != k]
            a, b = [f['nodes'][j] for j in other]
            if d['family'] == 'sat':
                out[i].append(
                    (
                        a,
                        b,
                        int(f['signs'][other[0]] > 0),
                        int(f['signs'][other[1]] > 0),
                        f['weight'] * f['signs'][k],
                    )
                )
            else:
                out[i].append((a, b, f['parity'], f['weight']))
    return out


def fast_q(family, row, bits):
    if family == 'sat':
        return sum(w for a, b, va, vb, w in row if bits[a] != va and bits[b] != vb)
    return sum(w * (2 * (parity ^ bits[a] ^ bits[b]) - 1) for a, b, parity, w in row)


def threshold32(beta, q):
    z = beta * q
    if z >= 0:
        p = 1.0 / (1.0 + math.exp(-z))
    else:
        e = math.exp(z)
        p = e / (1.0 + e)
    return min(1 << 32, max(0, int(p * (1 << 32) + 0.5)))


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def seed32(seed, domain):
    return int.from_bytes(
        hashlib.sha256(f'{seed}:{domain}'.encode()).digest()[:4], 'little'
    )


def next_word(x):
    assert 0 < x < 2**32
    return ((x << 1) & 0xFFFFFFFF) | (((x >> 31) ^ (x >> 21) ^ (x >> 1) ^ x) & 1)


def words(bits):
    return [
        sum(b << i for i, b in enumerate(bits[k : k + 32]))
        for k in range(0, len(bits), 32)
    ]


def generate_trace(d, case, rows, seed, mode, sweeps):
    """Run one reference trial and save its expected updates."""
    n = d['n']
    init = random.Random(seed32(seed, 'initialization'))
    bits = [init.getrandbits(1) for _ in range(n)]
    initial = bits.copy()
    rng = [seed32(seed, f'A2:pbit:{i}') or 1 for i in range(n)]
    assert len(set(rng)) == n
    initial_rng = rng.copy()
    saved = [0] * n
    ages = [0] * n
    valid = [False] * n
    e = energy(d, bits)
    initial_e = e
    best = e
    best_bits = bits.copy()
    visits = fresh = reuse = 0
    reads = len(d['factors'])
    name = f'{mode}_{seed}_{sweeps}'
    trace_path = case / (name + '.trace')
    bound = max(sum(abs(x[-1]) for x in row) for row in rows)
    refresh_reasons = dict(
        fresh_mode=0, invalid=0, misaligned=0, field_drift=0, age_limit=0
    )
    with trace_path.open('w') as trace:
        for bi, beta in enumerate(BETAS):
            if e == 0:
                break
            valid = [False] * n
            ages = [0] * n
            lut = {q: threshold32(beta, q) for q in range(-bound, bound + 1)}
            for sweep in range(sweeps):
                if e == 0:
                    break
                for site in range(n):
                    q = fast_q(d['family'], rows[site], bits)
                    old = bits[site]
                    reason = (
                        'fresh_mode'
                        if mode == 'fresh'
                        else (
                            'invalid'
                            if not valid[site]
                            else (
                                'misaligned'
                                if old != int(q >= 0)
                                else (
                                    'field_drift'
                                    if abs(q - saved[site]) >= 2
                                    else 'age_limit' if ages[site] >= 2 else None
                                )
                            )
                        )
                    )
                    refresh = reason is not None
                    if refresh:
                        rng[site] = next_word(rng[site])
                        saved[site] = q
                        ages[site] = 0
                        valid[site] = True
                        fresh += 1
                        refresh_reasons[reason] += 1
                    else:
                        ages[site] += 1
                        reuse += 1
                    new = int(rng[site] < lut[q])
                    bits[site] = new
                    if old != new:
                        e += q if old else -q
                    if e < best:
                        best = e
                        best_bits = bits.copy()
                    visits += 1
                    reads += 1 + len(rows[site])
                    clear = int(
                        site == n - 1 and sweep == sweeps - 1 and bi != 15 and e != 0
                    )
                    trace.write(
                        ' '.join(
                            map(
                                str,
                                [
                                    visits,
                                    site,
                                    q,
                                    old,
                                    new,
                                    e,
                                    rng[site],
                                    bi,
                                    int(refresh),
                                    clear,
                                ],
                            )
                        )
                        + '\n'
                    )
                    if e == 0:
                        break
                assert e == energy(d, bits)
    assert best == energy(d, best_bits)
    header = [
        n,
        sweeps,
        int(mode == 'epix'),
        visits,
        initial_e,
        e,
        best,
        reads,
        *words(initial),
        *initial_rng,
        *words(bits),
        *words(best_bits),
    ]
    (case / (name + '.header')).write_text(' '.join(map(str, header)) + '\n')
    result = dict(
        case=d['name'],
        seed=seed,
        mode=mode,
        sweeps_per_beta=sweeps,
        betas=BETAS,
        visits=visits,
        fresh_words=fresh,
        reuse_events=reuse,
        coefficient_reads=reads,
        success=best == 0,
        best_energy=best,
        final_energy=e,
        initial_bits=initial,
        best_bits=best_bits,
        final_bits=bits,
        refresh_reasons=refresh_reasons,
        trace_sha256=sha(trace_path),
        header_sha256=sha(case / (name + '.header')),
        scope='Software reference; no physical power or area measurement.',
    )
    (case / (name + '.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(
        json.dumps(
            {
                k: result[k]
                for k in (
                    'case',
                    'seed',
                    'mode',
                    'sweeps_per_beta',
                    'visits',
                    'success',
                    'fresh_words',
                    'reuse_events',
                )
            }
        ),
        flush=True,
    )
