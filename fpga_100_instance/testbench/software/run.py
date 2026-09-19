#!/usr/bin/env python3
"""Run paired IID/EPIX software trials using the shared-LFSR specification."""
import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import statistics
import time
from native_reference import Reference

ROOT = Path(__file__).resolve().parents[2]
MASK = (1 << 32) - 1


def read(p):
    return json.loads(p.read_text())


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def advance_slow(x):
    for _ in range(32):
        x = (x >> 1) ^ (0x80200003 if x & 1 else 0)
    return x


# Equivalent T^32 linear transform, accelerated without changing the word stream.
JUMP = [[advance_slow(v << (8 * j)) for v in range(256)] for j in range(4)]


class Source:
    def __init__(self, seed):
        self.state = seed & MASK or 0xA5C36EFE
        self.calls = 0

    def word(self):
        x = self.state
        self.state = (
            JUMP[0][x & 255]
            ^ JUMP[1][(x >> 8) & 255]
            ^ JUMP[2][(x >> 16) & 255]
            ^ JUMP[3][x >> 24]
        )
        self.calls += 1
        return self.state


def pack(bits):
    return sum(b << i for i, b in enumerate(bits))


def energy(J, bits):
    return -sum(
        J[i][j] * (2 * bits[i] - 1) * (2 * bits[j] - 1)
        for i in range(len(bits))
        for j in range(i + 1, len(bits))
    )


def graph_trial(p, par, qrom, thresholds, seed, mode, target):
    n = p['n_pbits']
    J = p['J']
    source = Source(seed)

    # Draw the initial state before starting either sampling policy.
    bits = [source.word() & 1 for _ in range(n)]
    initial = pack(bits)
    s = [2 * b - 1 for b in bits]
    field = [sum(J[i][j] * s[j] for j in range(n)) for i in range(n)]
    E = energy(J, bits)
    best = E
    best_state = initial
    first_hit = 0 if E == target else None

    # Each variable keeps its own cached word, field and reuse age.
    words = [0] * n
    cached_q = [0] * n
    ages = [0] * n
    valid = [False] * n
    reuse = fresh = 0
    fb = par['field_address_bits']
    fc = 1 << fb

    for sweep in range(1024):
        offset = sweep * fc
        for i in range(n):
            q = qrom[offset + (field[i] & (fc - 1))]
            take = (
                mode == 'IID'
                or not valid[i]
                or bits[i] != int(q >= 0)
                or q != cached_q[i]
                or ages[i] >= 2
            )
            if take:
                word = source.word()
                words[i] = word
                cached_q[i] = q
                ages[i] = 0
                valid[i] = True
                fresh += 1
            else:
                word = words[i]
                ages[i] += 1
                reuse += 1

            bit = (
                int(word < thresholds[q & 255])
                if q >= 0
                else int(word > thresholds[q & 255])
            )

            # A changed spin updates the energy and all neighboring fields.
            if bit != bits[i]:
                old = s[i]
                E += 2 * old * field[i]
                bits[i] = bit
                s[i] = -old
                for j in range(n):
                    field[j] -= 2 * old * J[j][i]

            state = pack(bits) if E < best else None
            if E < best:
                best = E
                best_state = state
            if E == target and first_hit is None:
                first_hit = sweep * n + i + 1

    assert E == energy(J, bits) and best == energy(
        J, [(best_state >> i) & 1 for i in range(n)]
    )
    assert best >= target and fresh + reuse == 1024 * n and source.calls == n + fresh
    return dict(
        initial_state=initial,
        final_state=pack(bits),
        best_state=best_state,
        final_objective=E,
        best_objective=best,
        success=best == target,
        first_hit=first_hit,
        updates=1024 * n,
        fresh=fresh,
        reuse=reuse,
        refills=0,
        rng_words=source.calls,
        rng_steps=32 * source.calls,
        rng_state=source.state,
    )


