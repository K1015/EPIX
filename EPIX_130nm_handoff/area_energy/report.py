#!/usr/bin/env python3
"""Collect area, power and energy results in JSON and CSV."""
import argparse
import csv
from functools import lru_cache
import hashlib
import json
import math
from pathlib import Path
import re
import statistics

MACRO = 'sram22_128x40m4w20'
WINDOWS = {'setup': 'setup_only', 'search': 'search', 'total': 'with_setup'}


def read(path):
    if not path.is_file():
        return {}
    try:
        value = json.loads(path.read_text())
        return (
            value if isinstance(value, dict) else {'_error': 'Expected a JSON object'}
        )
    except (ValueError, OSError) as error:
        return {'_error': str(error)}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def finite(value):
    value = float(value)
    if not math.isfinite(value) or value < 0:
        raise ValueError('Expected a finite nonnegative measurement')
    return value


@lru_cache(maxsize=None)
def cell_areas(path):
    """Read each cell area from a Liberty file."""
    text = Path(path).read_text()
    cells = list(re.finditer(r'\bcell\s*\(\s*"?([^\s"()]+)"?\s*\)\s*\{', text))
    areas = {}
    for index, cell in enumerate(cells):
        body = text[
            cell.end() : (
                cells[index + 1].start() if index + 1 < len(cells) else len(text)
            )
        ]
        area = re.search(r'\barea\s*:\s*([\d.eE+-]+)\s*;', body)
        if area:
            areas[cell.group(1)] = finite(area.group(1))
    if not areas:
        raise ValueError('No cell areas in ' + str(path))
    return areas


def area_result(base, engine):
    """Check cell counts and report logic, SRAM and total area."""
    path = base / 'closed/status.json'
    stage = 'closed'
    if not path.exists() and (base / 'mapped/status.json').exists():
        path, stage = base / 'mapped/status.json', 'mapped'
    data = read(path)
    result = {'status': 'missing', 'stage': stage, 'source': str(path)}
    if not data:
        return result
    result.update(
        status='failed',
        mapped_sha256=data.get('mapped_sha256'),
        reported_area_um2=data.get('area_um2'),
        problem_sha256=data.get('selection_validation', {}).get('graph_sha256'),
    )
    try:
        if data.get('_error'):
            raise ValueError(data['_error'])
        std_path, sram_path = engine / 'tech/std.lib', engine / 'tech/sram.lib'
        std, sram = cell_areas(str(std_path)), cell_areas(str(sram_path))
        counts = data['counts']
        if not counts or any(not isinstance(v, int) or v < 0 for v in counts.values()):
            raise ValueError('Invalid or missing cell counts')
        unknown = set(counts) - set(std) - set(sram)
        if unknown:
            raise ValueError(
                'Cells missing from staged libraries: ' + ', '.join(sorted(unknown))
            )
        memory = sum(sram[k] * v for k, v in counts.items() if k in sram)
        logic = sum(std[k] * v for k, v in counts.items() if k not in sram)
        total = finite(data['area_um2'])
        if not math.isclose(total, memory + logic, rel_tol=1e-8, abs_tol=0.001):
            raise ValueError('Cell area sum differs from reported area')
        result.update(
            area_um2=total,
            standard_cell_area_um2=logic,
            sram_area_um2=memory,
            sram_macros=counts.get(MACRO, 0),
            library_sha256={'std': sha(std_path), 'sram': sha(sram_path)},
        )
        if data.get('passed') is True:
            if stage == 'closed' and all(
                data.get(k) is True
                for k in ('setup_pass', 'hold_pass', 'electrical_pass')
            ):
                result['status'] = 'complete'
            else:
                result['status'] = 'provisional'
        else:
            result['reason'] = data.get('error', 'Area stage did not pass')
    except (KeyError, TypeError, ValueError, OSError) as error:
        result.update(status='invalid', reason=str(error))
    return result


