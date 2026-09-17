"""Build, map, and measure the SAT solver in SKY130."""

from pathlib import Path
import argparse
import collections
import concurrent.futures as cf
import fcntl
import hashlib
import json
import os
import re
import subprocess
import time
import traceback
import map as mapping
import close_hold
import power_closed as power
import saif_support as saif

ROOT = Path(__file__).resolve().parents[1]
A2 = ROOT.parent
os.environ.setdefault('YOSYS', 'yosys')
os.environ.setdefault('VERILATOR', 'verilator')
os.environ.setdefault('OPENSTA', os.environ.get('OPENSTA', 'sta'))


def read(p):
    return json.loads(p.read_text()) if p.exists() else {}


def save(p, d):
    p.parent.mkdir(parents=True, exist_ok=True)
    q = p.with_suffix('.tmp')
    q.write_text(json.dumps(d, indent=2) + '\n')
    q.replace(p)


def sha(p):
    return mapping.sha(p)


def fingerprint(paths):
    return {str(p.relative_to(A2)): sha(p) for p in paths}


def sources(case):
    return [
        case / 'top.sv',
        A2 / 'variants/sat/rtl/a2_core.sv',
        A2 / 'rtl/a2_icg.sv',
        A2 / 'rtl/a2_coeff_sram.sv',
        ROOT / 'rtl/technology.sv',
    ]


def execute(cmd, log):
    mapping.run(cmd, log)


def build(case, out, mapped=False):
    """Build an RTL or mapped simulator for this case."""
    out.mkdir(parents=True, exist_ok=True)
    src = (
        [
            out.parent / 'closed/mapped.v',
            ROOT / 'tech/cells_sim.v',
            ROOT / 'rtl/power_models.sv',
        ]
        if mapped
        else sources(case)
        + [
            ROOT / 'rtl/sram22_128x40m4w20.sv',
            ROOT / 'rtl/sky130_fd_sc_hd__dlclkp_1.sv',
        ]
    )
    deps = src + [
        ROOT / 'flow/sim.cpp',
        ROOT / 'flow/macro_activity.cpp',
        case / 'case.h',
        case / 'config.json',
        case / 'threshold.svh',
    ]
    bound = fingerprint(deps)
    old = read(out / 'build.json')
    if (
        old.get('passed')
        and old.get('sources') == bound
        and (out / 'obj/Vdut').exists()
        and old['executable_sha256'] == sha(out / 'obj/Vdut')
    ):
        return
    cmd = [
        os.environ['VERILATOR'],
        '--cc',
        '--exe',
        '--assert',
        '-Wall',
        '-Wno-DECLFILENAME',
        '-Wno-UNUSEDSIGNAL',
        '-Wno-UNUSEDPARAM',
        '--top-module',
        'a2_chip',
        '--prefix',
        'Vdut',
        '--Mdir',
        str(out / 'obj'),
        '-I' + str(case),
        '--output-split',
        '5000',
        '--output-split-cfuncs',
        '2000',
        '-CFLAGS',
        '-O1 -std=c++17 -I' + str(case),
    ]
    if mapped:
        cmd += ['--trace-saif', '--trace-structs', '-Wno-fatal']
    else:
        cmd += ['-DA2_PHYSICAL']
    cmd += list(
        map(str, src + [ROOT / 'flow/sim.cpp', ROOT / 'flow/macro_activity.cpp'])
    )
    execute(cmd, out / 'elaborate.log')
    make = [
        os.environ.get('MAKE', 'make'),
        '-C',
        out / 'obj',
        '-f',
        'Vdut.mk',
        '-j',
        str(int(os.environ.get('EPIX_BUILD_JOBS', '2'))),
        'OPT_FAST=-O1',
        'OPT_SLOW=-O0',
    ]
    if os.uname().sysname == 'Darwin':
        make += ['CXX=/usr/bin/clang++', 'LINK=/usr/bin/clang++']
    if mapped:
        make += ['VERILATOR_ROOT=' + str(ROOT / 'tech/saif_runtime')]
    execute(make, out / 'build.log')
    save(
        out / 'build.json',
        dict(
            passed=True,
            sources=bound,
            command=cmd,
            make_command=list(map(str, make)),
            executable_sha256=sha(out / 'obj/Vdut'),
        ),
    )


