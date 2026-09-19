#!/usr/bin/env python3
"""Compare a notebook hardware recheck with the recorded matching-seed trials."""
import argparse
import hashlib
import json
from pathlib import Path
from source_identity import check_recorded_file

ROOT = Path(__file__).resolve().parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text())


def check(output):
    receipt = read(output / 'NOTEBOOK_VALIDATION.json')
    assert receipt['status'] == 'PASS' and receipt['physical_trials'] == 8
    assert receipt['trials_per_mode_per_family'] == 1
    reports = {}
    for family in ('maxcut', 'chimera', 'sat', 'xorsat'):
        source = ROOT / 'examples' / family
        result = output / family
        entry = receipt['notebooks'][family]
        # Published copies may shorten only the displayed output path.
        source_digest = entry.get(
            'published_source_notebook_sha256', entry['source_notebook_sha256']
        )
        executed_digest = entry.get(
            'published_notebook_sha256', entry['executed_notebook_sha256']
        )
        assert sha(source / 'Demo.ipynb') == source_digest
        assert sha(output / (family + '.ipynb')) == executed_digest
        assert sha(result / 'trials.jsonl') == entry['trials_sha256']
        notebook = read(output / (family + '.ipynb'))
        cells = [c for c in notebook['cells'] if c['cell_type'] == 'code']
        assert all(c['execution_count'] is not None for c in cells)
        assert not any(o['output_type'] == 'error' for c in cells for o in c['outputs'])
        assert read(result / 'COMPLETE.json')['status'] == 'PASS'
        assert read(result / 'COMPLETE.json')['trials'] == 2
        provenance = read(result / 'PROVENANCE.json')
        assert provenance['mode'] == 'paired' and provenance['trials_per_mode'] == 1
        for name, digest in provenance['files_sha256'].items():
            check_recorded_file(source / name, digest)
        historical = [
            json.loads(s)
            for s in (ROOT / 'results/original' / family / 'trials.jsonl')
            .read_text()
            .splitlines()
        ]
        lookup = {(row['trial'], row['mode'], row['seed']): row for row in historical}
        rows = [
            json.loads(s) for s in (result / 'trials.jsonl').read_text().splitlines()
        ]
        assert len(rows) == 2 and {row['mode'] for row in rows} == {0, 1}
        fields = set()
        for row in rows:
            old = lookup[(row['trial'], row['mode'], row['seed'])]

            # Host polling time can vary. Every other logged value must match.
            new_values = {k: v for k, v in row.items() if k != 'host_seconds'}
            old_values = {k: v for k, v in old.items() if k != 'host_seconds'}
            assert new_values == old_values, (family, row['mode'])
            fields.update(new_values)
        assert read(result / 'SUMMARY.json') == entry['summary']
        reports[family] = {
            'trials': 2,
            'fields_matched': sorted(fields),
            'status': 'PASS',
        }
    report = {
        'status': 'PASS',
        'physical_trials_compared': 8,
        'comparison': 'Every logged trial field matches the historical same-seed board trial, excluding host polling seconds.',
        'families': reports,
    }
    (output / 'REFERENCE_COMPARISON.json').write_text(
        json.dumps(report, indent=2) + '\n'
    )
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    print(json.dumps(check(args.output), indent=2))