def trial_result(path, public_mode, expected_mode, graph, cfg, area):
    """Check one trial and separate dynamic and leakage energy."""
    data = read(path)
    row = {
        'mode': public_mode,
        'source': str(path),
        'status': 'invalid',
        'native_complete': False,
        'success': None,
    }
    try:
        if data.get('_error'):
            raise ValueError(data['_error'])
        if graph:
            match = re.fullmatch(r'profile_s(\d+)_t(\d+)', path.parent.name)
            if not match:
                raise ValueError('Unrecognized graph trial directory')
            budget, trial = map(int, match.groups())
            row.update(trial=trial, seed=None, budget=budget, pair_id=trial)
            status = read(path.parent.parent / (path.parent.name + '_status.json'))
            if status and status.get('passed') is not True:
                raise ValueError(
                    status.get(
                        'error', status.get('_error', 'Trial status did not pass')
                    )
                )
            if (
                int(data.get('trial', trial)) != trial
                or int(data.get('requested_sweeps', budget)) != budget
            ):
                raise ValueError('Graph trial identity differs from its directory')
            complete = bool(int(data['source_trial']['complete']))
            if data.get('native_complete') is not complete:
                raise ValueError('Graph completion fields disagree')
            success = bool(int(data['source_trial']['success']))
            coverage = data.get('activity_coverage', {})
        else:
            match = re.fullmatch(
                r'(fresh|epix)_(\d+)_(\d+)_stall(\d+)', path.parent.name
            )
            if not match:
                raise ValueError('Unrecognized hypergraph trial directory')
            observed_mode, seed, budget, stall = match.groups()
            seed, budget, stall = int(seed), int(budget), int(stall)
            row.update(
                trial=data.get('trial'),
                seed=seed,
                budget=budget,
                stall=stall,
                pair_id=seed,
                coefficient_sha256=data.get('coefficient_sha256'),
            )
            if data.get('mode') != observed_mode or int(data['seed']) != seed:
                raise ValueError('Hypergraph trial identity differs from its directory')
            # A passing mapped run must finish and match the reference.
            log = path.parent / 'simulation.log'
            log_text = log.read_text() if log.is_file() else ''
            complete = data.get(
                'native_complete',
                data.get('passed') is True
                and bool(data.get('vector_sha256'))
                and bool(data.get('header_sha256')),
            )
            if log_text.strip() and 'ALL_PASS 1' not in log_text:
                complete = False
            row['completion_evidence'] = (
                'mapped_simulation_log'
                if 'ALL_PASS 1' in log_text
                else 'passed_mapped_reference_receipt'
            )
            success = int(data['source_trial']['best_energy']) == 0
            coverage = data.get('saif_coverage', {})
            if observed_mode != expected_mode or stall:
                row['mode'] = public_mode + '_' + observed_mode + '_diagnostic'
        if data.get('mode') != (
            expected_mode if row['mode'] == public_mode else observed_mode
        ):
            raise ValueError('Unexpected receipt mode')
        row.update(
            run_complete=complete,
            success=success,
            mapped_sha256=data.get('mapped_sha256'),
            reported_case=data.get('case'),
        )
        for label, key in WINDOWS.items():
            window = data['windows'][key]
            energy, duration = finite(window['energy_j']), finite(window['duration_s'])
            power = finite(window['power_w'])
            if duration <= 0 or not math.isclose(
                power, energy / duration, rel_tol=1e-8, abs_tol=1e-15
            ):
                raise ValueError('Energy, duration and power disagree for ' + key)
            components = window['components_j']
            required = {
                'standard_cell_internal_j',
                'all_output_switching_j',
                'all_leakage_j',
                'root_clock_input_charging_j',
            }
            if not isinstance(components, dict) or not required <= set(components):
                raise ValueError('Missing energy components for ' + key)
            components = {name: finite(value) for name, value in components.items()}
            sram_internal = finite(window['sram_internal_j']['full_published_model'])
            leakage = components['all_leakage_j']
            dynamic = math.fsum(
                [sram_internal]
                + [
                    value
                    for name, value in components.items()
                    if name != 'all_leakage_j'
                ]
            )
            if not math.isclose(dynamic + leakage, energy, rel_tol=1e-8, abs_tol=1e-20):
                raise ValueError(
                    'Energy component sum differs from reported energy for ' + key
                )
            row[label + '_energy_nj'] = energy * 1e9
            row[label + '_duration_us'] = duration * 1e6
            row[label + '_power_mw'] = power * 1e3
            row[label + '_dynamic_energy_nj'] = dynamic * 1e9
            row[label + '_leakage_energy_nj'] = leakage * 1e9
            row[label + '_dynamic_power_mw'] = dynamic / duration * 1e3
            row[label + '_leakage_power_mw'] = leakage / duration * 1e3
        row['status'] = 'failed' if data.get('passed') is not True else 'incomplete'
        if data.get('passed') is not True:
            row['reason'] = data.get('error', 'Energy integration did not pass')
        elif (
            coverage.get('complete_coverage') is not True
            or data.get('readback', {}).get('passed') is not True
        ):
            row['reason'] = 'Activity coverage or post-report readback did not pass'
        elif area.get('status') != 'complete' or data.get('mapped_sha256') != area.get(
            'mapped_sha256'
        ):
            row['reason'] = (
                'Closed area/netlist receipt is missing or does not match this trial'
            )
        elif budget != int(cfg['native_sweeps']):
            row.update(
                status='pilot', reason='Budget differs from the selected native budget'
            )
        elif not complete:
            row['reason'] = 'Mapped simulation completion is unavailable'
        elif row['mode'] != public_mode:
            row.update(
                status='diagnostic', reason='Additional runtime mode or pause pattern'
            )
        else:
            row.update(status='complete', native_complete=True)
    except (KeyError, TypeError, ValueError, OSError) as error:
        row.update(
            status='failed' if data.get('passed') is False else 'invalid',
            reason=str(error),
        )
    return row


