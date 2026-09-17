#!/usr/bin/env python3
"""Combine mapped activity, cell power, and SRAM edge energy."""
import concurrent.futures as cf
import csv
import hashlib
import json
import math
import os
import re
import subprocess
import time
import fcntl
import resource
from pathlib import Path
import map as mapping
import sram_model
import sta_helpers as sta
import readback

ROOT = Path(__file__).resolve().parents[1]
PERIOD = 200000
STA = os.environ.get('OPENSTA', 'sta')
MACRO = sram_model.CELL
# Match Verilator's stack limit before starting build threads.

_stack_hard = resource.getrlimit(resource.RLIMIT_STACK)[1]
if os.uname().sysname != "Darwin":
    resource.setrlimit(resource.RLIMIT_STACK, (_stack_hard, _stack_hard))


def table(path):
    with Path(path).open() as f:
        return list(csv.DictReader(f, delimiter='\t'))


def wait_receipt(path, timeout=43200):
    end = time.time() + timeout
    while time.time() < end:
        if path.exists():
            try:
                x = json.loads(path.read_text())
                if x.get('passed'):
                    return x
            except json.JSONDecodeError:
                pass
        time.sleep(10)
    raise RuntimeError('Validated prerequisite unavailable: ' + str(path))


def inventory(design, top):
    """List all cell pins and input ports to measure."""
    m = design['modules'][top]
    rows = [
        dict(
            id=0, kind='clock', name='clk', bit=0, path=f'{top}/clk', direction='input'
        )
    ]
    for name, c in sorted(m['cells'].items()):
        for pin, bs in sorted(c['connections'].items()):
            for b in range(len(bs)):
                rows.append(
                    dict(
                        id=len(rows),
                        kind='pin',
                        name=name + '/' + pin + (f'[{b}]' if len(bs) > 1 else ''),
                        bit=b,
                        path=f'{top}/{name}/{pin}',
                        direction=c['port_directions'][pin],
                    )
                )
    for name, p in sorted(m['ports'].items()):
        if name == 'clk' or p['direction'] != 'input':
            continue
        for b in range(len(p['bits'])):
            rows.append(
                dict(
                    id=len(rows),
                    kind='port',
                    name=name + (f'[{b}]' if len(p['bits']) > 1 else ''),
                    bit=b,
                    path=f'{top}/{name}',
                    direction='input',
                )
            )
    return rows


