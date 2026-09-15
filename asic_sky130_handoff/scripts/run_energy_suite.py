#!/usr/bin/env python3
"""Run independent cases, reusing only verified stages from unchanged source."""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import fcntl
import hashlib
import json
import os
import signal
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'flow'))
import cad
import power
from case_catalog import CASE_IDS, RUN_ORDER
from report_suite import write_reports

PROFILES = {'pilot': (3, 3), 'full': (1000, 32)}
EXCLUDE = {'evidence', 'historical', 'provenance', '__pycache__', 'work', 'build', 'runs'}


def read(path):
    return json.loads(path.read_text())


def write(path, value):
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')
    temporary.replace(path)


def binding(case_id, technology):
    files = []
    for folder in [ROOT / 'cases' / case_id, *[ROOT / name for name in ('software', 'rtl', 'flow', 'scripts', 'tools')]]:
        files += [path for path in folder.rglob('*') if path.is_file()
                  and not EXCLUDE.intersection(path.relative_to(folder).parts)
                  and path.suffix not in ('.md', '.pyc', '.log')]
    adapter = cad.load_technology(technology)
    files += [Path(path) for path in (technology, adapter['liberty'])]
    config = adapter['config']
    files.append((technology.parent / config['mapping']['abc_script']).resolve())
    for name, default in [('YOSYS', 'yosys'), ('VERILATOR', 'verilator'), ('OPENSTA', 'sta'), ('FST2VCD', 'fst2vcd')]:
        executable = shutil.which(os.environ.get(name, default))
        if not executable:
            raise ValueError('Missing tool: ' + name)
        path = Path(executable).resolve()
        files.append(path)
        # OSS CAD launchers delegate to binaries beside their bin directory.
        for nested in (path.parent.parent / 'libexec' / path.name,
                       path.parent.parent / 'libexec' / (path.name + '_bin')):
            if nested.is_file():
                files.append(nested)
    lz4 = os.environ.get('LZ4_LIBRARY', os.environ.get('LZ4_STATIC'))
    if lz4:
        files.append(Path(lz4).resolve())
    result = {str(path.resolve()): power.sha(path) for path in sorted(set(files))}
    for name in ('PATH', 'CC', 'CXX', 'MAKE', 'CFLAGS', 'CXXFLAGS', 'LDFLAGS', 'LDLIBS',
                 'LD_LIBRARY_PATH', 'LIBRARY_PATH', 'YOSYS_SLANG_PLUGIN'):
        result['environment:' + name] = hashlib.sha256(os.environ.get(name, '').encode()).hexdigest()
    result['python'] = hashlib.sha256(sys.version.encode()).hexdigest()
    return result


def require_same_binding(saved, current):
    if saved != current:
        raise ValueError('Source, input, technology or tools changed; choose a new work directory')


def next_attempt(directory, stage):
    number = 1
    while (directory / f'{stage}_{number:03d}').exists():
        number += 1
    result = directory / f'{stage}_{number:03d}'
    result.mkdir()
    return result


def run(command, log, timeout):
    print('RUN', ' '.join(map(str, command)), flush=True)
    with log.open('x') as stream:
        process = subprocess.Popen(list(map(str, command)), cwd=ROOT, stdout=stream,
                                   stderr=subprocess.STDOUT, start_new_session=True)
        try:
            code = process.wait(timeout=timeout)
        except BaseException:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            raise
        if code:
            raise subprocess.CalledProcessError(code, command)


def resources(work, minimum):
    free = shutil.disk_usage(work).free / 2**30
    if free < minimum:
        raise ValueError(f'Only {free:.1f} GiB free; this run requires at least {minimum:g} GiB before each stage')


def reference_files(directory, trials):
    outputs = {}
    for mode in ('baseline', 'epix'):
        vector = read(directory / 'vectors' / (mode + '.json'))
        rtl = read(directory / ('rtl_' + mode) / 'validation.json')
        if not vector.get('passed') or not rtl.get('passed') or min(vector.get('trials', 0), rtl.get('trials', 0)) < trials:
            raise ValueError('Incomplete functional validation: ' + mode)
        for path in [directory / 'vectors' / (mode + suffix) for suffix in ('.bin', '.json')] + [
                directory / ('rtl_' + mode) / name for name in ('validation.json', 'trials.tsv')]:
            outputs[str(path.relative_to(directory))] = power.sha(path)
        if vector['sha256'] != outputs['vectors/' + mode + '.bin'] or rtl['vector_sha256'] != vector['sha256']:
            raise ValueError('Reference vector bytes differ: ' + mode)
        if rtl['receipt_sha256'] != outputs['rtl_' + mode + '/trials.tsv']:
            raise ValueError('Functional result bytes differ: ' + mode)
    return outputs


