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
from pathlib import Path
import map as mapping
import sram_model
import sta_helpers as sta
import readback

ROOT = Path(__file__).resolve().parents[1]
PERIOD = 200000
STA = os.environ.get('OPENSTA', 'sta')
MACRO = sram_model.CELL


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


def build(case, mode):
    out = ROOT / 'results' / case.name / mode / 'power_closed'
    out.mkdir(parents=True, exist_ok=True)
    lock = (out / 'build.lock').open('a')
    fcntl.flock(lock, fcntl.LOCK_EX)
    cfg = json.loads((case / 'config.json').read_text())
    mapped = out.parent / 'closed'
    physical = wait_receipt(mapped / 'status.json')
    assert physical['mapped_sha256'] == mapping.sha(mapped / 'mapped.v')
    completed = out / 'build.json'
    if completed.exists():
        old = json.loads(completed.read_text())
        if old.get('passed') and old['mapped_sha256'] == physical['mapped_sha256']:
            return case, mode, out
    result = dict(
        passed=False, started=time.time(), mapped_sha256=physical['mapped_sha256']
    )
    try:
        design = json.loads((mapped / 'mapped.json').read_text())
        rows = inventory(design, cfg['top'])
        (out / 'targets.json').write_text(json.dumps(rows))
        (out / 'targets.txt').write_text(
            ''.join(f'{r["id"]} {r["bit"]} {r["path"]}\n' for r in rows)
        )
        command = [
            os.environ['VERILATOR'],
            '--cc',
            '--exe',
            '--build',
            '-j',
            str(int(os.environ.get('EPIX_BUILD_JOBS', '2'))),
            '--output-groups',
            '0',
            '--output-split',
            '5000',
            '--output-split-cfuncs',
            '2000',
            '--trace',
            '--trace-structs',
            '--assert',
            '-Wno-fatal',
            '--top-module',
            cfg['top'],
            '--prefix',
            'Vdut',
            '--Mdir',
            str(out / 'obj'),
            '-CFLAGS',
            f'-O1 -std=c++17 -DEPIX={int(mode=="epix")} -DA1_POWER=1 -I{case}',
            str(mapped / 'mapped.v'),
            str(ROOT / 'tech/cells_sim.v'),
            str(ROOT / 'rtl/power_models.sv'),
            str(ROOT / 'flow/sim.cpp'),
            str(ROOT / 'flow/macro_activity.cpp'),
        ]
        mapping.run(command, out / 'build.log')
        result.update(
            passed=True,
            command=command,
            executable_sha256=mapping.sha(out / 'obj/Vdut'),
            targets=len(rows),
            model_sha256=mapping.sha(ROOT / 'rtl/power_models.sv'),
            harness_sha256=mapping.sha(ROOT / 'flow/sim.cpp'),
        )
    except Exception as e:
        result['error'] = str(e)
    result['ended'] = time.time()
    completed.write_text(json.dumps(result, indent=2) + '\n')
    if not result['passed']:
        raise RuntimeError(str(result))
    print('MAPPED_BUILD_PASS', case.name, mode, flush=True)
    return case, mode, out


