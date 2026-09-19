#!/usr/bin/env python3
"""Compare software with historical board records and an independent C port."""
import argparse
import json
from pathlib import Path
import platform
import random
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'testbench/software'))
sys.path.insert(0, str(ROOT / 'testbench/tools/native_check'))
import run as model
import api


def graph_data(folder):
    p = model.read(folder / 'problem.json')
    par = model.read(folder / 'fpga/parameters.json')
    q = [
        int(v, 16)
        for v in (folder / 'fpga/quantization_rom.hex').read_text().splitlines()
    ]
    q = [v if v < 128 else v - 256 for v in q]
    t = [
        int(v, 16) for v in (folder / 'fpga/threshold_rom.hex').read_text().splitlines()
    ]
    return p, par, q, t, model.read(folder / 'certificate.json')['target']


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        '--smoke', type=Path, default=ROOT / 'testbench/validation/software_smoke'
    )
    args = ap.parse_args()
    source = model.Source(29391)
    x = source.state
    for _ in range(1000):
        x = model.advance_slow(x)
        assert source.word() == x

    # Replay recorded seeds to compare assignments and source counters.
    historical = model.read(ROOT / 'testbench/validation/known_board_records.json')[
        'records'
    ]
    mappings = {
        'initial_state': 'initial_bits',
        'final_state': 'final_bits',
        'final_objective': 'final_energy',
        'updates': 'updates',
        'rng_words': 'rng_words',
        'rng_steps': 'rng_steps',
        'rng_state': 'rng_state',
        'reuse': 'reuse',
        'fresh': 'fresh',
        'first_hit': 'first_hit',
    }
    for entry in historical:
        f = entry['family']
        record = entry['record']
        folder = ROOT / 'cases' / f / 'n26/instance01'
        mode = 'EPIX' if record['mode'] else 'IID'
        if f in ('maxcut', 'chimera'):
            p, par, q, t, target = graph_data(folder)
            r = model.graph_trial(p, par, q, t, record['seed'], mode, target)
            assert (
                r['best_state'] == record['best_bits']
                and r['best_objective'] == record['best_energy']
            )
        else:
            r = model.native_trial(
                model.read(folder / 'problem.json'), record['seed'], mode, 0
            )
            assert r['refills'] == record['refills']
        for new, old in mappings.items():
            assert r[new] == record[old], (
                f,
                record['trial'],
                mode,
                new,
                r[new],
                record[old],
            )
    manifest = model.read(ROOT / 'cases/manifest.json')
    lookup = {r['id']: r for r in manifest['instances']}
    rows = [
        json.loads(s) for s in (args.smoke / 'trials.jsonl').read_text().splitlines()
    ]
    checks = 0

    # Compile the independent native solver outside the package.
    with tempfile.TemporaryDirectory(prefix='epix_native_check_') as tmp:
        library = Path(tmp) / (
            'native.dylib' if platform.system() == 'Darwin' else 'native.so'
        )
        command = [
            shutil.which('clang') or shutil.which('cc'),
            '-O2',
            '-std=c11',
            '-Wall',
            '-Wextra',
            '-fno-fast-math',
            '-shared',
            '-fPIC',
            str(ROOT / 'testbench/tools/native_check/solver.c'),
            '-o',
            str(library),
            '-lm',
        ]
        subprocess.run(command, check=True, capture_output=True, text=True)
        lib = api.load_library(library)
        for row in rows:
            if row['family'] not in ('sat', 'xorsat'):
                continue
            p = model.read(ROOT / 'cases' / lookup[row['id']]['path'] / 'problem.json')
            n = p['n_pbits']
            r, _ = api.run(
                lib,
                n,
                api.clause_array(p['cnf_clauses']),
                row['seed'],
                int(row['mode'] == 'EPIX'),
                1024 * n,
            )
            for field, expected in [
                ('initial_state', r.initial_state),
                ('final_state', r.final_state),
                ('best_state', r.best_state),
                ('best_objective', r.best_unsat),
                ('final_objective', r.final_unsat),
                ('updates', r.flips),
                ('reuse', r.reuse_visits),
                ('fresh', r.refresh_events),
                ('refills', r.refill_calls),
                ('rng_words', r.init_calls + r.search_calls),
                ('rng_state', r.rng_s0),
            ]:
                assert row[field] == expected, (
                    row['id'],
                    row['mode'],
                    field,
                    row[field],
                    expected,
                )
            assert row['success'] == bool(r.solved)
            checks += 1
    report = dict(
        status='PASS',
        lfsr_32_step_word_comparisons=1000,
        historical_board_trial_replays=len(historical),
        independent_native_c_trial_comparisons=checks,
        new_physical_board_runs=0,
        source_sha256={
            str(p.relative_to(ROOT)): model.sha(p)
            for p in [
                Path(__file__),
                ROOT / 'testbench/software/run.py',
                ROOT / 'testbench/software/native_reference.py',
                ROOT / 'testbench/tools/native_check/solver.c',
                ROOT / 'testbench/tools/native_check/solver_api.h',
                ROOT / 'testbench/tools/native_check/api.py',
            ]
        },
        smoke_trials_sha256=model.sha(args.smoke / 'trials.jsonl'),
    )
    (ROOT / 'testbench/validation/model_validation.json').write_text(
        json.dumps(report, indent=2) + '\n'
    )
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
