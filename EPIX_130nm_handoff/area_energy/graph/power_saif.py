#!/usr/bin/env python3
"""Simulate the mapped design and record pin activity for the full run."""
import concurrent.futures as cf
import fcntl
import json
import os
import subprocess
import time
import power_closed as power
import saif_support as saif

ROOT = power.ROOT


def read(p):
    try:
        return json.loads(p.read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def build(case, mode, runtime, threads=1):
    """Build the mapped simulator with SAIF recording enabled."""
    jobs = int(os.environ.get('EPIX_BUILD_JOBS', '2'))
    if jobs < 1:
        raise ValueError('EPIX_BUILD_JOBS must be positive')
    out = (
        ROOT
        / 'results'
        / case.name
        / mode
        / ('power_saif' if threads == 1 else f'power_saif_t{threads}')
    )
    out.mkdir(parents=True, exist_ok=True)
    with (out / 'build.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        cfg = read(case / 'config.json')
        mapped = out.parent / 'closed'
        physical = power.wait_receipt(mapped / 'status.json')
        assert physical['mapped_sha256'] == power.mapping.sha(mapped / 'mapped.v')
        harness = ROOT / 'flow/sim_saif.cpp'
        parallel_harness = None
        if threads > 1:
            original = harness.read_text()
            old = 'ctx->threads(1)'
            new = f'ctx->threads({threads})'
            assert original.count(old) == 1 and new not in original
            transformed = original.replace(old, new)
            assert transformed.replace(new, old) == original
            harness = ROOT / f'flow/sim_saif_t{threads}.cpp'
            if not harness.exists() or harness.read_text() != transformed:
                harness.write_text(transformed)
            parallel_harness = dict(
                passed=True,
                only_context_thread_count_changed=True,
                base_sha256=power.mapping.sha(ROOT / 'flow/sim_saif.cpp'),
                derived_sha256=power.mapping.sha(harness),
            )
        old = read(out / 'build.json')
        if (
            old.get('passed')
            and old['mapped_sha256'] == physical['mapped_sha256']
            and old['harness_sha256'] == power.mapping.sha(harness)
        ):
            return case, mode, out
        result = dict(
            passed=False,
            started=time.time(),
            mapped_sha256=physical['mapped_sha256'],
            activity_backend='cumulative_saif',
            simulator_threads=threads,
        )
        try:
            rows = power.inventory(read(mapped / 'mapped.json'), cfg['top'])
            (out / 'targets.json').write_text(json.dumps(rows))
            (out / 'targets.txt').write_text(
                ''.join(f'{r["id"]} {r["bit"]} {r["path"]}\n' for r in rows)
            )
            command = [
                os.environ['VERILATOR'],
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
                '--trace-saif',
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
                f'-std=c++17 -DEPIX={int(mode=="epix")} -DA1_POWER=1 -I{case}',
                str(mapped / 'mapped.v'),
                str(ROOT / 'tech/cells_sim.v'),
                str(ROOT / 'rtl/power_models.sv'),
                str(harness),
                str(ROOT / 'flow/macro_activity.cpp'),
            ]
            if threads > 1:
                command[1:1] = ['--threads', str(threads), '--threads-dpi', 'none']
            power.mapping.run(command, out / 'elaborate.log')
            make = [
                os.environ.get('MAKE', 'make'),
                '-C',
                out / 'obj',
                '-f',
                'Vdut.mk',
                '-j',
                str(jobs),
                'OPT_FAST=-O1',
                'OPT_SLOW=-O0',
                'VERILATOR_ROOT=' + str(runtime),
            ]
            if os.uname().sysname == 'Darwin':
                make += ['CXX=/usr/bin/clang++', 'LINK=/usr/bin/clang++']
            power.mapping.run(make, out / 'build.log')
            result.update(
                passed=True,
                command=command,
                make_command=list(map(str, make)),
                executable_sha256=power.mapping.sha(out / 'obj/Vdut'),
                targets=len(rows),
                model_sha256=power.mapping.sha(ROOT / 'rtl/power_models.sv'),
                harness_sha256=power.mapping.sha(harness),
                harness_source=str(harness.relative_to(ROOT)),
                parallel_harness=parallel_harness,
                canonical_harness_sha256=power.mapping.sha(ROOT / 'flow/sim.cpp'),
                saif_preparation=read(ROOT / 'SAIF_PREPARATION.json'),
            )
        except Exception as e:
            result['error'] = str(e)
        result['ended'] = time.time()
        (out / 'build.json').write_text(json.dumps(result, indent=2) + '\n')
        if not result['passed']:
            raise RuntimeError(str(result))
    print('SAIF_BUILD_PASS', case.name, mode, flush=True)
    return case, mode, out
