#!/usr/bin/env python3
"""Collect verified energy results; missing cases remain pending."""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'flow'))
import report_energy


def read(path):
    return json.loads(path.read_text())


def summarize_case(case_id, state, directory, profile):
    result = dict(case_id=case_id, profile=profile, status='pending', reason=state.get('error'))
    stage = state.get('energy')
    if not stage:
        return result
    path = directory / stage['directory'] / 'energy_record.json'
    raw = path.read_bytes()
    if hashlib.sha256(raw).hexdigest() != stage['record_sha256']:
        raise ValueError('Energy record changed: ' + case_id)
    record = json.loads(raw)
    if record['case_id'] != case_id:
        raise ValueError('Energy record belongs to another case')
    measured = report_energy.summarize(record, path.parent, pilot=profile == 'pilot')
    result.update(status='pilot_complete' if profile == 'pilot' else 'complete',
                  record=str(path), record_sha256=stage['record_sha256'], reason=None,
                  **{key: measured[key] for key in ('technology', 'period_ns', 'configurations',
                      'search_energy_saving_percent', 'setup_inclusive_energy_saving_percent',
                      'setup_inclusive_power_saving_percent', 'setup_inclusive_latency_saving_percent',
                      'area_saving_percent')})
    return result


def collect(work):
    suite = read(work / 'SUITE.json')
    rows = []
    for case_id in suite['case_ids']:
        directory = work / case_id
        state_path = directory / 'state.json'
        state = read(state_path) if state_path.is_file() else {}
        try:
            row = summarize_case(case_id, state, directory, suite['profile'])
        except (KeyError, ValueError, OSError) as error:
            row = dict(case_id=case_id, profile=suite['profile'], status='invalid', reason=str(error))
        rows.append(row)
    return dict(profile=suite['profile'], functional_trials=suite['functional_trials'],
                activity_trials=suite['activity_trials'], cases=rows,
                completed_cases=sum(row['status'] in ('complete', 'pilot_complete') for row in rows),
                note='Whole-solver mapped-cell estimates before layout. Compare completed results '
                     'using one profile and the setup-inclusive window for each IID/EPIX pair. '
                     'Pilot results use three paired trials; full results use 32 activity trials.')


def write_reports(work):
    data = collect(work)
    (work / 'ENERGY.json').write_text(json.dumps(data, indent=2, allow_nan=False) + '\n')
    columns = ['case_id', 'profile', 'status', 'mode', 'trials', 'successes', 'mean_search_cycles',
               'period_ns', 'area_um2', 'search_power_mw', 'with_setup_power_mw',
               'search_latency_us', 'with_setup_latency_us', 'search_energy_nj', 'with_setup_energy_nj',
               'search_saving_percent', 'with_setup_saving_percent', 'power_saving_percent',
               'latency_saving_percent', 'area_saving_percent', 'reason']
    with (work / 'ENERGY.csv').open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=columns)
        writer.writeheader()
        for case in data['cases']:
            for mode in ('baseline', 'epix'):
                row = {key: case.get(key) for key in ('case_id', 'profile', 'status', 'reason')}
                row['mode'] = 'IID' if mode == 'baseline' else 'EPIX'
                if 'configurations' in case:
                    metrics = case['configurations'][mode]
                    row.update({key: metrics[key] for key in ('trials', 'successes', 'mean_search_cycles', 'area_um2')})
                    row.update(period_ns=case['period_ns'],
                               search_power_mw=metrics['mean_power_mw']['search']['total'],
                               with_setup_power_mw=metrics['mean_power_mw']['with_setup']['total'],
                               search_latency_us=metrics['mean_latency_us']['search'],
                               with_setup_latency_us=metrics['mean_latency_us']['with_setup'],
                               search_energy_nj=metrics['mean_energy_nj']['search']['total'],
                               with_setup_energy_nj=metrics['mean_energy_nj']['with_setup']['total'],
                               search_saving_percent=case['search_energy_saving_percent'],
                               with_setup_saving_percent=case['setup_inclusive_energy_saving_percent'],
                               power_saving_percent=case['setup_inclusive_power_saving_percent'],
                               latency_saving_percent=case['setup_inclusive_latency_saving_percent'],
                               area_saving_percent=case['area_saving_percent'])
                writer.writerow(row)
    lines = ['# ASIC energy results', '',
             f"Profile: **{data['profile']}**; {data['functional_trials']} functional and {data['activity_trials']} activity trials per mode.",
             '', data['note'], '',
             '| Case | Status | IID successes | EPIX successes | IID energy (nJ) | EPIX energy (nJ) | Saving (%) |',
             '|---|---|---:|---:|---:|---:|---:|']
    for case in data['cases']:
        values = [case['case_id'], case['status']]
        if 'configurations' in case:
            modes = [case['configurations'][mode] for mode in ('baseline', 'epix')]
            values += [f"{mode['successes']}/{mode['trials']}" for mode in modes]
            values += [f"{mode['mean_energy_nj']['with_setup']['total']:.6g}" for mode in modes]
            saving = case['setup_inclusive_energy_saving_percent']
            values += ['Unresolved' if saving is None else f'{saving:.3f}']
        else:
            values += ['—'] * 5
        lines.append('| ' + ' | '.join(values) + ' |')
    lines += ['', 'Use the setup-inclusive CSV columns for mean power (mW), latency (us), energy (nJ), and area (um2). '
              'Savings use 100 × (1 − EPIX / IID) within the same case and technology. '
              'The search-only columns provide the corresponding search measurements.', '']
    (work / 'ENERGY.md').write_text('\n'.join(lines))
    return data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--work', type=Path, required=True)
    args = parser.parse_args()
    data = write_reports(args.work.resolve())
    print(f"{data['completed_cases']}/{len(data['cases'])} cases have verified {data['profile']} results")


if __name__ == '__main__':
    main()