def run_case(case_id, work, args, suite):
    directory = work / case_id
    directory.mkdir(exist_ok=True)
    state_path = directory / 'state.json'
    current = binding(case_id, args.tech)
    state = read(state_path) if state_path.exists() else dict(case_id=case_id, binding=current)
    require_same_binding(state['binding'], current)
    state.pop('error', None)
    write(state_path, state)
    case = ROOT / 'cases' / case_id
    functional, activity_trials = PROFILES[args.profile]
    stage_timeout = 4 * args.build_timeout + 2 * args.run_timeout
    try:
        if 'reference' in state:
            reference = directory / state['reference']['directory']
            if reference_files(reference, functional) != state['reference']['outputs']:
                raise ValueError('Saved reference outputs changed')
        else:
            resources(work, args.min_free_gb)
            attempt = next_attempt(directory, 'reference')
            reference = attempt / 'run'
            run([sys.executable, case / 'portable.py', '--vectors', '--rtl', '--trials', functional,
                 '--jobs', args.jobs, '--build-timeout', args.build_timeout,
                 '--run-timeout', args.run_timeout, '--work-dir', reference], attempt / 'run.log', stage_timeout)
            require_same_binding(current, binding(case_id, args.tech))
            state['reference'] = dict(directory=str(reference.relative_to(directory)), outputs=reference_files(reference, functional))
            write(state_path, state)
        if 'mapping' in state:
            mapped = directory / state['mapping']
            for mode in ('baseline', 'epix'):
                cad.require_timing(read(mapped / mode / 'resolved.json'))
        else:
            resources(work, args.min_free_gb)
            attempt = next_attempt(directory, 'mapping')
            for mode in ('baseline', 'epix'):
                for stage in ('synth', 'timing'):
                    resources(work, args.min_free_gb)
                    run([sys.executable, ROOT / 'flow/cad.py', stage, '--case', case,
                         '--tech', args.tech, '--mode', mode, '--work', attempt], attempt / f'{mode}_{stage}.log', args.build_timeout)
            require_same_binding(current, binding(case_id, args.tech))
            mapped = attempt / case_id / suite['technology_id']
            for mode in ('baseline', 'epix'):
                cad.require_timing(read(mapped / mode / 'resolved.json'))
            state['mapping'] = str(mapped.relative_to(directory))
            write(state_path, state)
        power.validate_inputs(case, reference, mapped, read(args.tech), activity_trials, args.profile == 'pilot')
        if 'energy' not in state:
            resources(work, args.min_free_gb)
            attempt = next_attempt(directory, 'energy')
            output = attempt / 'run'
            command = [sys.executable, ROOT / 'flow/power.py', '--case', case, '--tech', args.tech,
                       '--reference-work', reference, '--mapped-root', mapped, '--output', output,
                       '--trials', activity_trials, '--jobs', args.jobs,
                       '--build-timeout', args.build_timeout, '--run-timeout', args.run_timeout]
            if args.profile == 'pilot':
                command += ['--smoke']
            run(command, attempt / 'run.log', stage_timeout)
            require_same_binding(current, binding(case_id, args.tech))
            record = output / 'energy_record.json'
            power.report_energy.summarize(read(record), output, pilot=args.profile == 'pilot')
            state['energy'] = dict(directory=str(output.relative_to(directory)), record_sha256=power.sha(record))
            write(state_path, state)
        # Aggregation rechecks the complete result bundle even for a resumed case.
        from report_suite import summarize_case
        summarize_case(case_id, state, directory, args.profile)
        state['status'] = 'pilot_complete' if args.profile == 'pilot' else 'complete'
        write(state_path, state)
    except Exception as error:
        state.update(status='pending', error=str(error))
        write(state_path, state)
        raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--work', type=Path, required=True)
    parser.add_argument('--profile', choices=PROFILES, required=True)
    parser.add_argument('--cases', nargs='+', metavar='CASE', choices=CASE_IDS, default=list(RUN_ORDER))
    parser.add_argument('--tech', type=Path, default=ROOT / 'tech/sky130_hd/config_200ns.json')
    parser.add_argument('--jobs', type=int, choices=(1, 2), default=2)
    parser.add_argument('--case-jobs', type=int, choices=(1, 2, 4), default=1)
    parser.add_argument('--min-free-gb', type=float, default=20)
    parser.add_argument('--build-timeout', type=int, default=7200)
    parser.add_argument('--run-timeout', type=int, default=86400)
    args = parser.parse_args()
    os.environ.setdefault('YOSYS_SLANG_PLUGIN', 'slang')
    work, args.tech = args.work.resolve(), args.tech.resolve()
    if ' ' in str(work) or ' ' in str(ROOT):
        parser.error('Source and work paths must not contain spaces')
    if args.min_free_gb <= 0 or min(args.build_timeout, args.run_timeout) <= 0:
        parser.error('Resource and timeout limits must be positive')
    work.mkdir(parents=True, exist_ok=True)
    suite = dict(schema='asic_energy_suite_v1', profile=args.profile, case_ids=list(RUN_ORDER),
                 functional_trials=PROFILES[args.profile][0], activity_trials=PROFILES[args.profile][1],
                 technology=str(args.tech), technology_sha256=power.sha(args.tech),
                 technology_id=read(args.tech)['id'])
    with (work / '.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        specification = work / 'SUITE.json'
        if specification.exists():
            if read(specification) != suite:
                parser.error('Saved suite has another profile or technology; use a new work directory')
        else:
            write(specification, suite)
        failed = False
        with ThreadPoolExecutor(max_workers=args.case_jobs) as workers:
            pending = {workers.submit(run_case, case_id, work, args, suite): case_id
                       for case_id in dict.fromkeys(args.cases)}
            for future in as_completed(pending):
                try:
                    future.result()
                except Exception as error:
                    failed = True
                    print(f'{pending[future]}: {error}', file=sys.stderr)
                # Only this thread writes the shared summary files.
                write_reports(work)
        print('Results:', work / 'ENERGY.md')
        if failed:
            raise SystemExit(1)


if __name__ == '__main__':
    main()
