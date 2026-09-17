#!/usr/bin/env python3
"""Map RTL to SKY130 cells, add buffers, and check structure and timing."""
import concurrent.futures as cf
import collections
import hashlib
import json
import os
import re
import subprocess
import time
import fcntl
from pathlib import Path
import netlist_repair as repair

ROOT = Path(__file__).resolve().parents[1]
STD = ROOT / 'tech/std.lib'
SRAM = ROOT / 'tech/sram.lib'
MACRO = 'sram22_128x40m4w20'
ICG = dict(
    cell='sky130_fd_sc_hd__dlclkp_1',
    clock_pin='CLK',
    enable_pin='GATE',
    output_pin='GCLK',
)
BUFFER = dict(cell='sky130_fd_sc_hd__buf_4', input_pin='A', output_pin='X')
OldPinLibrary = repair.PinLibrary


class MultiLibrary:
    def __init__(self, path):
        self.std = OldPinLibrary(STD)
        self.sram = OldPinLibrary(SRAM)

    def pin(self, cell, pin):
        lib = self.sram if cell == MACRO else self.std
        if cell == MACRO and pin in ('addr', 'din', 'dout', 'wmask'):
            width = {'addr': 7, 'din': 40, 'dout': 40, 'wmask': 2}[pin]
            rows = [lib.pin(cell, f'{pin}[{i}]') for i in range(width)]
            return {
                k: (min if k.startswith('max_') else max)(r[k] for r in rows if k in r)
                for k in set().union(*rows)
            }
        return lib.pin(cell, pin)

    def cap(self, cell, pin):
        p = self.pin(cell, pin)
        return max(
            p[k]
            for k in ('capacitance', 'rise_capacitance', 'fall_capacitance')
            if k in p
        )


repair.PinLibrary = MultiLibrary


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def macro_clock_drivers(design, top):
    module = design['modules'][top]
    cells = module['cells']
    bit = (
        max(
            b
            for c in cells.values()
            for bs in c['connections'].values()
            for b in bs
            if isinstance(b, int)
        )
        + 1
    )
    for i, (name, c) in enumerate(list(cells.items())):
        if c['type'] != MACRO:
            continue
        old = c['connections']['clk'][0]
        new = bit
        bit += 1
        label = f'sram_clock_driver_{i}'
        cells[label] = dict(
            hide_name=0,
            type='sky130_fd_sc_hd__buf_16',
            parameters={},
            attributes={},
            port_directions={'A': 'input', 'X': 'output'},
            connections={'A': [old], 'X': [new]},
        )
        module['netnames'][label + '_out'] = dict(
            hide_name=0, bits=[new], attributes={}
        )
        c['connections']['clk'] = [new]
    return design


def run(cmd, log, cwd=None):
    with Path(log).open('w') as f:
        subprocess.run(
            list(map(str, cmd)), stdout=f, stderr=subprocess.STDOUT, cwd=cwd, check=True
        )
    text = Path(log).read_text()
    if re.search(r'(?m)^\s*(ERROR:|Error:|Error \d+:)', text):
        raise RuntimeError('Tool error: ' + str(log))


def ys(script, out, name):
    p = out / (name + '.ys')
    p.write_text(script)
    run(
        [os.environ['YOSYS'], '-Q', '-T', '-m', 'slang', '-s', p],
        out / (name + '.log'),
        out,
    )


def timing(out, top):
    p = out / 'timing.tcl'
    p.write_text(
        f'''read_liberty {STD}
read_liberty {SRAM}
read_verilog {out/'mapped.v'}
link_design {top}
create_clock -name clk -period 200 [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_input_transition 0.1 [all_inputs -no_clocks]
set_input_delay 0 -clock clk [all_inputs -no_clocks]
set_output_delay 0 -clock clk [all_outputs]
set_load 0.01 [all_outputs]
set_propagated_clock [all_clocks]
report_checks -path_delay max -group_path_count 5 -digits 9 > {out/'setup.txt'}
report_checks -path_delay min -group_path_count 5 -digits 9 > {out/'hold.txt'}
report_check_types -max_slew -max_capacitance -violators -digits 9 > {out/'electrical.txt'}
check_setup > {out/'check_setup.txt'}
exit
'''
    )
    run([os.environ['OPENSTA'], '-exit', p], out / 'timing.log')


def emit(design, out, top):
    (out / 'mapped.json').write_text(json.dumps(design))
    ys(
        f'read_json {out/"mapped.json"}\nhierarchy -check -top {top}\ncheck -assert\nwrite_verilog -noattr -noexpr -nodec -norename {out/"mapped.v"}\n',
        out,
        'emit',
    )


