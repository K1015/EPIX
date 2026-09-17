#!/usr/bin/env python3
"""Calculate SRAM energy from VCD and check the saved chip results."""
import argparse
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
PACKAGE = HERE.parents[1]
sys.dont_write_bytecode = True


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


sram = load_module('example_sram', HERE.parent / 'graph/sram_model.py')
report = load_module('example_report', HERE.parent / 'report.py')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_vcd(path):
    """Read signal values at each time. Keep the values before each edge."""
    text = path.read_text()
    timescale = re.search(r'\$timescale\s+(\d+)\s*(s|ms|us|ns|ps|fs)\s+\$end', text)
    if not timescale:
        raise ValueError('VCD has no timescale')
    scale_ps = (
        int(timescale[1])
        * {'s': 1e12, 'ms': 1e9, 'us': 1e6, 'ns': 1e3, 'ps': 1, 'fs': 1e-3}[
            timescale[2]
        ]
    )
    names = {}
    widths = {}
    for width, code, name in re.findall(
        r'\$var\s+\w+\s+(\d+)\s+(\S+)\s+(\S+).*?\$end', text
    ):
        name = name.split('[')[0]
        names[code] = name
        widths[name] = int(width)
    required = {
        'clk',
        'measure',
        'search',
        'sram_clk',
        'sram_ce',
        'sram_we',
        'rng_clock',
        'rng_state',
    }
    if not required <= set(names.values()):
        raise ValueError(
            'Missing waveform signals: ' + str(required - set(names.values()))
        )
    values, records, timestamp = {}, [], None
    for line in text.split('$enddefinitions', 1)[1].splitlines():
        line = line.strip()
        if line.startswith('#'):
            if timestamp is not None:
                records.append((timestamp, values.copy()))
            timestamp = int(line[1:]) * scale_ps
        elif line and line[0] in '01xXzZbB':
            if line[0] in 'bB':
                bits, code = line[1:].split()
            else:
                bits, code = line[0], line[1:]
            if code in names:
                values[names[code]] = (
                    None if any(c in bits.lower() for c in 'xz') else int(bits, 2)
                )
    if timestamp is not None:
        records.append((timestamp, values.copy()))
    if len(records) < 2 or any(b[0] <= a[0] for a, b in zip(records, records[1:])):
        raise ValueError('Waveform times must increase')
    return records, widths


def waveform_energy(path, archived, model, period_ns):
    """Count SRAM events and add their Liberty energy values."""
    records, widths = read_vcd(path)
    windows = {
        w: {
            'duration_ps': 0,
            'root_clock_edges': 0,
            'rng_clock_edges': 0,
            'rng_state_bit_transitions': 0,
            'sram_edge_counts': {key: 0 for key in sram.EDGE_KEYS},
        }
        for w in ('setup_only', 'search')
    }
    for (before_t, before), (after_t, after) in zip(records, records[1:]):
        if before.get('measure') != 1:
            continue
        window = windows['search' if before['search'] else 'setup_only']
        window['duration_ps'] += after_t - before_t
        for signal, counter in [
            ('clk', 'root_clock_edges'),
            ('rng_clock', 'rng_clock_edges'),
        ]:
            if before.get(signal) in (0, 1) and after.get(signal) in (0, 1):
                window[counter] += before[signal] != after[signal]
        if before.get('rng_state') is not None and after.get('rng_state') is not None:
            window['rng_state_bit_transitions'] += bin(
                before['rng_state'] ^ after['rng_state']
            ).count('1')
        if (
            before.get('sram_clk') in (0, 1)
            and after.get('sram_clk') in (0, 1)
            and before['sram_clk'] != after['sram_clk']
        ):
            ce, we = before['sram_ce'], before['sram_we']
            if ce not in (0, 1) or we not in (0, 1):
                raise ValueError('Unknown SRAM control at a clock edge')
            edge = 'rise' if after['sram_clk'] else 'fall'
            window['sram_edge_counts'][f'{edge}_ce{ce}_we{we}'] += 1
    windows['with_setup'] = {
        key: sum(windows[w][key] for w in ('setup_only', 'search'))
        for key in (
            'duration_ps',
            'root_clock_edges',
            'rng_clock_edges',
            'rng_state_bit_transitions',
        )
    }
    windows['with_setup']['sram_edge_counts'] = {
        key: sum(windows[w]['sram_edge_counts'][key] for w in ('setup_only', 'search'))
        for key in sram.EDGE_KEYS
    }
    short = archived['short']
    if len(short['macro_slews']) != 1:
        raise ValueError('Example expects one SRAM macro')
    macro = next(iter(short['macro_slews']))
    slew = short['macro_slews'][macro]
    for name, window in windows.items():
        duration = window['duration_ps'] * 1e-12
        if duration <= 0:
            raise ValueError('Empty measurement window')
        if not math.isclose(
            duration, short['windows'][name]['duration_s'], rel_tol=1e-12
        ):
            raise ValueError(
                f'{path.name}: {name} latency differs from the archived matching trial'
            )
        if window['sram_edge_counts'] != short['macro_counts'][macro][name]:
            raise ValueError(
                f'{path.name}: {name} SRAM edge/control histogram differs: {window["sram_edge_counts"]}'
            )
        if window['root_clock_edges'] != round(
            2 * window['duration_ps'] / (period_ns * 1000)
        ):
            raise ValueError(
                f'{path.name}: {name} root clock transitions disagree with its duration'
            )
        estimate = sram.count_energy(model, window['sram_edge_counts'], **slew)
        energy = estimate['internal_j']['full_published_model']
        if not math.isclose(
            energy,
            short['windows'][name]['sram_internal_j']['full_published_model'],
            rel_tol=1e-12,
        ):
            raise ValueError(
                'Replayed SRAM energy differs from the archived same-workload value'
            )
        window.update(
            duration_us=duration * 1e6,
            cycles=round(duration * 1e9 / period_ns),
            sram_internal_energy_nj=energy * 1e9,
            sram_internal_average_power_uw=energy / duration * 1e6,
            edge_energy_pj={
                key: sum(row['coefficient_j_by_rail'].values()) * 1e12
                for key, row in estimate['conditions'].items()
            },
        )
    final = records[-1][1]
    for key in ('local_words', 'node_visits'):
        if key in final:
            reference_key = 'visits' if key == 'node_visits' else key
            if final[key] != int(short['source_trial'][reference_key]):
                raise ValueError(f'{key} differs from the matching reference trial')
    return {
        'scope': 'New short RTL waveform; SRAM internal energy only, using archived mapped SRAM slews.',
        'waveform_sha256': sha(path),
        'signal_widths': widths,
        'windows': windows,
        'clock_slew_ns': slew,
        'slew_source': short['source_path'],
        'local_words': final.get('local_words'),
        'node_visits': final.get('node_visits'),
        'relative_latencies_and_sram_activity_match_archived_short_trial': True,
    }


