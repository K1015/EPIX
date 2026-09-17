"""Sequential binary heat-bath reference with fresh software random draws."""
import hashlib
import math
import random
from .model import require


def probability_one(beta, q):
    z = beta*q
    if z >= 0:
        return 1.0/(1.0+math.exp(-z))
    value = math.exp(z)
    return value/(1.0+value)


def derived_seed(seed, domain):
    return int.from_bytes(hashlib.sha256(f'{seed}/{domain}'.encode()).digest(), 'big')


def solve(problem, *, seed=1, betas=(0.25, 0.5, 1.0, 2.0), sweeps_per_beta=25):
    require(type(seed) is int, 'seed must be an integer')
    require(type(sweeps_per_beta) is int and sweeps_per_beta > 0, 'sweeps must be positive')
    require(bool(betas) and all(math.isfinite(b) and b >= 0 for b in betas), 'betas must be finite and nonnegative')
    init = random.Random(derived_seed(seed, 'initialization'))
    sample = random.Random(derived_seed(seed, 'sampling'))
    bits = [init.getrandbits(1) for _ in range(problem.n)]
    initial_bits = ''.join(map(str,bits))
    current = problem.energy(bits)
    best, best_bits = current, bits.copy()
    visits = changes = completed_sweeps = 0
    log = []
    for beta in betas:
        if best == problem.target_energy:
            break
        for _ in range(sweeps_per_beta):
            before = visits
            for site in range(problem.n):
                q = problem.conditional_q(bits,site)
                old = bits[site]
                new = int(sample.random() < probability_one(beta,q))
                visits += 1
                if new != old:
                    current += q if old else -q
                    bits[site] = new
                    changes += 1
                    if current < best:
                        best,best_bits = current,bits.copy()
                if best == problem.target_energy:
                    break
            completed_sweeps += int(visits-before == problem.n)
            require(current == problem.energy(bits), 'Incremental energy disagrees with full objective')
            if best == problem.target_energy:
                break
        log.append(dict(beta=beta, visits=visits, best_energy=best, final_energy=current))
    require(best == problem.energy(best_bits), 'Best assignment did not rescore')
    if problem.target_energy is not None:
        require(best >= problem.target_energy, 'Observed score exceeds the recorded optimum')
    return dict(instance_id=problem.data['instance_id'], solver='sequential_binary_heat_bath_reference_v1',
                rng='Python random.Random, separate initialization and sampling streams',
                seed=seed, betas=list(betas), sweeps_per_beta=sweeps_per_beta,
                initial_assignment=initial_bits, best_assignment=''.join(map(str,best_bits)),
                final_assignment=''.join(map(str,bits)), best_objective=problem.objective(best_bits),
                target_objective=problem.data['objective']['target'],
                target_reached=None if problem.target_energy is None else best == problem.target_energy,
                best_energy=best, final_energy=current, visits=visits, bit_changes=changes,
                completed_full_sweeps=completed_sweeps, initialization_bit_draws=problem.n,
                sampling_uniform_draws=visits, beta_log=log,
                scope='Reference p-bit sampling; this run does not reproduce the historical solver campaign.')