def comparison(trials, areas, graph, expected_ids=None):
    """Compare matching completed baseline and EPIX trials."""
    groups = {
        mode: [x for x in trials if x['mode'] == mode and x.get('native_complete')]
        for mode in ('baseline', 'epix')
    }
    result = {
        'status': 'missing',
        'paired_trials': 0,
        'baseline_native_trials': len(groups['baseline']),
        'epix_native_trials': len(groups['epix']),
    }
    if all(x.get('status') == 'complete' for x in areas.values()):
        base, epix = areas['baseline']['area_um2'], areas['epix']['area_um2']
        result.update(
            baseline_area_um2=base,
            epix_area_um2=epix,
            area_change_percent=100 * (epix / base - 1) if base else None,
        )
    if expected_ids is not None:
        result['requested_ids'] = list(expected_ids)
        for mode, rows in groups.items():
            result[mode + '_missing_ids'] = sorted(
                set(expected_ids) - {x['pair_id'] for x in rows}
            )
    if not all(groups.values()):
        result['reason'] = 'Complete native energy is required for both modes'
        return result
    ids = {m: [x['pair_id'] for x in rows] for m, rows in groups.items()}
    if any(len(v) != len(set(v)) for v in ids.values()) or set(ids['baseline']) != set(
        ids['epix']
    ):
        result.update(
            status='unpaired',
            reason='Native trial/seed sets differ or contain duplicates',
        )
        return result
    if areas['baseline'].get('library_sha256') != areas['epix'].get('library_sha256'):
        result.update(status='unpaired', reason='Baseline and EPIX libraries differ')
        return result
    if graph and (
        not areas['baseline'].get('problem_sha256')
        or areas['baseline']['problem_sha256'] != areas['epix'].get('problem_sha256')
    ):
        result.update(
            status='unpaired', reason='Graph input identities are unavailable or differ'
        )
        return result
    by_id = {m: {x['pair_id']: x for x in rows} for m, rows in groups.items()}
    for identity in ids['baseline']:
        a, b = by_id['baseline'][identity], by_id['epix'][identity]
        if a['budget'] != b['budget'] or (
            not graph
            and (
                not a.get('coefficient_sha256')
                or a['coefficient_sha256'] != b.get('coefficient_sha256')
            )
        ):
            result.update(
                status='unpaired',
                reason='Paired budgets or coefficient identities differ',
            )
            return result
    if expected_ids is not None and set(ids['baseline']) - set(expected_ids):
        result.update(
            status='unpaired', reason='Observed trial IDs are outside the requested set'
        )
        return result
    partial = expected_ids is not None and set(ids['baseline']) != set(expected_ids)
    result.update(
        status='partial' if partial else 'complete',
        paired_trials=len(ids['baseline']),
        paired_ids=sorted(ids['baseline']),
    )
    if partial:
        result['reason'] = (
            'Comparison covers the available paired native trials; requested trials remain missing'
        )
    for mode, rows in groups.items():
        result[mode + '_successes'] = sum(x['success'] is True for x in rows)
        for label in WINDOWS:
            for quantity in (
                'energy_nj',
                'dynamic_energy_nj',
                'leakage_energy_nj',
                'duration_us',
            ):
                result[mode + '_mean_' + label + '_' + quantity] = statistics.mean(
                    x[label + '_' + quantity] for x in rows
                )
            duration = math.fsum(x[label + '_duration_us'] for x in rows)
            for component in ('', 'dynamic_', 'leakage_'):
                energy = math.fsum(
                    x[label + '_' + component + 'energy_nj'] for x in rows
                )
                result[mode + '_aggregate_' + label + '_' + component + 'power_mw'] = (
                    energy / duration
                )
        for component in ('', 'dynamic_', 'leakage_'):
            result[mode + '_aggregate_' + component + 'power_mw'] = result[
                mode + '_aggregate_total_' + component + 'power_mw'
            ]
    baseline = result['baseline_mean_total_energy_nj']
    result['energy_saving_percent'] = (
        100 * (1 - result['epix_mean_total_energy_nj'] / baseline) if baseline else None
    )
    baseline_dynamic = result['baseline_mean_total_dynamic_energy_nj']
    result['dynamic_energy_saving_percent'] = (
        100 * (1 - result['epix_mean_total_dynamic_energy_nj'] / baseline_dynamic)
        if baseline_dynamic
        else None
    )
    result['success_counts_differ'] = (
        result['baseline_successes'] != result['epix_successes']
    )
    return result