def archived_results(mode, std_path, sram_path, period_ns):
    """Recalculate saved chip energy and area from their components."""
    area = mode['area']
    std, memory = report.cell_areas(str(std_path)), report.cell_areas(str(sram_path))
    counts = area['counts']
    if set(counts) - set(std) - set(memory):
        raise ValueError('Unknown mapped cell type')
    logic = sum(std[k] * count for k, count in counts.items() if k not in memory)
    ram = sum(memory[k] * count for k, count in counts.items() if k in memory)
    if not math.isclose(logic + ram, area['reported_area_um2'], rel_tol=1e-12):
        raise ValueError('Area inventory mismatch')
    if (
        sha(std_path) != area['library_sha256']['standard_cells']
        or sha(sram_path) != area['library_sha256']['sram']
    ):
        raise ValueError(
            'Library identities or their roles differ from the archived run'
        )
    if not math.isclose(ram, area['reported_sram_area_um2'], rel_tol=1e-12):
        raise ValueError('SRAM area differs from the archived inventory')
    windows = {}
    for name, original in mode['native']['windows'].items():
        comp = dict(original['components_j'])
        comp['sram_internal_j'] = original['sram_internal_j']['full_published_model']
        leakage = comp['all_leakage_j']
        dynamic = sum(v for k, v in comp.items() if k != 'all_leakage_j')
        total, duration = dynamic + leakage, original['duration_s']
        if not math.isclose(total, original['energy_j'], rel_tol=1e-12):
            raise ValueError('Energy component sum mismatch')
        windows[name] = {
            'duration_us': duration * 1e6,
            'cycles': round(duration * 1e9 / period_ns),
            'dynamic_energy_nj': dynamic * 1e9,
            'leakage_energy_nj': leakage * 1e9,
            'total_energy_nj': total * 1e9,
            'dynamic_power_uw': dynamic / duration * 1e6,
            'leakage_power_uw': leakage / duration * 1e6,
            'total_power_uw': total / duration * 1e6,
            'components_nj': {k.removesuffix('_j'): v * 1e9 for k, v in comp.items()},
        }
    trial = mode['native']['source_trial']
    native_duration = (int(trial['end']) - int(trial['setup_begin'])) * period_ns * 1e-9
    if not math.isclose(
        native_duration * 1e6, windows['with_setup']['duration_us'], rel_tol=1e-12
    ):
        raise ValueError('Native receipt timestamps disagree with duration')
    return {
        'scope': 'Recalculated from archived mapped power components and cell counts; not from the new RTL VCD.',
        'windows': windows,
        'area': {
            'standard_cells_um2': logic,
            'sram_um2': ram,
            'total_um2': logic + ram,
            'sram_macros': area['sram_macros'],
        },
        'native_complete': mode['native']['native_complete'],
        'target_hit': bool(int(trial['success'])),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--waveforms',
        type=Path,
        default=HERE,
        help='Folder containing baseline.vcd and epix.vcd',
    )
    parser.add_argument('--output', type=Path, default=HERE / 'results.json')
    args = parser.parse_args()
    data = json.loads((HERE / 'native_results.json').read_text())
    period = data['operating_point']['period_ns']
    std_path = PACKAGE / data['library_paths']['standard_cells']
    memory_path = PACKAGE / data['library_paths']['sram']
    model = sram.Model(memory_path)
    results = {
        'case': data['case'],
        'operating_point': data['operating_point'],
        'archived_data_sha256': sha(HERE / 'native_results.json'),
        'modes': {},
    }
    for name, mode in data['modes'].items():
        wave = waveform_energy(args.waveforms / (name + '.vcd'), mode, model, period)
        native = archived_results(mode, std_path, memory_path, period)
        results['modes'][name] = {'waveform_example': wave, 'archived_native': native}
    base, epix = [
        results['modes'][name]['archived_native']['windows']['with_setup']
        for name in ('baseline', 'epix')
    ]
    results['native_total_energy_saving_percent'] = 100 * (
        1 - epix['total_energy_nj'] / base['total_energy_nj']
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(results, indent=2, allow_nan=False) + '\n')
    print(
        'PASS: waveform timing and SRAM edge energy; archived chip energy and mapped area. '
        + str(args.output)
    )


if __name__ == '__main__':
    main()