def simulate(case, out, mode, seed, stall=0, activity=False):
    """Run one seed and mode against its reference trace."""
    original = A2 / 'cases' / case.name
    stem = f'{mode}_{seed}_128'
    d = out / (stem + f'_stall{stall}')
    d.mkdir(parents=True, exist_ok=True)
    cmd = [
        out / 'obj/Vdut',
        original / 'coefficients.hex',
        original / (stem + '.header'),
        original / (stem + '.trace'),
        stall,
        d / 'trials.tsv',
    ]
    if activity:
        cmd += [d / 'cumulative.saif']
    execute(cmd, d / 'simulation.log')
    log = (d / 'simulation.log').read_text()
    assert 'ALL_PASS 1' in log and 'Warning' not in log, log
    return d, power.table(d / 'trials.tsv')[0]


def rtl(case):
    """Check RTL results for each seed, including a stalled run."""
    out = ROOT / 'results' / case.name / 'shared/rtl'
    build(case, out)
    bound = fingerprint(
        [
            A2 / 'cases' / case.name / f'{m}_{s}_128.{ext}'
            for m in ('fresh', 'epix')
            for s in (1730, 1731, 1732)
            for ext in ('header', 'trace')
        ]
    )
    old = read(out / 'status.json')
    if (
        old.get('passed')
        and old.get('vectors') == bound
        and old.get('build_sha256') == sha(out / 'build.json')
    ):
        return
    runs = []
    for mode in ('fresh', 'epix'):
        for seed in (1730, 1731, 1732):
            for stall in [0, 93281] if seed == 1730 else [0]:
                d, r = simulate(case, out, mode, seed, stall)
                r.update(mode=mode, seed=seed, stall=stall)
                runs.append(r)
    save(
        out / 'status.json',
        dict(
            passed=True, runs=runs, vectors=bound, build_sha256=sha(out / 'build.json')
        ),
    )
    print('A2_RTL_PASS', case.name, flush=True)


