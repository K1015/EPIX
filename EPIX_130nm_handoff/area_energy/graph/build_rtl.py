#!/usr/bin/env python3
"""Build the RTL simulator and check its results against the reference."""
import argparse
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time
import resource
import signal

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_VERILATOR = 'verilator'
_stack_hard = resource.getrlimit(resource.RLIMIT_STACK)[1]
if os.uname().sysname != "Darwin":
    resource.setrlimit(resource.RLIMIT_STACK, (_stack_hard, _stack_hard))


def run_owned(command, *, stdout, stderr, check, timeout):
    """Run a build or simulation; stop its workers if it fails or times out."""
    child = subprocess.Popen(
        command, stdout=stdout, stderr=stderr, start_new_session=True
    )
    try:
        code = child.wait(timeout=timeout)
        if check and code:
            raise subprocess.CalledProcessError(code, command)
        return subprocess.CompletedProcess(command, code)
    except BaseException:
        # Stop only this run's build or simulation workers.
        # Keep logs and build files for inspection.
        try:
            os.killpg(child.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
        try:
            child.wait(timeout=10)
        except subprocess.TimeoutExpired:
            pass
        try:
            os.killpg(child.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        child.wait()
        raise


def prepare_fast_harness():
    """Create a simulator harness without waveform recording."""
    source = (ROOT / 'flow/sim.cpp').read_text()
    begin = source.index('#if VM_TRACE_FST')
    end = source.index('#include <array>', begin)
    fast = (
        source[:begin]
        + 'struct Trace {void dump(uint64_t){} void open(const char*){} void close(){}};\n'
        + source[end:]
    )
    old = 'if(argc>5){dut->trace(trace.get(),99);trace->open(argv[5]);}'
    assert fast.count(old) == 1
    fast = fast.replace(
        old,
        'if(argc>5)throw std::runtime_error("Fast RTL executable has no waveform output");',
    )
    path = ROOT / 'flow/sim_fast.cpp'
    if not path.exists() or path.read_text() != fast:
        path.write_text(fast)
    (ROOT / 'FAST_HARNESS.json').write_text(
        json.dumps(
            {
                'canonical_sha256': sha(ROOT / 'flow/sim.cpp'),
                'fast_sha256': sha(path),
                'change': 'Trace object and trace setup only; native model and cycle driver unchanged',
            },
            indent=2,
        )
        + '\n'
    )


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def task(name, mode, jobs, trials, budget, native):
    """Build one case and mode, then check its simulation results."""
    case = ROOT / 'cases' / name
    cfg = json.loads((case / 'config.json').read_text())
    out = ROOT / 'results' / name / mode / 'rtl'
    out.mkdir(parents=True, exist_ok=True)
    sources = [
        case / 'solver.sv',
        case / 'clusters.sv',
        ROOT / 'rtl/memory.sv',
        ROOT / 'rtl/models.sv',
        ROOT / 'rtl/aux_rng.sv',
        ROOT / 'flow/sim_fast.cpp',
    ]
    bound = sources + [
        case / 'case.hpp',
        case / 'graph_functions.svh',
        case / 'config.json',
        ROOT / 'flow/sim.cpp',
    ]
    hashes = {str(p.relative_to(ROOT)): sha(p) for p in bound}
    result = dict(
        case=name, mode=mode, started=time.time(), passed=False, source_sha256=hashes
    )
    try:
        old = (
            json.loads((out / 'status.json').read_text())
            if (out / 'status.json').exists()
            else {}
        )
        exe = out / 'obj/Vdut'
        if (
            old.get('build_passed')
            and old.get('source_sha256') == hashes
            and exe.exists()
            and old.get('executable_sha256') == sha(exe)
        ):
            result['build_reused'] = True
        else:
            command = [
                os.environ.get('VERILATOR', DEFAULT_VERILATOR),
                '--cc',
                '--exe',
                '--verilate-jobs',
                str(jobs),
                '--output-groups',
                '0',
                '--output-split',
                '5000',
                '--output-split-cfuncs',
                '2000',
                '--assert',
                '-Wno-fatal',
                '--top-module',
                cfg['top'],
                '--prefix',
                'Vdut',
                '--Mdir',
                str(out / 'obj'),
                '-I' + str(case),
                '-DEPIX_MODE=' + str(int(mode == 'epix')),
                '-CFLAGS',
                f'-O1 -std=c++17 -DEPIX={int(mode=="epix")} -I{case}',
            ] + list(map(str, sources))
            result['command'] = command
            with (out / 'build.log').open('w') as log:
                run_owned(
                    command,
                    stdout=log,
                    stderr=subprocess.STDOUT,
                    check=True,
                    timeout=7200,
                )
            make = [
                os.environ.get('MAKE', 'make'),
                '-C',
                str(out / 'obj'),
                '-f',
                'Vdut.mk',
                '-j',
                str(jobs),
                'OPT_FAST=-O1',
                'OPT_SLOW=-O0',
            ]
            if os.uname().sysname == 'Darwin':
                make += ['CXX=/usr/bin/clang++', 'LINK=/usr/bin/clang++']
            result['make_command'] = make
            with (out / 'build.log').open('a') as log:
                run_owned(
                    make, stdout=log, stderr=subprocess.STDOUT, check=True, timeout=7200
                )
        result.update(build_passed=True, executable_sha256=sha(exe))
        if native:
            with (out / 'smoke.log').open('w') as log:
                run_owned(
                    [str(exe), '0', '1', '8', str(out / 'smoke.tsv')],
                    stdout=log,
                    stderr=subprocess.STDOUT,
                    check=True,
                    timeout=1800,
                )
            assert 'ALL_PASS 1' in (out / 'smoke.log').read_text()
            result.update(smoke_passed=True, state='native_running')
            (out / 'status.json').write_text(json.dumps(result, indent=2) + '\n')
        run_budget = cfg['native_sweeps'] if native else budget
        label = 'native' if native else 'smoke'
        command = [
            str(exe),
            '0',
            str(trials),
            str(run_budget),
            str(out / (label + '.tsv')),
        ]
        result['simulation_command'] = command
        with (out / (label + '.log')).open('w') as log:
            run_owned(
                command, stdout=log, stderr=subprocess.STDOUT, check=True, timeout=7200
            )
        assert f'ALL_PASS {trials}' in (out / (label + '.log')).read_text()
        assert hashes == {
            str(p.relative_to(ROOT)): sha(p) for p in bound
        }, 'Sources changed during validation'
        result.update(
            passed=True,
            trials=trials,
            budget=run_budget,
            native_budget=native,
            receipt_sha256=sha(out / (label + '.tsv')),
            state='complete',
        )
    except Exception as error:
        result['error'] = str(error)
        result['state'] = 'failed'
    result['ended'] = time.time()
    (out / 'status.json').write_text(json.dumps(result, indent=2) + '\n')
    print(name, mode, result['passed'], result.get('error', ''), flush=True)
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument(
        '--cases',
        nargs='+',
        default=['maxcut32', 'chimera32', 'maxcut128', 'chimera128'],
    )
    p.add_argument(
        '--modes', nargs='+', choices=['iid', 'epix'], default=['iid', 'epix']
    )
    p.add_argument(
        '--workers', type=int, default=int(os.environ.get('EPIX_FLOW_WORKERS', '1'))
    )
    p.add_argument(
        '--build-jobs', type=int, default=int(os.environ.get('EPIX_BUILD_JOBS', '2'))
    )
    p.add_argument('--trials', type=int, default=2)
    p.add_argument('--budget', type=int, default=8)
    p.add_argument('--native', action='store_true')
    args = p.parse_args()
    prepare_fast_harness()
    assert args.workers * args.build_jobs <= (os.cpu_count() or 1)
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = [
            pool.submit(
                task, c, m, args.build_jobs, args.trials, args.budget, args.native
            )
            for c in args.cases
            for m in args.modes
        ]
        rows = [f.result() for f in futures]
    label = 'native' if args.native else 'rtl'
    (ROOT / 'results' / f'{label}_summary.json').write_text(
        json.dumps(rows, indent=2) + '\n'
    )
    raise SystemExit(0 if all(r['passed'] for r in rows) else 1)