def native_trial(p, seed, mode, target):
    n = p['n_pbits']
    model = Reference(
        p['cnf_clauses'], seed, 'baseline' if mode == 'IID' else 'epix', n=n
    )
    initial = pack(model.bits)
    best = len(model.false)
    best_state = initial
    for event in model.run(1024 * n):
        if len(model.false) < best:
            best = len(model.false)
            best_state = pack(model.bits)
    model.verify_assignment()
    bits = model.bits
    if p['family'] == 'xorsat':
        actual = sum(
            sum(bits[v] for v in c['variables']) % 2 != c['parity']
            for c in p['native_clauses']
        )
        assert actual == len(model.false)
    fresh = model.flips - model.reuse
    assert model.source.calls == n + model.raw and model.raw == fresh + model.refills
    return dict(
        initial_state=initial,
        final_state=pack(bits),
        best_state=best_state,
        final_objective=len(model.false),
        best_objective=best,
        success=not model.false,
        first_hit=model.flips if not model.false else None,
        updates=model.flips,
        fresh=fresh,
        reuse=model.reuse,
        refills=model.refills,
        rng_words=model.source.calls,
        rng_steps=32 * model.source.calls,
        rng_state=model.source.state,
    )


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--instance')
    ap.add_argument('--trials', type=int, default=1)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    if args.trials < 1:
        ap.error('--trials must be positive')

    manifest = read(ROOT / 'cases/manifest.json')
    rows = [
        r
        for r in manifest['instances']
        if not args.instance or r['id'] == args.instance
    ]
    if not rows:
        ap.error('Unknown instance')
    args.output.mkdir(parents=True, exist_ok=False)
    summaries = []
    started = time.monotonic()

    with (args.output / 'trials.jsonl').open('w') as stream:
        for idx, r in enumerate(rows):
            folder = ROOT / 'cases' / r['path']
            p = read(folder / 'problem.json')
            par = read(folder / 'fpga/parameters.json')
            target = read(folder / 'certificate.json')['target']

            # Only the scalar target is supplied to the sampler; no witness assignment.
            assert sha(folder / 'problem.json') == r['sha256']['problem.json']
            graph = p['family'] in ('maxcut', 'chimera')
            records = defaultdict(list)
            if graph:
                for name in [
                    'parameters.json',
                    'quantization_rom.hex',
                    'threshold_rom.hex',
                ]:
                    assert sha(folder / 'fpga' / name) == r['sha256']['fpga/' + name]
                q = [
                    int(v, 16)
                    for v in (folder / 'fpga/quantization_rom.hex')
                    .read_text()
                    .splitlines()
                ]
                q = [v if v < 128 else v - 256 for v in q]
                thresholds = [
                    int(v, 16)
                    for v in (folder / 'fpga/threshold_rom.hex')
                    .read_text()
                    .splitlines()
                ]

            # Derive one seed per trial and share it across the two modes.
            for trial in range(args.trials):
                seed = (
                    int.from_bytes(
                        hashlib.sha256(f'EPIX100/{r["id"]}/{trial}'.encode()).digest()[
                            :4
                        ],
                        'little',
                    )
                    or 0xA5C36EFE
                )
                initial = None
                for mode in ['IID', 'EPIX']:
                    result = (
                        graph_trial(p, par, q, thresholds, seed, mode, target)
                        if graph
                        else native_trial(p, seed, mode, target)
                    )
                    if initial is None:
                        initial = result['initial_state']
                    assert result['initial_state'] == initial
                    result.update(
                        id=r['id'],
                        family=r['family'],
                        n_variables=r['n_variables'],
                        trial=trial,
                        seed=seed,
                        mode=mode,
                    )
                    records[mode].append(result)
                    stream.write(json.dumps(result, sort_keys=True) + '\n')

            summary = dict(
                id=r['id'],
                family=r['family'],
                n_variables=r['n_variables'],
                trials_per_mode=args.trials,
            )
            for mode, data in records.items():
                summary[mode] = dict(
                    successes=sum(x['success'] for x in data),
                    mean_rng_words=statistics.mean(x['rng_words'] for x in data),
                    mean_updates=statistics.mean(x['updates'] for x in data),
                )
            summaries.append(summary)
            print(
                f'{idx+1}/{len(rows)} {r["id"]}: IID {summary["IID"]["successes"]}, EPIX {summary["EPIX"]["successes"]} / {args.trials}',
                flush=True,
            )
    report = dict(
        status='PASS',
        meaning='Software trials completed and returned assignments/counter identities passed checks; PASS does not mean every trial solved.',
        physical_fpga_runs=False,
        case_count=len(rows),
        trials_per_mode=args.trials,
        method_trials=2 * args.trials * len(rows),
        manifest_sha256=sha(ROOT / 'cases/manifest.json'),
        trial_file_sha256=sha(args.output / 'trials.jsonl'),
        elapsed_seconds=time.monotonic() - started,
        source_sha256={
            p.name: sha(p)
            for p in [Path(__file__), ROOT / 'testbench/software/native_reference.py']
        },
        instances=summaries,
    )
    (args.output / 'summary.json').write_text(json.dumps(report, indent=2) + '\n')


if __name__ == '__main__':
    main()
