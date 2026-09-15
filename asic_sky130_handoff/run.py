#!/usr/bin/env python3
"""Run paired IID/EPIX RTL checks or the SKY130 energy comparison."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'scripts'))
from case_catalog import CASE_IDS, RUN_ORDER


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--validate-only', action='store_true', help='Compare software and RTL without synthesis or power analysis')
    parser.add_argument('--cases', nargs='+', choices=CASE_IDS, default=list(RUN_ORDER), metavar='CASE')
    parser.add_argument('--work', type=Path, default=ROOT / 'runs/sky130_full')
    parser.add_argument('--profile', choices=('pilot', 'full'), default='full')
    parser.add_argument('--trials', type=int, default=3, help='Paired trials per case for --validate-only')
    parser.add_argument('--jobs', type=int, choices=(1, 2), default=2, help='Compiler workers per case')
    parser.add_argument('--case-jobs', type=int, choices=(1, 2, 4), default=1, help='Concurrent energy cases')
    parser.add_argument('--build-timeout', type=int, default=7200)
    parser.add_argument('--run-timeout', type=int, default=86400)
    parser.add_argument('--min-free-gb', type=float, default=20, help='Free disk space required before energy stages')
    args = parser.parse_args(argv)
    if not 1 <= args.trials <= 1000 or min(args.build_timeout, args.run_timeout) <= 0:
        parser.error('Use 1..1000 trials and positive timeouts')
    os.environ['PYTHONDONTWRITEBYTECODE'] = '1'
    work = args.work.resolve()
    common = ['--jobs', str(args.jobs), '--build-timeout', str(args.build_timeout),
              '--run-timeout', str(args.run_timeout)]
    if args.validate_only:
        for case_id in dict.fromkeys(args.cases):
            print('Checking', case_id, flush=True)
            subprocess.run([sys.executable, str(ROOT / 'cases' / case_id / 'portable.py'),
                            '--vectors', '--rtl', '--mode', 'both', '--trials', str(args.trials),
                            '--work-dir', str(work / case_id), *common], cwd=ROOT, check=True)
    else:
        subprocess.run([sys.executable, str(ROOT / 'scripts/run_energy_suite.py'),
                        '--work', str(work), '--profile', args.profile, '--cases', *args.cases,
                        '--case-jobs', str(args.case_jobs), '--min-free-gb', str(args.min_free_gb),
                        *common], cwd=ROOT, check=True)


if __name__ == '__main__':
    try:
        main()
    except subprocess.CalledProcessError as error:
        raise SystemExit(error.returncode)
