#!/usr/bin/env python3
"""Generate and check short Chimera128 waveforms."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

EXAMPLE = Path(__file__).resolve().parent
ROOT = EXAMPLE.parents[1]
CASE_NAME = 'chimera_maxcut128_instance1'
CASE = ROOT / 'cases' / CASE_NAME
SIGNALS = [
    ('clk', 1),
    ('rst', 1),
    ('measure', 1),
    ('search', 1),
    ('sram_clk', 1),
    ('sram_ce', 1),
    ('sram_we', 1),
    ('rng_clock', 1),
    ('rng_state', 32),
    ('lane_visit', 1),
    ('lane_refresh', 1),
    ('lane_slot', 7),
    ('pbit0_consume', 1),
    ('local_words', 32),
    ('node_visits', 32),
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError(
            'Canonical source changed; inspect the instrumentation anchor: ' + old
        )
    return text.replace(old, new)


def wrapper(mode):
    """Add observation ports around the original RTL."""
    original = (CASE / mode / f'chimera_{mode}.sv').read_text()
    declaration = original[original.index('module ') : original.index(');') + 2]
    declaration = replace_once(
        declaration, f'module chimera_{mode}_solver', 'module waveform_example'
    )
    declaration = declaration[:-2].rstrip() + ',\n'
    declaration += '''    input wire measure, search,
    output wire sram_clk, sram_ce, sram_we, rng_clock,
    output wire [31:0] rng_state,
    output wire lane_visit, lane_refresh, pbit0_consume,
    output wire [6:0] lane_slot
);\n'''
    lane = 'dut_instance.core.service_0'
    memory = lane + '.coefficient_memory.bank[0].macro'
    rng = lane + '.replica_bank[0].site_bank[0]'
    return (
        '`timescale 1ns/1ps\n// Simulation-only observation wrapper.\n'
        + declaration
        + f'chimera_{mode}_solver dut_instance(.*);\n'
        + f'assign sram_clk={memory}.clk;\nassign sram_ce={memory}.ce;\nassign sram_we={memory}.we;\n'
        + f'assign rng_clock={rng}.rng_clock;\nassign rng_state={rng}.state;\n'
        + f'assign lane_visit=({lane}.phase=={lane}.DECIDE);\n'
        + f'assign lane_refresh=lane_visit && {lane}.refresh;\n'
        + f'assign lane_slot={lane}.slot;\nassign pbit0_consume={rng}.consume;\nendmodule\n'
    )


def harness():
    """Add waveform recording to the original reference driver."""
    source = (ROOT / 'area_energy' / 'graph' / 'sim.cpp').read_text()
    begin, end = source.index('#if VM_TRACE_FST'), source.index('#include <array>')
    source = source[:begin] + source[end:]
    definitions = ', '.join(
        '{' + json.dumps(name) + ',' + str(width) + '}' for name, width in SIGNALS
    )
    values = ', '.join('d->' + name for name, _ in SIGNALS)
    trace = (
        r'''
// Compact VCD writer: only simulation observation ports, at every halfcycle.
struct Trace {
 Vdut* d; std::ofstream out;
 struct Signal { const char* name; int width; };
 const std::array<Signal,COUNT> signals={{DEFINITIONS}};
 std::array<uint64_t,COUNT> prior{}; bool initial=true;
 explicit Trace(Vdut* dut):d(dut){}
 void open(const char* path){
   out.open(path);if(!out)throw std::runtime_error("Cannot open waveform");
   out<<"$version EPIX Chimera128 observation $end\n$timescale 1ns $end\n$scope module example $end\n";
   for(size_t i=0;i<signals.size();i++)out<<"$var wire "<<signals[i].width<<' '<<char('!'+i)<<' '<<signals[i].name<<" $end\n";
   out<<"$upscope $end\n$enddefinitions $end\n";
 }
 void dump(uint64_t picoseconds){
   const std::array<uint64_t,COUNT> values={{VALUES}};
   if(!initial && values==prior)return;
   out<<'#'<<picoseconds/1000<<'\n';
   for(size_t i=0;i<values.size();i++)if(initial||values[i]!=prior[i]){
     if(signals[i].width==1)out<<values[i]<<char('!'+i)<<'\n';
     else {out<<'b';bool started=false;for(int b=signals[i].width-1;b>=0;b--){
       bool v=(values[i]>>b)&1;if(v||started||b==0){out<<v;started=true;}}
       out<<' '<<char('!'+i)<<'\n';}
   }
   prior=values;initial=false;
 }
 void close(){out.close();}
};
'''.replace(
            'COUNT', str(len(SIGNALS))
        )
        .replace('DEFINITIONS', definitions)
        .replace('VALUES', values)
    )
    source = replace_once(source, 'using State=', trace + '\nusing State=')
    source = replace_once(
        source, 'std::make_unique<Trace>()', 'std::make_unique<Trace>(dut.get())'
    )
    source = replace_once(
        source,
        'if(argc>5){dut->trace(trace.get(),99);trace->open(argv[5]);}',
        'if(argc>5){trace->open(argv[5]);}',
    )
    source = replace_once(
        source, 'auto setup=cycles;', 'auto setup=cycles;dut->measure=1;dut->search=0;'
    )
    source = replace_once(
        source, 'auto begin=cycles;', 'auto begin=cycles;dut->search=1;'
    )
    source = replace_once(
        source,
        'if(argc>5){eval();trace->close();}',
        'if(argc>5){dut->measure=0;dut->search=0;eval();trace->close();}',
    )
    return source


def joint_edges(path):
    """Read SRAM controls just before each clock edge."""
    aliases, values, before, counts = {}, {}, {}, {'setup': {}, 'search': {}}
    clock_edges = {'setup': 0, 'search': 0}
    timing = {}
    current_time = None

    def process():
        if not before or current_time is None:
            return
        active = before.get('measure', 0)
        window = 'search' if before.get('search', 0) else 'setup'
        if values.get('search', 0) and not before.get('search', 0):
            timing['search_begin_ns'] = current_time
        if before.get('measure', 0) and not values.get('measure', 0):
            timing['end_ns'] = current_time
        if active and not before.get('clk', 0) and values.get('clk', 0):
            clock_edges[window] += 1
        old, new = before.get('sram_clk', 0), values.get('sram_clk', 0)
        if active and old != new:
            edge = 'rise' if new else 'fall'
            key = f'{edge}_ce{before.get("sram_ce", 0)}_we{before.get("sram_we", 0)}'
            counts[window][key] = counts[window].get(key, 0) + 1

    for raw in path.read_text().splitlines():
        if raw.startswith('$var '):
            fields = raw.split()
            aliases[fields[3]] = fields[4]
        elif raw.startswith('#'):
            process()
            before = dict(values)
            current_time = int(raw[1:])
        elif raw and raw[0] in '01':
            values[aliases[raw[1:]]] = int(raw[0])
        elif raw.startswith('b'):
            bits, alias = raw[1:].split()
            values[aliases[alias]] = int(bits, 2)
    process()
    return {'sram_joint_edges': counts, 'root_clock_rises': clock_edges, **timing}


def check_archived_trial(mode, row, histogram):
    """Allow the mapped run's two extra warmup cycles."""
    archived = json.loads((EXAMPLE / 'native_results.json').read_text())['modes'][mode][
        'short'
    ]
    old = {key: int(value) for key, value in archived['source_trial'].items()}
    expected = dict(old)
    for key in ('setup_begin', 'search_begin', 'end'):
        expected[key] -= 2
    if row != expected:
        raise ValueError(
            mode + ' checked RTL trial differs from the archived short reference'
        )
    macro = archived['macro_counts']['service_0.coefficient_memory.bank[0].macro']
    for here, there in (('setup', 'setup_only'), ('search', 'search')):
        nonzero = {key: value for key, value in macro[there].items() if value}
        if histogram['sram_joint_edges'][here] != nonzero:
            raise ValueError(
                mode + ' waveform SRAM activity differs from the archived reference'
            )


