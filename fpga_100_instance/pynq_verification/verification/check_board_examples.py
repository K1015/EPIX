#!/usr/bin/env python3
"""Check packaged images and recorded board results without accessing hardware."""
import argparse
from collections import Counter
import hashlib
import json
import math
from pathlib import Path
import subprocess
import sys
from source_identity import check_recorded_file

ROOT = Path(__file__).resolve().parents[1]


def read(path):
    return json.loads(path.read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check():
    reports = {}
    for family in ('maxcut', 'chimera', 'sat', 'xorsat'):
        folder = ROOT / 'examples' / family
        subprocess.run([sys.executable, str(folder / 'run.py'), '--check'], check=True)
        provenance = read(ROOT / 'results/original' / family / 'PROVENANCE.json')
        for name, digest in provenance['files_sha256'].items():
            check_recorded_file(folder / name, digest)
        complete = read(ROOT / 'results/original' / family / 'COMPLETE.json')
        assert complete['status'] == 'PASS'
        assert (
            sha(ROOT / 'results/original' / family / 'trials.jsonl')
            == complete['trials_sha256']
        )
        rows = [
            json.loads(line)
            for line in (ROOT / 'results/original' / family / 'trials.jsonl')
            .read_text()
            .splitlines()
        ]
        assert len(rows) == complete['trials'] == 2000
        assert Counter((row['trial'], row['mode']) for row in rows) == Counter(
            {(trial, mode): 1 for trial in range(1000) for mode in (0, 1)}
        )
        problem = read(folder / 'problem.json')
        case = ROOT / 'verification/inputs' / family
        canonical = read(case / 'problem.json')
        target = read(case / 'certificate.json')['target']
        if family == 'maxcut':
            matrix = [[0] * 26 for _ in range(26)]
            for i, j, weight in problem['edges']:
                matrix[i][j] = matrix[j][i] = -weight
            assert matrix == canonical['J']
        elif family == 'chimera':
            assert problem['J'] == canonical['J']
        else:
            assert problem['clauses'] == canonical['cnf_clauses']
        success_metric = (
            'best_energy' if family in ('maxcut', 'chimera') else 'final_energy'
        )
        states = [('final_bits', 'final_energy')]
        if family in ('maxcut', 'chimera'):
            states.append(('best_bits', 'best_energy'))
        for row in rows:
            assert row['seed'] == problem['trial_seeds'][row['trial']]
            assert row['rng_steps'] == 32 * row['rng_words']
            assert math.isclose(row['core_seconds'], row['cycles'] / 1e8, rel_tol=1e-12)
            for state, metric in states:
                bits = [(row[state] >> i) & 1 for i in range(26)]
                if family in ('maxcut', 'chimera'):
                    score = -sum(
                        canonical['J'][i][j] * (2 * bits[i] - 1) * (2 * bits[j] - 1)
                        for i in range(26)
                        for j in range(i + 1, 26)
                    )
                else:
                    score = sum(
                        not any(bits[abs(v) - 1] == (v > 0) for v in clause)
                        for clause in canonical['cnf_clauses']
                    )
                assert score == row[metric], (family, row['trial'], metric)
            if 'success' in row:
                assert row['success'] == (row[success_metric] == target)
        summary = read(ROOT / 'results/original' / family / 'SUMMARY.json')
        for mode, name in [(0, 'IID'), (1, 'EPIX')]:
            group = [row for row in rows if row['mode'] == mode]
            assert summary[name]['trials'] == len(group)
            assert summary[name]['successes'] == sum(
                row[success_metric] == target for row in group
            )
            for key, value in summary[name].items():
                if key.startswith('mean_'):
                    assert math.isclose(
                        value,
                        sum(row[key[5:]] for row in group) / len(group),
                        abs_tol=1e-12,
                    )
                elif key.startswith('total_'):
                    assert math.isclose(
                        value, sum(row[key[6:]] for row in group), abs_tol=1e-12
                    )
        source = folder / 'vivado/ip_repo/maxcut26/src'
        for rom in (case / 'fpga').glob('*.hex'):
            assert sha(source / rom.name) == sha(rom), (family, rom.name)
        required = [
            'build.py',
            'maxcut26.xpr',
            'tcl/build.tcl',
            'tcl/pynq_z1_ps7.tcl',
            'scripts/metadata_adapter.py',
            'scripts/validate_hwh_reset.py',
            'maxcut26.srcs/sources_1/bd/design_1/design_1.bd',
            'ip_repo/maxcut26/component.xml',
        ]
        assert all((folder / 'vivado' / name).is_file() for name in required)
        notebook = read(folder / 'Demo.ipynb')
        assert any(
            '"--mode", "paired"' in ''.join(cell['source'])
            for cell in notebook['cells']
        )
        reports[family] = {
            'recorded_trials': len(rows),
            'image_and_input_match_original_hashes': True,
            'runner_matches_recorded_source_or_audited_format': True,
            'input_and_roms_match_collection': True,
            'successes': {name: summary[name]['successes'] for name in ('IID', 'EPIX')},
        }
    return {
        'status': 'PASS',
        'scope': 'Deployment hashes, audited runner formatting, input/ROM identity and recorded board scores/counters/summaries',
        'new_board_runs': 0,
        'new_vivado_builds': 0,
        'families': reports,
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    report = check()
    text = json.dumps(report, indent=2) + '\n'
    if args.output:
        args.output.write_text(text)
    print(text)
