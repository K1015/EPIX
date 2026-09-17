#!/usr/bin/env python3
"""Run SKY130 area and energy checks for selected cases."""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PACKAGE = HERE.parent
CONFIG = json.loads((HERE / 'case_config.json').read_text())
SEEDS = (1730, 1731, 1732)


def read(path):
    return json.loads(path.read_text())


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + '\n')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def copy(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    if not target.exists() or source.read_bytes() != target.read_bytes():
        shutil.copyfile(source, target)


def shared(source, target):
    """Check that cases use the same shared RTL."""
    if target.exists() and sha(source) != sha(target):
        raise ValueError(f'Conflicting shared RTL: {source} and {target}')
    copy(source, target)


def expand(path, stack=()):
    """Insert included HDL text into the generated source copy."""
    if path in stack:
        raise ValueError(f'Include cycle: {path}')
    return re.sub(
        r'`include\s+"([^"]+)"',
        lambda m: expand(path.parent / m[1], stack + (path,)),
        path.read_text(),
    )


def library_files(engine):
    for src, dst in [
        ('tech/sky130_hd.lib', 'std.lib'),
        ('tech/sram22_128x40.lib', 'sram.lib'),
    ]:
        copy(PACKAGE / src, engine / 'tech' / dst)
    copy(HERE / 'models/mapping.abc', engine / 'tech/mapping.abc')


def stage(names, work):
    """Copy selected sources and inputs into the run folder."""
    if any(ch.isspace() for ch in str(work) + str(PACKAGE)):
        raise ValueError(
            'Package and run paths must be free of whitespace for the synthesis recipes.'
        )
    if work == PACKAGE or PACKAGE in work.parents:
        raise ValueError(
            'Choose --work outside the source package, for example ../EPIX_130nm_results.'
        )
    files = [
        p
        for folder in ('cases', 'testbench', 'tech', 'area_energy')
        for p in (PACKAGE / folder).rglob('*')
        if p.is_file()
        and p.suffix != '.md'
        and '__pycache__' not in p.parts
        and (HERE / 'example') not in p.parents
    ]
    bound = {str(p.relative_to(PACKAGE)): sha(p) for p in sorted(files)}
    receipt = work / 'manifest.json'
    old = read(receipt) if receipt.exists() else {}
    if old and old.get('source_sha256') != bound:
        raise ValueError(
            'Run sources differ from this package; choose a fresh --work directory.'
        )
    if work.exists() and any(work.iterdir()) and not old:
        raise ValueError('Nonempty --work has no manifest; choose an empty directory.')
    work.mkdir(parents=True, exist_ok=True)
    for name in names:
        cfg = CONFIG[name]
        src = PACKAGE / 'cases' / name
        meta = read(src / 'instance.json')
        assert all(
            meta[k] == cfg[k] for k in ('family', 'n', 'target', 'native_sweeps')
        )
        if cfg['family'] in ('maxcut', 'chimera'):
            engine = work / 'graph'
            for p in (HERE / 'graph').iterdir():
                if p.is_file() and p.suffix != '.md':
                    copy(p, engine / 'flow' / p.name)
            library_files(engine)
            copy(HERE / 'models/cells_sim.v', engine / 'tech/cells_sim.v')
            for model, dst in [
                ('graph_models.sv', 'models.sv'),
                ('graph_power_models.sv', 'power_models.sv'),
            ]:
                copy(HERE / 'models' / model, engine / 'rtl' / dst)
            shared(src / 'src/memory.sv', engine / 'rtl/memory.sv')
            # Both graph builds use this source list.
            aux = PACKAGE / 'cases/kings_maxcut128_instance1/src/aux_rng.sv'
            shared(aux, engine / 'rtl/aux_rng.sv')
            case = engine / 'cases' / name
            case.mkdir(parents=True, exist_ok=True)
            (case / 'solver.sv').write_text(expand(src / 'src/solver.sv'))
            copy(src / 'src/clusters.sv', case / 'clusters.sv')
            copy(src / 'reference.h', case / 'case.hpp')
            copy(src / 'coefficients.hex', case / 'coefficients.hex')
            (case / 'graph_functions.svh').write_text(
                '// Includes are expanded in solver.sv.\n'
            )
            save(case / 'graph.json', meta['problem'])
            save(case / 'config.json', cfg)
            if cfg['family'] == 'maxcut':
                save(
                    case / 'software_spec.json',
                    {'family': 'kings', 'width': cfg['width']},
                )
        else:
            family = 'xor' if cfg['family'] == 'xorsat' else 'sat'
            public = cfg['family']
            short = public + str(cfg['n'])
            hyper = work / 'hyper'
            assert cfg['parameters'] == meta['parameters']
            shared(
                src / 'src/a2_core.sv', hyper / 'variants' / family / 'rtl/a2_core.sv'
            )
            for f in ('a2_icg.sv', 'a2_coeff_sram.sv'):
                shared(src / 'src' / f, hyper / 'rtl' / f)
            copy(src / 'coefficients.hex', hyper / 'cases' / short / 'coefficients.hex')
            for suffix, mode in [('', 'epix'), ('_iid', 'baseline')]:
                engine = hyper / ('sky130_' + family + suffix)
                for f in (HERE / 'hyper').iterdir():
                    if f.suffix in ('.tcl',) or f.name in (
                        'map.py',
                        'close_hold.py',
                        'netlist_repair.py',
                        'macro_activity.cpp',
                        'power_closed.py',
                        'saif_support.py',
                        'readback.py',
                        'sram_model.py',
                        'sta_helpers.py',
                    ):
                        copy(f, engine / 'flow' / f.name)
                campaign = public + ('_baseline' if mode == 'baseline' else '') + '.py'
                copy(HERE / 'hyper' / campaign, engine / 'flow/campaign_a2.py')
                copy(HERE / 'hyper' / (public + '_sim.cpp'), engine / 'flow/sim.cpp')
                copy(
                    PACKAGE / 'testbench/cache_reference.h',
                    engine / 'flow/cache_reference.h',
                )
                library_files(engine)
                copy(src / 'src/technology.sv', engine / 'rtl/technology.sv')
                for model in ('sky130_fd_sc_hd__dlclkp_1.sv', 'sram22_128x40m4w20.sv'):
                    copy(HERE / 'models' / model, engine / 'rtl' / model)
                copy(
                    HERE / 'models/hyper_power_models.sv',
                    engine / 'rtl/power_models.sv',
                )
                case = engine / 'cases' / short
                case.mkdir(parents=True, exist_ok=True)
                wrapper = (
                    src
                    / mode
                    / (('xorsat' if family == 'xor' else 'sat') + '_' + mode + '.sv')
                ).read_text()
                wrapper, count = re.subn(
                    r'\bmodule\s+\w+', 'module a2_chip', wrapper, count=1
                )
                assert count == 1
                (case / 'top.sv').write_text(wrapper)
                copy(src / 'src/threshold.svh', case / 'threshold.svh')
                copy(src / 'reference.h', case / 'case.h')
                save(
                    case / 'config.json',
                    dict(
                        cfg,
                        top='a2_chip',
                        expected_sram_macros=(cfg['parameters']['MEM_WORDS'] + 127)
                        // 128,
                    ),
                )
    all_names = sorted(set(names) | set(old.get('cases', [])))
    save(
        receipt,
        {
            'cases': all_names,
            'config': {n: CONFIG[n] for n in all_names},
            'source_sha256': bound,
            'method': 'SKY130 pre-route; 1.8 V, 25 C, 200 ns',
            'graph_trials': [0, 1, 2],
            'hyper_seeds': SEEDS,
        },
    )
    print(f'Prepared {len(names)} case(s): {work}', flush=True)


def call(command, log):
    log.parent.mkdir(parents=True, exist_ok=True)
    print('Running ' + ' '.join(map(str, command)), flush=True)
    with log.open('w') as out:
        subprocess.run(
            list(map(str, command)),
            stdout=out,
            stderr=subprocess.STDOUT,
            check=True,
            cwd=log.parent,
        )


def check(stage_name, output):
    """Check the tools needed for area or energy analysis."""
    checks = {}
    for env, default in [
        ('YOSYS', 'yosys'),
        ('VERILATOR', 'verilator'),
        ('OPENSTA', 'sta'),
        ('MAKE', 'make'),
    ]:
        found = shutil.which(os.environ.get(env, default))
        checks[env] = {'passed': bool(found), 'path': found}
        if found:
            os.environ[env] = found
    if checks['YOSYS']['passed']:
        r = subprocess.run(
            [
                os.environ['YOSYS'],
                '-Q',
                '-m',
                'slang',
                '-p',
                'help read_slang; help abc',
            ],
            capture_output=True,
            text=True,
            timeout=60,
        )
        checks['slang_abc'] = {
            'passed': r.returncode == 0 and 'No such command' not in r.stdout,
            'detail': (r.stdout + r.stderr)[-3000:],
        }
    if stage_name == 'energy':
        root = os.environ.get('EPIX_VERILATOR_ROOT') or os.environ.get('VERILATOR_ROOT')
        checks['saif_runtime'] = {
            'passed': bool(
                root
                and all(
                    (Path(root) / 'include' / f).is_file()
                    for f in ('verilated_saif_c.h', 'verilated_saif_c.cpp')
                )
            ),
            'path': root,
        }
        if checks['VERILATOR']['passed']:
            r = subprocess.run(
                [os.environ['VERILATOR'], '--help'],
                capture_output=True,
                text=True,
                timeout=30,
            )
            checks['trace_saif'] = {'passed': '--trace-saif' in r.stdout + r.stderr}
        if checks['OPENSTA']['passed']:
            for script, receipt in [
                ('verify_opensta.py', 'pin_activity.json'),
                ('test_readback.py', 'readback.json'),
            ]:
                try:
                    call(
                        [
                            sys.executable,
                            HERE / 'tools' / script,
                            '--sta',
                            os.environ['OPENSTA'],
                            '--output',
                            output.parent / receipt,
                        ],
                        output.parent / (script + '.log'),
                    )
                    checks[script] = {'passed': True}
                except subprocess.CalledProcessError:
                    checks[script] = {
                        'passed': False,
                        'log': str(output.parent / (script + '.log')),
                    }
    result = {
        'passed': all(c['passed'] for c in checks.values()),
        'stage': stage_name,
        'checks': checks,
    }
    save(output, result)
    for name, item in checks.items():
        print(name + ': ' + ('PASS' if item['passed'] else 'MISSING / FAILED'))
    return result['passed']


def vectors(name, work):
    """Generate matching SAT/XOR-SAT input and reference traces."""
    cfg = CONFIG[name]
    destination = work / 'hyper/cases' / (cfg['family'] + str(cfg['n']))
    ready = destination / 'vectors.json'
    if ready.exists():
        bound = read(ready)
        if all(
            (destination / f).is_file() and sha(destination / f) == h
            for f, h in bound.items()
        ):
            return
    spec = importlib.util.spec_from_file_location(
        'hyper_reference', PACKAGE / 'testbench/hyper_reference.py'
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    problem = read(PACKAGE / 'cases' / name / 'instance.json')['problem']
    module.check_instance(problem)
    rows = module.compiled_rows(problem)
    for seed in SEEDS:
        for mode in ('fresh', 'epix'):
            module.generate_trace(
                problem, destination, rows, seed, mode, cfg['native_sweeps']
            )
    save(
        ready,
        {
            p.name: sha(p)
            for p in destination.iterdir()
            if p.suffix in ('.header', '.trace', '.json') and p != ready
        },
    )


def evaluate(names, work, action, jobs):
    """Run reference checks, mapping, timing repair and optional power analysis."""
    os.environ['EPIX_BUILD_JOBS'] = str(jobs)
    os.environ['EPIX_FLOW_WORKERS'] = '1'
    if not check(action, work / 'checks' / (action + '.json')):
        raise RuntimeError(
            'Required tools are unavailable or failed their checks; see the checks directory.'
        )
    for name in names:
        cfg = CONFIG[name]
        if cfg['family'] in ('maxcut', 'chimera'):
            engine = work / 'graph'

            def run(script, extra=()):
                call(
                    [sys.executable, engine / 'flow' / script, '--cases', name, *extra],
                    engine / 'logs' / name / (script + '.log'),
                )

            run(
                'build_rtl.py',
                ['--native', '--trials', 3, '--workers', 1, '--build-jobs', jobs],
            )
            run(
                'map.py',
                (
                    ['--no-lut-register-merge']
                    if cfg['family'] == 'chimera' and cfg['n'] == 288
                    else []
                ),
            )
            run('close_hold.py')
            for mode in ('iid', 'epix'):
                assert read(engine / 'results' / name / mode / 'closed/status.json')[
                    'passed'
                ], 'Timing repair failed'
            if action == 'energy':
                for trial in range(3):
                    call(
                        [
                            sys.executable,
                            engine / 'flow/profile.py',
                            '--cases',
                            name,
                            '--budget',
                            cfg['native_sweeps'],
                            '--trial',
                            trial,
                            '--workers',
                            1,
                        ],
                        engine / 'logs' / name / f'energy_{trial}.log',
                    )
        else:
            vectors(name, work)
            family = 'xor' if cfg['family'] == 'xorsat' else 'sat'
            short = cfg['family'] + str(cfg['n'])
            for suffix in ('_iid', ''):
                engine = work / 'hyper' / ('sky130_' + family + suffix)
                call(
                    [
                        sys.executable,
                        engine / 'flow/campaign_a2.py',
                        '--cases',
                        short,
                        '--stage',
                        'all' if action == 'energy' else 'map',
                        '--workers',
                        1,
                    ],
                    engine / 'logs' / (short + '_' + action + '.log'),
                )
    call([sys.executable, HERE / 'report.py', '--work', work], work / 'report.log')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('check', 'prepare', 'area', 'energy'))
    parser.add_argument(
        '--cases',
        nargs='+',
        choices=sorted(CONFIG),
        metavar='CASE',
        help='Selected case directory names; use ./run.sh list to see them',
    )
    parser.add_argument(
        '--work', type=Path, default=PACKAGE.parent / 'EPIX_130nm_results'
    )
    parser.add_argument(
        '--stage',
        choices=('area', 'energy'),
        default='energy',
        help='Tool requirements checked by check',
    )
    parser.add_argument(
        '--jobs',
        type=int,
        default=2,
        help='Parallel compiler jobs; cases run sequentially',
    )
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error('--jobs must be positive')
    work = args.work.resolve()
    if args.action == 'check':
        # Save tool checks outside the run folder.
        output = work.parent / (work.name + '_checks') / (args.stage + '.json')
        raise SystemExit(0 if check(args.stage, output) else 1)
    if args.action != 'prepare' and not args.cases:
        parser.error('--cases is required for area/energy; select cases explicitly')
    names = args.cases or sorted(CONFIG)
    stage(names, work)
    if args.action != 'prepare':
        evaluate(names, work, args.action, args.jobs)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f'ERROR: {error}', file=sys.stderr)
        raise SystemExit(1)