def integrate(case, mode, out, d, trial):
    """Calculate setup and search energy, including SRAM."""
    cfg = json.loads((case / 'config.json').read_text())
    mapped = out.parent / 'closed'
    design = json.loads((mapped / 'mapped.json').read_text())
    module = design['modules'][cfg['top']]
    rows = json.loads((out / 'targets.json').read_text())
    counts = {}
    for line in (d / 'counts.tsv').read_text().splitlines():
        v = list(map(int, line.split()))
        assert len(v) == 7 and v[0] not in counts
        counts[v[0]] = v[1:]
    assert set(counts) == set(range(len(rows))), (
        'Missing traced pin targets',
        len(counts),
        len(rows),
    )
    durations = {
        'search': (int(trial['end']) - int(trial['search_begin'])) * PERIOD,
        'setup_only': (int(trial['search_begin']) - int(trial['setup_begin'])) * PERIOD,
    }
    durations['with_setup'] = sum(durations.values())
    expected = {}
    macro_names = {n for n, c in module['cells'].items() if c['type'] == MACRO}
    macro_counts = {
        n: {w: {k: 0 for k in sram_model.EDGE_KEYS} for w in durations}
        for n in macro_names
    }
    prefix = 'TOP.' + cfg['top'] + '.'
    observed = set()
    for r in table(str(d / 'trials.tsv') + '.macros.tsv'):
        assert r['instance'].startswith(prefix), r['instance']
        name = r['instance'][len(prefix) :]
        assert name in macro_names
        observed.add(name)
        w = ('search', 'setup_only')[int(r['window'])]
        macro_counts[name][w] = {k: int(r[k]) for k in sram_model.EDGE_KEYS}
    assert observed == macro_names
    for n in macro_names:
        macro_counts[n]['with_setup'] = {
            k: macro_counts[n]['search'][k] + macro_counts[n]['setup_only'][k]
            for k in sram_model.EDGE_KEYS
        }
        for w in durations:
            r = next(r for r in rows if r['kind'] == 'pin' and r['name'] == n + '/clk')
            vals = counts[r['id']]
            tog = (
                vals[0]
                if w == 'search'
                else vals[3] if w == 'setup_only' else vals[0] + vals[3]
            )
            assert tog == sum(macro_counts[n][w].values()), (
                'SRAM edge disagreement',
                n,
                w,
                tog,
                macro_counts[n][w],
            )
    # Search reads coefficient SRAM; RNG state stays outside SRAM.
    rw = {
        key: sum(macro_counts[n]['search'][key] for n in macro_names)
        for key in ('rise_ce1_we0', 'rise_ce1_we1')
    }
    assert rw['rise_ce1_we1'] == 0 and rw['rise_ce1_we0'] == int(
        trial['coefficient_reads_model']
    ), rw
    setup_writes = sum(
        macro_counts[n]['setup_only']['rise_ce1_we1'] for n in macro_names
    )
    assert setup_writes == cfg['n'], setup_writes
    for index, (w, duration) in enumerate(durations.items()):
        text = '''proc epix_activity_pin {name density duty} {set p [get_pins -quiet $name];if {[llength $p]!=1} {error "pin not unique: $name"};set_power_activity -pins $p -density $density -duty $duty}
proc epix_activity_port {name density duty} {set p [get_ports -quiet $name];if {[llength $p]!=1} {error "port not unique: $name"};set_power_activity -input_ports $p -density $density -duty $duty}
'''
        pins = inputs = 0
        for r in rows:
            v = counts[r['id']]
            vals = (
                v[:3]
                if index == 0
                else v[3:] if index == 1 else [v[j] + v[j + 3] for j in range(3)]
            )
            toggles, high, unknown = vals
            assert unknown == 0 and 0 <= high <= duration
            if r['kind'] == 'clock':
                assert toggles == 2 * duration // PERIOD and 2 * high == duration
                continue
            text += f'epix_activity_{r["kind"]} {{{r["name"]}}} {toggles*1000/duration:.17g} {high/duration:.17g}\n'
            pins += r['kind'] == 'pin'
            inputs += r['kind'] == 'port'
        (d / (w + '.activity.tcl')).write_text(text)
        expected[w] = dict(count=pins + inputs, pins=pins, inputs=inputs)
    script = (
        sta.timing_preamble(mapping.STD, mapping.SRAM, mapped / 'mapped.v', cfg['top'])
        .replace('period 100', 'period 200')
        .replace('!= 100', '!= 200')
    )
    script += (
        f'set f [open {{{d/"slews.tsv"}}} w]\nputs $f "instance\trise_ns\tfall_ns"\n'
    )
    for n in sorted(macro_names):
        script += f'set p [get_pins {{{n}/clk}}]\nputs $f [join [list {{{n}}} [get_property $p slew_max_rise] [get_property $p slew_max_fall]] "\t"]\n'
    script += 'close $f\n'
    for w in durations:
        script += f'sta::clear_power\nsource {{{d/(w+".activity.tcl")}}}\nreport_power -digits 12 > {{{d/(w+".core.txt")}}}\n'
        script += 'set macros [list]\n' + ''.join(
            f'lappend macros [get_cells {{{n}}}]\n' for n in sorted(macro_names)
        )
        script += (
            f'report_power -instances $macros -digits 12 > {{{d/(w+".macros.txt")}}}\n'
        )
    script += 'exit\n'
    script = readback.instrument(
        script, ROOT / 'flow/readback.tcl', {w: x['count'] for w, x in expected.items()}
    )
    (d / 'power.tcl').write_text(script)
    mapping.run([STA, '-exit', d / 'power.tcl'], d / 'power.log')
    checks = readback.validate(
        (d / 'power.log').read_text(),
        expected,
        {w: ['core', 'macros'] for w in durations},
    )
    model = sram_model.Model(mapping.SRAM)
    slews = {
        r['instance']: {k: float(r[k]) for k in ('rise_ns', 'fall_ns')}
        for r in table(d / 'slews.tsv')
    }
    libs = sta.Libraries(mapping.STD, mapping.SRAM)
    root = sta.root_clock_load(module, libs)
    results = {}
    for w, ps in durations.items():
        total = sta.parse_power((d / (w + '.core.txt')).read_text())
        macro = sta.parse_power(
            (d / (w + '.macros.txt'))
            .read_text()
            .replace('\\[', '[')
            .replace('\\]', ']'),
            macro_names,
        )['subtotal']
        sram_j = {scenario: 0.0 for scenario in sram_model.SCENARIOS}
        for n in macro_names:
            q = macro_counts[n][w]
            if sum(q.values()):
                energy = sram_model.count_energy(model, q, **slews[n])
                for scenario in sram_j:
                    sram_j[scenario] += energy['internal_j'][scenario]
        sec = ps * 1e-12
        components = dict(
            standard_cell_internal_j=(total['internal_w'] - macro['internal_w']) * sec,
            all_output_switching_j=total['switching_w'] * sec,
            all_leakage_j=total['leakage_w'] * sec,
            root_clock_input_charging_j=root['modeled_load_pf']
            * 1e-12
            * 1.8**2
            * ps
            / PERIOD,
        )
        assert min(components.values()) >= -1e-20
        results[w] = dict(
            duration_s=sec,
            components_j=components,
            sram_internal_j=sram_j,
            energy_j=sum(components.values()) + sram_j['full_published_model'],
        )
        results[w]['power_w'] = results[w]['energy_j'] / sec
    result = dict(
        passed=True,
        case=case.name,
        mode=mode,
        trial=int(trial['trial']),
        windows=results,
        readback=checks,
        source_trial=trial,
        macro_counts=macro_counts,
        macro_slews=slews,
        mapped_sha256=mapping.sha(mapped / 'mapped.v'),
        counts_sha256=mapping.sha(d / 'counts.tsv'),
        root_clock=root,
        method='Zero-delay mapped-pin activity over the recorded schedule; coefficient SRAM joint edge/control integral; no wire parasitics or glitch activity.',
    )
    (d / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
    print('POWER_PASS', case.name, mode, trial['trial'], flush=True)
    return result
