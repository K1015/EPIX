#!/usr/bin/env python3
"""List, inspect, evaluate or sample the bundled p-bit problems."""
import argparse
import json
from pathlib import Path

from solvers.model import Problem, problem_signature, require
from solvers.pbit import solve
from solvers.catalog import discover_instances, instance_path

ROOT = Path(__file__).resolve().parent


def load_instance(instance_id):
    path = instance_path(ROOT, instance_id)
    data = json.loads(path.read_text())
    require(data['instance_id'] == instance_id, 'Instance ID mismatch')
    require(problem_signature(data) == data['mathematical_problem_sha256'], 'Mathematical input hash mismatch')
    return Problem(data)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument('--list', action='store_true', help='List instance IDs')
    action.add_argument('--instance', help='Instance ID from --list')
    parser.add_argument('--group', help='Filter --list by family/size group')
    parser.add_argument('--describe', action='store_true', help='Print instance metadata and counts')
    parser.add_argument('--assignment', help='Evaluate a binary string instead of sampling')
    parser.add_argument('--seed', type=int, default=1)
    parser.add_argument('--betas', type=float, nargs='+', default=[0.25,0.5,1.0,2.0])
    parser.add_argument('--sweeps', type=int, default=25, help='Sweeps per beta')
    parser.add_argument('--output', type=Path, help='Save JSON to a new file')
    args = parser.parse_args()
    if args.list:
        if args.describe or args.assignment is not None or args.output:
            parser.error('--describe, --assignment and --output require --instance')
        rows = discover_instances(ROOT)
        if args.group:
            rows = [r for r in rows if r['group'] == args.group]
            if not rows:
                parser.error('Unknown group')
        for row in rows:
            print(row['instance_id'])
        return
    if args.group:
        parser.error('--group is only used with --list')
    if args.describe and args.assignment is not None:
        parser.error('Choose --describe or --assignment')
    try:
        problem = load_instance(args.instance)
        if args.describe:
            result = {k:v for k,v in problem.data.items() if k not in ('edges','constraints')}
        elif args.assignment is not None:
            require(len(args.assignment) == problem.n and set(args.assignment) <= {'0','1'}, 'Invalid binary assignment')
            bits = [int(x) for x in args.assignment]
            result = dict(instance_id=args.instance, objective=problem.objective(bits), energy=problem.energy(bits),
                          target=problem.data['objective']['target'],
                          target_reached=None if problem.target_energy is None else problem.energy(bits)==problem.target_energy)
        else:
            result = solve(problem, seed=args.seed, betas=args.betas, sweeps_per_beta=args.sweeps)
            result['mathematical_problem_sha256'] = problem_signature(problem.data)
        text = json.dumps(result, indent=2, allow_nan=False)+'\n'
        if args.output:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            with args.output.open('x') as stream:
                stream.write(text)
            print(f'Saved {args.output}')
        else:
            print(text, end='')
    except (ValueError, OSError) as exc:
        parser.exit(1, f'{exc}\n')


if __name__ == '__main__':
    main()