def command(argv, log, cwd):
    with log.open('a') as stream:
        subprocess.run(
            argv, cwd=cwd, stdout=stream, stderr=subprocess.STDOUT, check=True
        )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--work',
        type=Path,
        required=True,
        help='Separate directory for generated wrappers, builds and waveforms.',
    )
    parser.add_argument('--jobs', type=int, default=2, choices=[1, 2])
    args = parser.parse_args()
    work = args.work.expanduser().resolve()
    if work == ROOT or ROOT in work.parents:
        parser.error('--work must be outside the handoff directory')
    if ' ' in str(work) or ' ' in str(ROOT):
        parser.error('Verilator build paths must not contain spaces')
    verilator = shutil.which(os.environ.get('VERILATOR', 'verilator'))
    make = shutil.which(os.environ.get('MAKE', 'make'))
    if not verilator or not make:
        parser.error('Verilator and make are required')
    if work.exists() and any(work.iterdir()):
        parser.error('--work must be an empty or new directory')
    work.mkdir(parents=True, exist_ok=True)
    (work / 'sim.cpp').write_text(harness())
    shutil.copyfile(CASE / 'reference.h', work / 'case.hpp')
    sources = [
        p
        for p in CASE.rglob('*')
        if p.is_file() and p.suffix in ('.sv', '.svh', '.h', '.f')
    ]
    sources += [
        ROOT / 'area_energy/graph/sim.cpp',
        ROOT / 'testbench/sky130_models.sv',
        EXAMPLE / 'native_results.json',
        Path(__file__),
    ]
    hashes = {str(p.relative_to(ROOT)): sha(p) for p in sorted(sources)}
    status = {
        'case': CASE_NAME,
        'trial': 0,
        'sweeps': 16,
        'clock_period_ns': 200,
        'waveform_kind': 'RTL observation; no mapped cell activity or analog slew',
        'source_sha256': hashes,
        'modes': {},
        'passed': False,
    }
    try:
        for mode in ('baseline', 'epix'):
            out = work / mode
            out.mkdir()
            (out / 'probe.sv').write_text(wrapper(mode))
            obj = out / 'obj'
            log = out / 'build.log'
            argv = [
                verilator,
                '--cc',
                '--exe',
                '--assert',
                '-Wno-fatal',
                '--top-module',
                'waveform_example',
                '--prefix',
                'Vdut',
                '--Mdir',
                str(obj),
                '--output-split',
                '5000',
                '--output-split-cfuncs',
                '2000',
                '-f',
                str(CASE / mode / 'files.f'),
                str(ROOT / 'testbench/sky130_models.sv'),
                str(out / 'probe.sv'),
                str(work / 'sim.cpp'),
                '-CFLAGS',
                f'-O1 -std=c++17 -DEPIX={int(mode == "epix")} -I{work}',
            ]
            command(argv, log, ROOT)
            build = [
                make,
                '-C',
                str(obj),
                '-f',
                'Vdut.mk',
                '-j',
                str(args.jobs),
                'OPT_FAST=-O1',
                'OPT_SLOW=-O0',
            ]
            if sys.platform == 'darwin':
                build += ['CXX=/usr/bin/clang++', 'LINK=/usr/bin/clang++']
            command(build, log, ROOT)
            waveform = work / f'{mode}.vcd'
            receipt = out / 'trial.tsv'
            command(
                [str(obj / 'Vdut'), '0', '1', '16', str(receipt), str(waveform)],
                out / 'simulation.log',
                ROOT,
            )
            if 'ALL_PASS 1' not in (out / 'simulation.log').read_text():
                raise ValueError(
                    mode + ' did not pass the independent algorithm comparison'
                )
            row = {
                k: int(v)
                for k, v in next(csv.DictReader(receipt.open(), delimiter='\t')).items()
            }
            histogram = joint_edges(waveform)
            expected = {
                'setup': {'rise_ce1_we1': 128, 'fall_ce1_we1': 128},
                'search': {'rise_ce1_we0': 2176, 'fall_ce0_we0': 2176},
            }
            if histogram['sram_joint_edges'] != expected:
                raise ValueError(
                    mode
                    + ' SRAM edge histogram differs from the canonical short-run expectation: '
                    + str(histogram)
                )
            if histogram['root_clock_rises'] != {
                'setup': row['search_begin'] - row['setup_begin'],
                'search': row['end'] - row['search_begin'],
            }:
                raise ValueError(
                    mode
                    + ' waveform clock count differs from its checked trial receipt'
                )
            if (
                histogram['search_begin_ns'] != row['search_begin'] * 200
                or histogram['end_ns'] != row['end'] * 200
            ):
                raise ValueError(
                    mode + ' waveform markers differ from its checked trial receipt'
                )
            check_archived_trial(mode, row, histogram)
            status['modes'][mode] = {
                'passed': True,
                'archived_short_trial_matches': True,
                'source_trial': row,
                **histogram,
                'waveform_sha256': sha(waveform),
                'waveform_bytes': waveform.stat().st_size,
            }
            print(
                f'{mode}: ALL_PASS 1; {row["end"] - row["search_begin"]} search cycles; {row["local_words"]} RNG words',
                flush=True,
            )
        if hashes != {str(p.relative_to(ROOT)): sha(p) for p in sorted(sources)}:
            raise ValueError('Source files changed during the waveform run')
        status['passed'] = True
    except Exception as error:
        status['error'] = str(error)
        raise
    finally:
        (work / 'status.json').write_text(json.dumps(status, indent=2) + '\n')
    print(f'Waveforms and checked receipts: {work}')


if __name__ == '__main__':
    main()
