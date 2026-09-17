#!/usr/bin/env python3
"""Measure mapped energy and compare the run with the same RTL trial."""
import argparse
import concurrent.futures
import json
import os
from pathlib import Path
import subprocess
import time
import close_hold
import power_closed as power
import power_saif
import saif_support

ROOT = Path(__file__).resolve().parents[1]


def run(case, mode, runtime, budget, trial, simulation_timeout=7200):
    """Check one mapped trial and calculate its energy."""
    assert 0 < simulation_timeout <= 10800
    result = dict(
        case=case.name,
        mode=mode,
        budget=budget,
        trial=trial,
        started=time.time(),
        passed=False,
        simulation_timeout_s=simulation_timeout,
    )
    out = ROOT / 'results' / case.name / mode / 'power_saif'
    out.mkdir(parents=True, exist_ok=True)
    try:
        cfg = json.loads((case / 'config.json').read_text())
        closed = out.parent / 'closed/status.json'
        if not closed.exists() or not json.loads(closed.read_text()).get('passed'):
            closure = close_hold.task(case, mode)
            assert closure['passed'], closure.get('error')
        _, _, out = power_saif.build(case, mode, runtime)
        d = out / f'profile_s{budget}_t{trial}'
        d.mkdir(exist_ok=True)
        exe = out.parent / 'rtl/obj/Vdut'
        ref_status = json.loads((out.parent / 'rtl/status.json').read_text())
        assert (
            ref_status['passed']
            and power.mapping.sha(exe) == ref_status['executable_sha256']
        )
        with (d / 'rtl_reference.log').open('w') as log:
            subprocess.run(
                [str(exe), str(trial), '1', str(budget), str(d / 'rtl_reference.tsv')],
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
                timeout=3600,
            )
        with (d / 'simulation.log').open('w') as log:
            subprocess.run(
                [
                    str(out / 'obj/Vdut'),
                    str(trial),
                    '1',
                    str(budget),
                    str(d / 'trials.tsv'),
                    str(d / 'cumulative.saif'),
                ],
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
                timeout=simulation_timeout,
            )
        ref = power.table(d / 'rtl_reference.tsv')[0]
        got = power.table(d / 'trials.tsv')[0]
        for key, value in ref.items():
            assert int(got[key]) == int(value) + (
                2 if key in ('setup_begin', 'search_begin', 'end') else 0
            ), (key, value, got[key])
        assert 'ALL_PASS 1' in (d / 'simulation.log').read_text()
        a, b, e = (
            int(got[k]) * power.PERIOD for k in ('setup_begin', 'search_begin', 'end')
        )
        coverage = saif_support.counts(out, d, cfg['top'], a, b, e)
        result.update(power.integrate(case, mode, out, d, got))
        result.update(
            activity_coverage=coverage,
            native_complete=bool(int(got['complete'])),
            requested_sweeps=budget,
            rtl_reference_sha256=power.mapping.sha(exe),
            process='SKY130 HD TT plus SRAM22 TT',
            voltage_v=1.8,
            temperature_c=25,
            period_ns=200,
            scope='preliminary_mapped_activity_no_layout_parasitics',
        )
        (d / 'result.json').write_text(json.dumps(result, indent=2) + '\n')
    except Exception as error:
        result['error'] = str(error)
    result['ended'] = time.time()
    (out / f'profile_s{budget}_t{trial}_status.json').write_text(
        json.dumps(result, indent=2) + '\n'
    )
    print(
        case.name,
        mode,
        'PROFILE',
        result['passed'],
        result.get('error', ''),
        flush=True,
    )
    return result


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--cases', nargs='+', default=['maxcut32', 'chimera32'])
    p.add_argument('--budget', type=int, default=16)
    p.add_argument('--trial', type=int, default=0)
    p.add_argument(
        '--workers', type=int, default=int(os.environ.get('EPIX_FLOW_WORKERS', '1'))
    )
    p.add_argument(
        '--simulation-timeout',
        type=int,
        default=7200,
        help='Mapped simulator wall-clock limit in seconds, at most 10800; default 7200',
    )
    args = p.parse_args()
    assert 0 < args.simulation_timeout <= 10800
    runtime = saif_support.prepare()
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = [
            pool.submit(
                run,
                ROOT / 'cases' / c,
                m,
                runtime,
                args.budget,
                args.trial,
                args.simulation_timeout,
            )
            for c in args.cases
            for m in ('iid', 'epix')
        ]
        results = [f.result() for f in futures]
    (ROOT / 'results/profile_summary.json').write_text(
        json.dumps(results, indent=2) + '\n'
    )
    raise SystemExit(0 if all(r['passed'] for r in results) else 1)