def summarize(work):
    """Collect results for the cases listed in the run manifest."""
    manifest = read(work / 'manifest.json')
    if not manifest.get('cases') or not isinstance(manifest.get('config'), dict):
        raise ValueError('manifest.json must contain cases and a config mapping')
    cases, csv_rows = [], []
    for name in manifest['cases']:
        cfg = manifest['config'][name]
        family, n = cfg['family'], int(cfg['n'])
        graph = family in ('maxcut', 'chimera')
        areas, trials = {}, []
        common = {'case': name, 'family': family, 'n': n}
        for mode in ('baseline', 'epix'):
            internal = 'iid' if mode == 'baseline' else 'epix'
            if graph:
                engine = work / 'graph'
                base = engine / 'results' / name / internal
                paths = sorted(base.glob('power_saif*/profile_s*_t*/result.json'))
            else:
                fam = 'xor' if family == 'xorsat' else 'sat'
                engine = (
                    work
                    / 'hyper'
                    / ('sky130_' + fam + ('_iid' if mode == 'baseline' else ''))
                )
                short = ('xorsat' if family == 'xorsat' else 'sat') + str(n)
                base = engine / 'results' / short / 'shared'
                internal = 'fresh' if mode == 'baseline' else 'epix'
                paths = sorted(base.glob('power/*/result.json'))
            areas[mode] = area_result(base, engine)
            csv_rows.append(
                dict(
                    common,
                    row_type='area',
                    mode=mode,
                    **{k: v for k, v in areas[mode].items() if not isinstance(v, dict)}
                )
            )
            for path in paths:
                row = trial_result(path, mode, internal, graph, cfg, areas[mode])
                trials.append(row)
                csv_rows.append(dict(common, row_type='trial', **row))
            if graph:
                for status_path in sorted(
                    base.glob('power_saif*/profile_s*_t*_status.json')
                ):
                    directory = status_path.parent / status_path.name.removesuffix(
                        '_status.json'
                    )
                    if (directory / 'result.json').exists():
                        continue
                    data = read(status_path)
                    row = dict(
                        mode=mode,
                        source=str(status_path),
                        status=(
                            'failed' if data.get('passed') is False else 'incomplete'
                        ),
                        native_complete=False,
                        reason=data.get('error', 'Trial has no energy result'),
                    )
                    trials.append(row)
                    csv_rows.append(dict(common, row_type='trial', **row))
            if not paths:
                build = read(
                    base / ('power_saif/build.json' if graph else 'power/build.json')
                )
                row = dict(
                    mode=mode,
                    status='failed' if build.get('passed') is False else 'missing',
                    native_complete=False,
                    reason=build.get('error', 'No energy trial receipts found'),
                )
                trials.append(row)
                csv_rows.append(dict(common, row_type='trial', **row))
        paired = comparison(
            trials,
            areas,
            graph,
            manifest.get('graph_trials' if graph else 'hyper_seeds'),
        )
        cases.append(dict(common, area=areas, trials=trials, comparison=paired))
        csv_rows.append(dict(common, row_type='comparison', **paired))
    return {
        'schema_version': 1,
        'work': str(work),
        'manifest_sha256': sha(work / 'manifest.json'),
        'scope': 'SKY130 mapped estimates before layout; missing or partial runs are retained; comparisons require matching complete native trials.',
        'cases': cases,
    }, csv_rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--work', required=True, type=Path)
    parser.add_argument(
        '--output',
        type=Path,
        help='JSON report path; defaults to WORK/report.json, with CSV beside it',
    )
    args = parser.parse_args()
    report, rows = summarize(args.work.resolve())
    output = args.output or args.work.resolve() / 'report.json'
    output = output if output.suffix == '.json' else output.with_suffix('.json')
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, allow_nan=False) + '\n')
    first = ['case', 'family', 'n', 'row_type', 'mode', 'status', 'reason']
    fields = first + sorted(set().union(*(r.keys() for r in rows)) - set(first))
    with output.with_suffix('.csv').open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    k: json.dumps(v) if isinstance(v, (list, dict)) else v
                    for k, v in row.items()
                }
            )
    print('Wrote ' + str(output) + ' and ' + str(output.with_suffix('.csv')))


if __name__ == '__main__':
    main()
