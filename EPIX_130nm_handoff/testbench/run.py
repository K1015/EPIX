#!/usr/bin/env python3
"""Build a selected case and compare it with the software reference."""
import argparse
import json
import os
from pathlib import Path
import platform
import shlex
import signal
import subprocess
import sys

sys.dont_write_bytecode = True
from hyper_reference import check_instance, compiled_rows, generate_trace

ROOT = Path(__file__).resolve().parents[1]
TESTBENCH = ROOT / 'testbench'
PREFIX = {'maxcut': 'kings', 'chimera': 'chimera', 'sat': 'sat', 'xorsat': 'xorsat'}


def call(command, log, timeout):
    command = [str(x) for x in command]
    with log.open('w') as output:
        child = subprocess.Popen(
            command,
            cwd=ROOT,
            stdout=output,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        try:
            code = child.wait(timeout=timeout)
        except BaseException:
            os.killpg(child.pid, signal.SIGTERM)
            try:
                child.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(child.pid, signal.SIGKILL)
                child.wait()
            raise
    if code:
        raise RuntimeError(
            f'Command failed ({code}); see {log}\n{log.read_text()[-2500:]}'
        )


def run_case(case, mode, args, work):
    """Build one mode, then run lint or simulation."""
    meta = json.loads((case / 'instance.json').read_text())
    family = meta['family']
    graph = family in ('maxcut', 'chimera')
    stem = PREFIX[family] + '_' + mode
    source_list = case / mode / 'files.f'
    out = work / case.name / mode
    out.mkdir(parents=True, exist_ok=True)
    top = stem + '_solver'
    command = [
        os.environ.get('VERILATOR', 'verilator'),
        '--assert',
        '-Wno-fatal',
        '--top-module',
        top,
        '--Mdir',
        out / 'obj',
    ]
    sources = ['-f', source_list, TESTBENCH / 'sky130_models.sv']
    if args.action == 'lint':
        call(
            command + ['--lint-only', '-DSYNTHESIS'] + sources,
            out / 'lint.log',
            args.timeout,
        )
        print(f'PASS lint {case.name} {mode}', flush=True)
        return

    budget = meta['native_sweeps'] if args.full else args.sweeps
    prefix = 'Vdut' if graph else 'Va2_core'
    includes = ['-I' + str(case), '-I' + str(TESTBENCH)]
    flags = ['-std=c++17', '-O1'] + includes
    flags += (
        ['-DEPIX=' + str(int(mode == 'epix'))]
        if graph
        else ['-DCACHE_XOR=' + str(int(family == 'xorsat'))]
    )
    command += [
        '--cc',
        '--exe',
        '--prefix',
        prefix,
        '--output-groups',
        '0',
        '--output-split',
        '5000',
        '--output-split-cfuncs',
        '2000',
        '-CFLAGS',
        shlex.join(flags),
    ]
    if not graph:
        command += ['-DA2_VERIFY']
    driver = 'graph_sim.cpp' if graph else family + '_sim.cpp'
    call(command + sources + [TESTBENCH / driver], out / 'elaborate.log', args.timeout)
    make = [
        'make',
        '-C',
        out / 'obj',
        '-f',
        prefix + '.mk',
        '-j',
        args.jobs,
        'OPT_FAST=-O1',
        'OPT_SLOW=-O0',
    ]
    if platform.system() == 'Darwin':
        make += ['CXX=/usr/bin/clang++', 'LINK=/usr/bin/clang++']
    call(make, out / 'build.log', args.timeout)
    binary = out / 'obj' / prefix
    if graph:
        call(
            [binary, 0, args.trials, budget, out / 'trials.tsv'],
            out / 'simulation.log',
            args.timeout,
        )
        if f'ALL_PASS {args.trials}' not in (out / 'simulation.log').read_text():
            raise RuntimeError('Missing graph completion message')
    else:
        problem = dict(meta['problem'], name=case.name)
        check_instance(problem)
        rows = compiled_rows(problem)
        vectors = out / 'vectors'
        vectors.mkdir(exist_ok=True)
        reference_mode = 'fresh' if mode == 'baseline' else 'epix'
        for trial in range(args.trials):
            seed = 1730 + trial
            generate_trace(problem, vectors, rows, seed, reference_mode, budget)
            vector = f'{reference_mode}_{seed}_{budget}'
            for stall in [0, 93281] if args.stalls else [0]:
                log = out / f'trial{trial}_stall{stall}.log'
                cmd = [
                    binary,
                    case / 'coefficients.hex',
                    vectors / (vector + '.header'),
                    vectors / (vector + '.trace'),
                    stall,
                ]
                if trial == 0 and stall == 0:
                    cmd += ['control']
                call(cmd, log, args.timeout)
                if not json.loads(log.read_text().strip().splitlines()[-1])['passed']:
                    raise RuntimeError(f'Reference mismatch: {log}')
    print(
        f'PASS simulate {case.name} {mode}; {args.trials} trial(s), budget {budget}',
        flush=True,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['list', 'lint', 'simulate'])
    parser.add_argument('--cases', nargs='+', help='Exact workbook case names')
    parser.add_argument('--mode', choices=['baseline', 'epix', 'both'], default='both')
    parser.add_argument('--work', type=Path, default=ROOT / 'results')
    parser.add_argument(
        '--sweeps', type=int, default=4, help='Short functional run budget'
    )
    parser.add_argument(
        '--full', action='store_true', help='Use each case\'s native budget'
    )
    parser.add_argument('--trials', type=int, default=1)
    parser.add_argument(
        '--stalls',
        action='store_true',
        help='Also check SAT/XOR-SAT with random pauses',
    )
    parser.add_argument('--jobs', type=int, default=2)
    parser.add_argument(
        '--timeout', type=int, default=7200, help='Seconds per build or run command'
    )
    args = parser.parse_args()
    if min(args.trials, args.jobs, args.timeout, args.sweeps) <= 0 or args.sweeps > 128:
        parser.error('Use positive trials/jobs/timeout and 1..128 short-run sweeps')
    available = {p.name: p for p in sorted((ROOT / 'cases').iterdir()) if p.is_dir()}
    selected = args.cases or list(available)
    if len(set(selected)) != len(selected) or set(selected) - set(available):
        parser.error('Use unique case names from ./run.sh list')
    if args.action == 'list':
        print('\n'.join(selected))
        return
    if args.action == 'simulate' and not args.cases:
        parser.error('Select the cases to simulate with --cases')
    for name in selected:
        for mode in ['baseline', 'epix'] if args.mode == 'both' else [args.mode]:
            run_case(available[name], mode, args, args.work.resolve())
    print('Results: ' + str(args.work.resolve()), flush=True)


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, subprocess.TimeoutExpired) as error:
        sys.exit(str(error))