def simulate(case, mode, out, trial):
    """Run the mapped simulator and count SRAM events."""
    cfg = json.loads((case / 'config.json').read_text())
    d = out / f'trial{trial}'
    d.mkdir(exist_ok=True)
    native = out.parent / 'native'
    wait_receipt(native / f'trial{trial}.json')
    ref = table(native / f'trial{trial}.tsv')[0]
    # The mapped run adds two warm-up cycles before the same trial.
    a, b, e = (int(ref[k]) + 2 for k in ('setup_begin', 'search_begin', 'end'))
    (d / 'ranges.txt').write_text(f'0 {b*PERIOD} {e*PERIOD}\n1 {a*PERIOD} {b*PERIOD}\n')
    fifo = d / 'trace.pipe'
    if fifo.exists():
        fifo.unlink()
    os.mkfifo(fifo)
    # Open both FIFO ends so the writer can start.
    hold = os.open(fifo, os.O_RDWR)
    producer = consumer = None
    try:
        with (d / 'reader.log').open('w') as log:
            stream = open(fifo, 'rb', buffering=0)
            consumer = subprocess.Popen(
                [
                    str(ROOT / 'flow/activity_fast'),
                    str(out / 'targets.txt'),
                    str(d / 'ranges.txt'),
                    str(d / 'counts.tsv'),
                ],
                stdin=stream,
                stdout=log,
                stderr=subprocess.STDOUT,
            )
            with (d / 'simulation.log').open('w') as simlog:
                producer = subprocess.Popen(
                    [
                        str(out / 'obj/Vdut'),
                        str(trial),
                        '1',
                        str(cfg['native_sweeps']),
                        str(d / 'trials.tsv'),
                        str(fifo),
                    ],
                    stdout=simlog,
                    stderr=subprocess.STDOUT,
                )
                # Close the FIFO after the writer exits so the counter can finish.
                while producer.poll() is None:
                    if consumer.poll() is not None:
                        producer.terminate()
                        raise RuntimeError(
                            'Activity counter exited before simulation; inspect reader.log'
                        )
                    time.sleep(2)
                rc = producer.returncode
                os.close(hold)
                hold = None
                cr = consumer.wait()
                stream.close()
                assert rc == 0 and cr == 0, (rc, cr)
    finally:
        if hold is not None:
            os.close(hold)
        for p in (producer, consumer):
            if p is not None and p.poll() is None:
                p.terminate()
        fifo.unlink(missing_ok=True)
    got = table(d / 'trials.tsv')[0]
    for k, v in ref.items():
        assert int(got[k]) == int(v) + (
            2 if k in ('setup_begin', 'search_begin', 'end') else 0
        ), (k, got[k], v)
    assert 'ALL_PASS 1' in (d / 'simulation.log').read_text()
    return integrate(case, mode, out, d, got)


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
    # Write coefficients during setup; read them during search.
    search_reads = sum(macro_counts[n]['search']['rise_ce1_we0'] for n in macro_names)
    search_writes = sum(macro_counts[n]['search']['rise_ce1_we1'] for n in macro_names)
    setup_reads = sum(
        macro_counts[n]['setup_only']['rise_ce1_we0'] for n in macro_names
    )
    setup_writes = sum(
        macro_counts[n]['setup_only']['rise_ce1_we1'] for n in macro_names
    )
    assert search_reads == int(trial['coefficient_reads']) and search_writes == 0
    assert setup_reads == 0 and setup_writes == int(trial['setup_coefficient_writes'])
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
        if macro_names:
            script += f'report_power -instances $macros -digits 12 > {{{d/(w+".macros.txt")}}}\n'
    script += 'exit\n'
    script = readback.instrument(
        script, ROOT / 'flow/readback.tcl', {w: x['count'] for w, x in expected.items()}
    )
    (d / 'power.tcl').write_text(script)
    mapping.run([STA, '-exit', d / 'power.tcl'], d / 'power.log')
    checks = readback.validate(
        (d / 'power.log').read_text(),
        expected,
        {w: ('core', 'macros') if macro_names else ('core',) for w in durations},
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
        macro = (
            sta.parse_power(
                (d / (w + '.macros.txt'))
                .read_text()
                .replace('\\[', '[')
                .replace('\\]', ']'),
                macro_names,
            )['subtotal']
            if macro_names
            else dict(internal_w=0, switching_w=0, leakage_w=0)
        )
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
        method='Complete zero-delay mapped-pin activity, full native schedule, SRAM joint edge/control integral; no wire parasitics or glitch activity.',
    )
    (d / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
    print('POWER_PASS', case.name, mode, trial['trial'], flush=True)
    return result


def run_case(args):
    case, mode, out = args
    res = []
    for trial in range(3):
        try:
            res.append(simulate(case, mode, out, trial))
        except Exception as e:
            (out / f'trial{trial}/FAILED.json').write_text(
                json.dumps(dict(error=str(e)), indent=2) + '\n'
            )
            raise
    return res


def prepare():
    mapping.ys(
        f'read_liberty -ignore_miss_func {mapping.STD}\nwrite_verilog -noattr {ROOT/"tech/cells_raw.v"}\n',
        ROOT / 'tech',
        'models',
    )
    raw = (ROOT / 'tech/cells_raw.v').read_text()
    raw = re.sub(r'module sky130_fd_sc_hd__dlclkp_1\b.*?endmodule', '', raw, flags=re.S)
    (ROOT / 'tech/cells_sim.v').write_text(raw)
    mapping.run(
        [
            'g++',
            '-O3',
            '-std=c++17',
            ROOT / 'flow/activity_fast.cpp',
            '-o',
            ROOT / 'flow/activity_fast',
        ],
        ROOT / 'flow/activity_build.log',
    )


if __name__ == '__main__':
    import argparse

    p = argparse.ArgumentParser()
    p.add_argument('--cases', nargs='*')
    a = p.parse_args()
    prepare()
    cases = [
        c
        for c in sorted((ROOT / 'cases').iterdir())
        if not a.cases or c.name in a.cases
    ]
    results = []
    with cf.ThreadPoolExecutor(max_workers=6) as builders, cf.ThreadPoolExecutor(
        max_workers=6
    ) as simulations:
        built = [builders.submit(build, c, m) for c in cases for m in ('iid', 'epix')]
        running = []
        for f in cf.as_completed(built):
            try:
                running.append(simulations.submit(run_case, f.result()))
            except Exception as e:
                print('BUILD_ERROR', str(e), flush=True)
        for f in cf.as_completed(running):
            try:
                results.extend(f.result())
            except Exception as e:
                print('POWER_ERROR', str(e), flush=True)
    (ROOT / 'results/power_summary.json').write_text(
        json.dumps(results, indent=2) + '\n'
    )
    if len(results) != len(cases) * 2 * 3:
        raise SystemExit(1)