def mapped(case):
    """Map to SKY130 and check SRAM, private RNGs, and timing."""
    cfg = read(case / 'config.json')
    out = ROOT / 'results' / case.name / 'shared/mapped'
    out.mkdir(parents=True, exist_ok=True)
    bound = fingerprint(
        sources(case)
        + [
            case / 'threshold.svh',
            case / 'config.json',
            mapping.STD,
            mapping.SRAM,
            ROOT / 'tech/mapping.abc',
            ROOT / 'flow/netlist_repair.py',
            ROOT / 'flow/map.py',
            Path(__file__),
        ]
    )
    old = read(out / 'status.json')
    if old.get('passed') and old.get('sources') == bound:
        return
    (out / 'abc.constr').write_text(
        'set_driving_cell sky130_fd_sc_hd__buf_4\nset_load 10\n'
    )
    s = f'''read_liberty -lib -ignore_miss_func {mapping.STD}
read_liberty -lib -ignore_miss_func {mapping.SRAM}
read_slang --no-implicit-memories --allow-use-before-declare --top a2_chip -I{case} -DA2_PHYSICAL -DSYNTHESIS {' '.join(map(str,sources(case)))}
hierarchy -check -top a2_chip
synth -top a2_chip -flatten -noabc
select -assert-none t:$mem*
check -assert
dfflibmap -liberty {mapping.STD}
abc -constr {out/'abc.constr'} -script {ROOT/'tech/mapping.abc'} -liberty {mapping.STD}
clean -purge
check -assert
write_json {out/'mapped_unbuffered.json'}
'''
    if (
        not (out / 'mapped_unbuffered.json').exists()
        or read(out / 'synthesis.json').get('sources') != bound
    ):
        mapping.ys(s, out, 'synth')
        save(out / 'synthesis.json', dict(passed=True, sources=bound))
    design = read(out / 'mapped_unbuffered.json')
    design = mapping.macro_clock_drivers(design, 'a2_chip')
    design, audit = mapping.repair.repair_clock_design(
        design,
        library=mapping.STD,
        icg=mapping.ICG,
        buffer_config=mapping.BUFFER,
        module_name='a2_chip',
    )
    save(out / 'clock_buffer_audit.json', audit)
    mapping.emit(design, out, 'a2_chip')
    mapping.timing(out, 'a2_chip')
    for i in range(8):
        if '(VIOLATED)' not in (out / 'electrical.txt').read_text():
            break
        design, audit = mapping.repair.repair_electrical_design(
            design,
            (out / 'electrical.txt').read_text(),
            library=mapping.STD,
            buffer_config=dict(
                cell='sky130_fd_sc_hd__buf_16', input_pin='A', output_pin='X'
            ),
            module_name='a2_chip',
        )
        save(out / f'electrical_repair_{i}.json', audit)
        mapping.emit(design, out, 'a2_chip')
        mapping.timing(out, 'a2_chip')
    module = design['modules']['a2_chip']
    cells = module['cells']
    counts = collections.Counter(c['type'] for c in cells.values())
    assert counts[mapping.MACRO] == cfg['expected_sram_macros']
    nets = [
        (n, v['bits'])
        for n, v in module['netnames'].items()
        if re.search(r'private_rng\[\d+\]\.state_q$', n)
    ]
    assert len(nets) == cfg['n'], (len(nets), [n for n, b in nets][:5])
    bits = [b for n, bs in nets for b in bs]
    assert len(bits) == len(set(bits)) == 32 * cfg['n']
    owners = {
        b: (n, c)
        for n, c in cells.items()
        for p, bs in c['connections'].items()
        if c['port_directions'][p] == 'output'
        for b in bs
        if isinstance(b, int)
    }

    def gate_source(b):
        n, c = owners[b]
        if c['type'] == mapping.ICG['cell']:
            return n
        assert 'buf' in c['type'], (n, c['type'])
        return gate_source(c['connections']['A'][0])

    domains = []
    for n, bs in nets:
        assert all('df' in owners[b][1]['type'] for b in bs), n
        clocks = {gate_source(owners[b][1]['connections']['CLK'][0]) for b in bs}
        assert len(clocks) == 1, (n, clocks)
        domains.append(next(iter(clocks)))
    assert len(set(domains)) == cfg['n']
    bank_sources = {gate_source(cells[n]['connections']['CLK'][0]) for n in domains}
    assert len(bank_sources) == (cfg['n'] + 31) // 32, bank_sources
    assert all(
        '(VIOLATED)' not in (out / p).read_text()
        for p in ('setup.txt', 'electrical.txt')
    )
    save(
        out / 'status.json',
        dict(
            passed=True,
            case=case.name,
            mode='shared',
            sources=bound,
            mapped_sha256=sha(out / 'mapped.v'),
            sram_macros=counts[mapping.MACRO],
            rng_states=len(nets),
            rng_ff_bits=len(bits),
            private_rng_clock_domains=len(set(domains)),
            rng_upstream_banks=len(bank_sources),
            setup_pass=True,
            electrical_pass=True,
        ),
    )
    print('A2_MAP_PASS', case.name, flush=True)


def closure(case):
    """Add hold repairs and record the final cell area."""
    parent = ROOT / 'results' / case.name / 'shared'
    old = read(parent / 'closed/status.json')
    if (
        old.get('passed')
        and old.get('base_mapped_sha256')
        == read(parent / 'mapped/status.json')['mapped_sha256']
    ):
        return
    r = close_hold.task(case, 'shared')
    assert r['passed'], r