def task(case, mode, prepare_state=False):
    """Map one case and mode, then check the resulting netlist."""
    cfg = json.loads((case / 'config.json').read_text())
    top = cfg['top']
    out = ROOT / 'results' / case.name / mode / 'mapped'
    out.mkdir(parents=True, exist_ok=True)
    lock = (out / 'run.lock').open('a')
    fcntl.flock(lock, fcntl.LOCK_EX)
    previous = out / 'status.json'
    if previous.exists() and json.loads(previous.read_text()).get('passed'):
        print(case.name, mode, 'already passed', flush=True)
        return json.loads(previous.read_text())
    result = dict(case=case.name, mode=mode, started=time.time(), passed=False)
    try:
        rt = ROOT / 'results' / case.name / mode / 'rtl/status.json'
        deadline = time.time() + 21600
        while not rt.exists() or not json.loads(rt.read_text())['passed']:
            if time.time() > deadline:
                raise RuntimeError('RTL validation not available after six hours')
            time.sleep(10)
        sources = [
            case / 'solver.sv',
            case / 'clusters.sv',
            case / 'graph_functions.svh',
            ROOT / 'rtl/memory.sv',
        ]
        solver_input = case / 'solver.sv'
        if prepare_state:
            assert cfg['family'] == 'maxcut'
            from factor_state_reads import prepare

            result['synthesis_preparation'] = prepare(case, out / 'prepared')
            solver_input = out / 'prepared/solver.sv'
            sources += [
                solver_input,
                out / 'prepared/PREPARATION.json',
                out / 'prepared/scalar/solver.sv',
                out / 'prepared/scalar/LOWERING.json',
            ]
        result['source_sha256'] = {str(p.relative_to(ROOT)): sha(p) for p in sources}
        (out / 'abc.constr').write_text(
            'set_driving_cell sky130_fd_sc_hd__buf_4\nset_load 10\n'
        )
        script = f'''read_liberty -lib -ignore_miss_func {STD}
read_liberty -lib -ignore_miss_func {SRAM}
read_slang --no-implicit-memories --allow-use-before-declare --top {top} -I{case} -DEPIX_MODE={int(mode=='epix')} {solver_input} {case/'clusters.sv'} {ROOT/'rtl/memory.sv'}
hierarchy -check -top {top}
synth -top {top} -flatten -noabc
select -assert-none t:$mem*
check -assert
write_rtlil {out/'registers.il'}
dfflibmap -liberty {STD}
abc -constr {out/'abc.constr'} -script {ROOT/'tech/mapping.abc'} -liberty {STD}
clean -purge
check -assert
write_json {out/'mapped_unbuffered.json'}
'''
        # Reuse synthesis only for the same case, mode, and inputs.

        probe = out.parent / 'mapped_factored_probe'
        if (
            prepare_state
            and case.name == 'maxcut800'
            and (probe / 'PROBE.json').exists()
        ):
            receipt = json.loads((probe / 'PROBE.json').read_text())
            assert receipt['synthesis_pass'] and receipt['canonical_sha256'] == sha(
                case / 'solver.sv'
            )
            assert (
                receipt['prepared_sha256']
                == sha(solver_input)
                == sha(probe / 'solver.sv')
            )
            probe_script = (probe / 'probe.ys').read_text()
            front = script.split('write_rtlil ', 1)[0].replace(
                str(solver_input), str(probe / 'solver.sv')
            )
            assert probe_script.startswith(front)
            dependencies = [
                case / 'solver.sv',
                case / 'clusters.sv',
                case / 'graph_functions.svh',
                ROOT / 'rtl/memory.sv',
                STD,
                SRAM,
            ]
            assert all(
                p.stat().st_mtime_ns <= (probe / 'probe.ys').stat().st_mtime_ns
                for p in dependencies
            ), 'Probe dependency changed'
            import shutil

            shutil.copyfile(probe / 'registers.il', out / 'registers.il')
            result['generic_synthesis_reuse'] = dict(
                probe=str(probe.relative_to(ROOT)),
                receipt_sha256=sha(probe / 'PROBE.json'),
                script_sha256=sha(probe / 'probe.ys'),
                rtlil_sha256=sha(out / 'registers.il'),
                dependency_sha256={
                    str(p.relative_to(ROOT)): sha(p) for p in dependencies
                },
            )
            script = (
                f'read_rtlil {out/"registers.il"}\ndfflibmap '
                + script.split('dfflibmap ', 1)[1]
            )
        old_status = out / 'status.json'
        reusable = (
            (out / 'mapped_unbuffered.json').exists()
            and old_status.exists()
            and json.loads(old_status.read_text()).get('source_sha256')
            == result['source_sha256']
        )
        if not reusable:
            ys(script, out, 'synth')
        design = json.loads((out / 'mapped_unbuffered.json').read_text())
        design = macro_clock_drivers(design, top)
        design, audit = repair.repair_clock_design(
            design, library=STD, icg=ICG, buffer_config=BUFFER, module_name=top
        )
        (out / 'clock_buffer_audit.json').write_text(json.dumps(audit, indent=2))
        emit(design, out, top)
        timing(out, top)
        for attempt in range(8):
            if '(VIOLATED)' not in (out / 'electrical.txt').read_text():
                break
            design, ea = repair.repair_electrical_design(
                design,
                (out / 'electrical.txt').read_text(),
                library=STD,
                buffer_config=dict(
                    cell='sky130_fd_sc_hd__buf_16', input_pin='A', output_pin='X'
                ),
                module_name=top,
            )
            (out / f'electrical_repair_{attempt}.json').write_text(
                json.dumps(ea, indent=2)
            )
            emit(design, out, top)
            timing(out, top)
        module = design['modules'][top]
        cells = module['cells']
        counts = collections.Counter(c['type'] for c in cells.values())
        expected_macros = (
            cfg['expected_sram_macros']
            if mode == 'epix'
            else sum(
                (min(128, cfg['n'] - b) * cfg['replicas'] + 127) // 128
                for b in range(0, cfg['n'], 128)
            )
        )
        assert counts[MACRO] == expected_macros, (counts[MACRO], expected_macros)
        # Each RNG bit needs its own flip-flop behind the group clock gate.
        nets = [
            (k, v['bits'])
            for k, v in module['netnames'].items()
            if re.search(r'service_\d+\.rng\[\d+\]\.state$', k)
        ]
        assert len(nets) == cfg['groups'], [k for k, b in nets]
        bits = [x for k, b in nets for x in b]
        assert len(bits) == len(set(bits)) == 32 * cfg['groups']
        drivers = {
            b: (name, c['type'])
            for name, c in cells.items()
            for pin, bs in c['connections'].items()
            if c['port_directions'][pin] == 'output'
            for b in bs
            if isinstance(b, int)
        }
        assert all('df' in drivers[b][1] for b in bits)
        areas = {}
        for path in (STD, SRAM):
            lib = path.read_text()
            for typ in counts:
                match = re.search(
                    r'\bcell\s*\(\s*"?' + re.escape(typ) + r'"?\s*\)\s*\{', lib
                )
                if match:
                    body = repair._body(lib, match.end() - 1)
                    areas[typ] = float(
                        re.search(r'\barea\s*:\s*([\d.eE+-]+)', body).group(1)
                    )
        assert set(areas) == set(counts)
        result.update(
            area_um2=sum(areas[t] * v for t, v in counts.items()),
            sram_area_um2=areas[MACRO] * counts[MACRO],
            sram_macros=counts[MACRO],
            cells=len(cells),
            rng_states=len(nets),
            rng_ff_bits=len(bits),
            clock_gates=counts[ICG['cell']],
            counts=counts,
            electrical_pass='(VIOLATED)' not in (out / 'electrical.txt').read_text(),
            setup_pass='(VIOLATED)' not in (out / 'setup.txt').read_text(),
            mapped_sha256=sha(out / 'mapped.v'),
        )
        assert (
            result['electrical_pass'] and result['setup_pass']
        ), 'Timing or electrical checks failed'
        assert result['source_sha256'] == {
            str(p.relative_to(ROOT)): sha(p) for p in sources
        }, 'Sources changed during mapping'
        result['passed'] = True
    except Exception as e:
        result['error'] = str(e)
    result['ended'] = time.time()
    (out / 'status.json').write_text(json.dumps(result, indent=2) + '\n')
    print(case.name, mode, result['passed'], result.get('error', ''), flush=True)
    return result


if __name__ == '__main__':
    import argparse

    p = argparse.ArgumentParser()
    p.add_argument('--cases', nargs='*')
    p.add_argument('--prepare-state', action='store_true')
    a = p.parse_args()
    cases = [
        x
        for x in sorted((ROOT / 'cases').iterdir())
        if (x / 'config.json').exists() and (not a.cases or x.name in a.cases)
    ]
    with cf.ThreadPoolExecutor(max_workers=20) as pool:
        results = list(
            pool.map(
                lambda x: task(*x, prepare_state=a.prepare_state),
                [(c, m) for c in cases for m in ('iid', 'epix')],
            )
        )
    (ROOT / 'results/mapping_summary.json').write_text(
        json.dumps(results, indent=2) + '\n'
    )
    if not all(r['passed'] for r in results):
        raise SystemExit(1)