def power_trials(case):
    """Measure energy for each seed using mapped pin activity."""
    out = ROOT / 'results' / case.name / 'shared/power'
    build(case, out, True)
    measurement = fingerprint(
        [
            ROOT / 'flow' / n
            for n in (
                'sim.cpp',
                'power_closed.py',
                'sram_model.py',
                'saif_support.py',
                'sta_helpers.py',
                'readback.py',
                'readback.tcl',
                'macro_activity.cpp',
                'campaign_a2.py',
            )
        ]
        + [ROOT / 'rtl/power_models.sv']
    )
    design = read(out.parent / 'closed/mapped.json')
    save(out / 'targets.json', power.inventory(design, 'a2_chip'))

    def one(item):
        mode, i, seed = item
        original = A2 / 'cases' / case.name
        stem = f'{mode}_{seed}_128'
        d = out / (stem + '_stall0')
        old = read(d / 'result.json')
        vector = sha(original / (stem + '.trace'))
        if (
            old.get('passed')
            and old.get('measurement_sources') == measurement
            and old.get('mapped_sha256') == sha(out.parent / 'closed/mapped.v')
            and old.get('vector_sha256') == vector
        ):
            return
        d, trial = simulate(case, out, mode, seed, activity=True)
        ref = power.table(out.parent / 'rtl' / d.name / 'trials.tsv')[0]
        assert trial == ref, (trial, ref)
        a, b, e = (
            int(trial[k]) * power.PERIOD for k in ('setup_begin', 'search_begin', 'end')
        )
        coverage = saif.counts(out, d, 'a2_chip', a, b, e)
        trial['trial'] = i
        result = power.integrate(case, mode, out, d, trial)
        result.update(
            seed=seed,
            measurement_sources=measurement,
            vector_sha256=vector,
            header_sha256=sha(original / (stem + '.header')),
            coefficient_sha256=sha(original / 'coefficients.hex'),
            saif_coverage=coverage,
        )
        save(d / 'result.json', result)
        print('A2_POWER_PASS', case.name, mode, seed, flush=True)

    jobs = [
        (mode, i, seed)
        for mode in ('fresh', 'epix')
        for i, seed in enumerate((1730, 1731, 1732))
    ]
    with cf.ThreadPoolExecutor(max_workers=2) as pool:
        list(pool.map(one, jobs))


def prepare():
    """Prepare SAIF recording and standard-cell simulation models."""
    saif.prepare()
    mapping.ys(
        f'read_liberty -ignore_miss_func {mapping.STD}\nwrite_verilog -noattr {ROOT/"tech/cells_raw.v"}\n',
        ROOT / 'tech',
        'models',
    )
    raw = (ROOT / 'tech/cells_raw.v').read_text()
    raw = re.sub(r'module sky130_fd_sc_hd__dlclkp_1\b.*?endmodule', '', raw, flags=re.S)
    (ROOT / 'tech/cells_sim.v').write_text(raw)


def task(name, stage):
    """Run the requested stages for one case."""
    case = ROOT / 'cases' / name
    out = ROOT / 'results' / name / 'shared'
    out.mkdir(parents=True, exist_ok=True)
    lock = (out / 'run.lock').open('a')
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    try:
        rtl(case)
        if stage != 'rtl':
            mapped(case)
            closure(case)
        if stage == 'all':
            power_trials(case)
        save(
            out / 'COMPLETE.json',
            dict(passed=True, stage=stage, finished_epoch=time.time()),
        )
    except Exception as e:
        save(
            out / f'FAILED_{int(time.time())}.json',
            dict(error=str(e), traceback=traceback.format_exc()),
        )
        print('A2_FAILED', name, str(e), flush=True)
        raise


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--cases', nargs='+', default=['sat288'])
    p.add_argument('--stage', choices=['rtl', 'map', 'all'], default='all')
    p.add_argument('--workers', type=int, default=2)
    a = p.parse_args()
    assert all(re.fullmatch(r'sat(128|288|512|800)', n) for n in a.cases)
    if a.stage == 'all':
        prepare()
    with cf.ThreadPoolExecutor(max_workers=a.workers) as pool:
        list(pool.map(lambda n: task(n, a.stage), a.cases))
    print('A2_STAGE_COMPLETE', a.stage, flush=True)


if __name__ == '__main__':
    main()
