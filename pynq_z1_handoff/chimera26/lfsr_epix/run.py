"""Run the chimera26 26-variable solver with one shared LFSR on PYNQ-Z1."""
import argparse
import hashlib
import json
import os
import time
import uuid
from pathlib import Path

P = Path(__file__).resolve().parent

def require(ok, message):
    if not ok:
        raise RuntimeError(message)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

# Energy registers hold signed 32-bit values; MMIO returns unsigned integers.
def signed(value):
    return value - 2**32 if value >= 2**31 else value

def check():
    cfg = json.loads((P / 'config.json').read_text())
    stem = cfg['overlay_stem']
    # Keep the image, metadata and fixed graph together as one matched set.
    expected = {stem + ext for ext in ['.bit', '.hwh', '.tcl']} | {'problem.json'}
    require(set(cfg['files_sha256']) == expected, 'Incomplete deployment configuration')
    for name, digest in cfg['files_sha256'].items():
        require(sha(P / name) == digest, 'Deployment file mismatch: ' + name)
    problem = json.loads((P / 'problem.json').read_text())
    require(cfg['rng'] == 'lfsr' and cfg['default_mode'] in ['iid', 'epix'], 'Invalid configuration')
    require(cfg['clock_mhz'] == 100 and cfg['pbits'] == 26 and cfg['rng_instances'] == 1, 'Wrong hardware configuration')
    require(problem['pbits'] == 26 and problem['auxiliary_variables'] == 0, 'Invalid variable count')
    require(len(problem['trial_seeds']) == 1000 and len(set(problem['trial_seeds'])) == 1000, 'Invalid paired seeds')
    require(len(problem['J']) == 26 and problem['target_energy'] == -80, 'Invalid Ising problem')
    require(all(len(row) == 26 and row[i] == 0 for i, row in enumerate(problem['J'])), 'Invalid coupling matrix')
    require(all(problem['J'][i][j] == problem['J'][j][i] for i in range(26) for j in range(26)), 'Asymmetric couplings')
    return cfg, problem

def load():
    from pynq import Overlay, MMIO, Clocks
    cfg, problem = check()
    overlay = Overlay(str(P / (cfg['overlay_stem'] + '.bit')))
    # AXI base address, design ID and interface version come from this overlay.
    io = MMIO(0x43c00000, 4096)
    require(io.read(0) == 0x43483236 and io.read(4) == 0x30000, 'Wrong shared-LFSR hardware identity')
    require(float(Clocks.fclk0_mhz) == 100, 'Expected 100 MHz clock')
    io.write(8, 4)  # Clear the AXI bus-error flag.
    return cfg, overlay, io

def wait(io):
    start = time.perf_counter()
    while True:
        # Status: bit 0 busy, bit 1 done, bits 2/3 aborted or faulted.
        status = io.read(0x10)
        require(not status & 12, 'Solver fault: status=%d' % status)
        if status == 2:
            return time.perf_counter() - start
        if time.perf_counter() - start > 120:
            io.write(8, 2)
            raise RuntimeError('Trial timed out')
        time.sleep(.001)

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--check', action='store_true', help='Verify deployment files without accessing the FPGA')
    ap.add_argument('--trials', type=int, default=10)
    ap.add_argument('--mode', choices=['iid', 'epix', 'paired'])
    ap.add_argument('--output', type=Path)
    args = ap.parse_args()
    require(1 <= args.trials <= 1000, 'Use 1..1000 trials per mode')
    cfg, problem = check()
    if args.check:
        print('PASS: deployment files and fixed chimera26 problem verified')
        return
    mode = args.mode or cfg['default_mode']
    out = Path(os.path.abspath(str(args.output or P / 'runs' / uuid.uuid4().hex)))
    out.mkdir(parents=True, exist_ok=False)
    files = [P / 'run.py', P / 'config.json', P / 'problem.json']
    files += [P / (cfg['overlay_stem'] + ext) for ext in ['.bit', '.hwh', '.tcl']]
    (out / 'PROVENANCE.json').write_text(json.dumps({
        'architecture': 'one_shared_rng', 'rng': 'lfsr', 'trials_per_mode': args.trials,
        'mode': mode, 'clock_mhz': 100,
        'files_sha256': {f.name: sha(f) for f in files}}, indent=2))
    rows, io = [], None
    try:
        cfg, overlay, io = load()
        with (out / 'trials.jsonl').open('x') as log:
            for trial in range(args.trials):
                # Policy 0 = IID, 1 = EPIX. Alternate order to balance host effects;
                # both policies still start from the same seed within each pair.
                modes = ([0, 1] if trial % 2 == 0 else [1, 0]) if mode == 'paired' else [int(mode == 'epix')]
                for policy in modes:
                    seed = problem['trial_seeds'][trial]
                    io.write(0xc, seed)
                    io.write(0x60, policy)
                    io.write(8, 1)  # Start only after writing the seed and policy.
                    seconds = wait(io)
                    row = {'trial': trial, 'mode': policy, 'seed': seed, 'host_seconds': seconds}
                    for name, offset in [('initial_bits', 0x1c), ('final_bits', 0x20), ('best_bits', 0x24), ('final_energy', 0x28), ('best_energy', 0x2c), ('best_cut', 0x30), ('updates', 0x34), ('rng_words', 0x38), ('rng_steps', 0x3c), ('cycles', 0x40), ('first_hit', 0x44), ('rng_state', 0x48), ('sweeps', 0x4c), ('reuse', 0x68), ('fresh', 0x6c)]:
                        row[name] = io.read(offset)
                    for name in ['final_energy', 'best_energy']:
                        row[name] = signed(row[name])
                    require(row['updates'] == 26624 and row['sweeps'] == 1024 and row['fresh'] + row['reuse'] == 26624 and row['rng_words'] == 26 + row['fresh'], 'Update counts')
                    if policy == 0:
                        require(row['rng_words'] == 26650 and row['reuse'] == 0, 'IID counts')
                    for state, energy in [('final_bits', 'final_energy'), ('best_bits', 'best_energy')]:
                        bits = row[state]
                        score = -sum(problem['J'][i][j] * (1 if ((bits >> i) & 1) == ((bits >> j) & 1) else -1) for i in range(26) for j in range(i+1,26))
                        require(row[energy] == score, 'Independent Ising score')
                    require(row['best_energy'] >= -80, 'Energy below certified optimum')
                    require(row['rng_steps'] == 32 * row['rng_words'] and row['cycles'] == 2398398 - 33 * row['reuse'], 'LFSR steps/cycles')
                    row['success'] = row['best_energy'] == -80
                    from pynq import Clocks
                    require(float(Clocks.fclk0_mhz) == 100, 'Clock changed')
                    # Core timing uses the 100 MHz counter; host timing includes polling.
                    row['core_seconds'] = row['cycles'] * 1e-8
                    rows.append(row)
                    log.write(json.dumps(row) + '\n')
                    log.flush()
                if trial % 10 == 0:
                    print('Completed', trial + 1, '/', args.trials, flush=True)
        summary = {}
        for policy in sorted(set(r['mode'] for r in rows)):
            group = [r for r in rows if r['mode'] == policy]
            result = {'trials': len(group), 'successes': sum(r['success'] for r in group)}
            for key in ['rng_words', 'rng_steps', 'core_seconds', 'host_seconds', 'reuse', 'updates']:
                result['mean_' + key] = sum(r[key] for r in group) / len(group)
            result['total_core_seconds'] = sum(r['core_seconds'] for r in group)
            result['total_host_seconds'] = sum(r['host_seconds'] for r in group)
            summary['EPIX' if policy else 'IID'] = result
        (out / 'SUMMARY.json').write_text(json.dumps(summary, indent=2))
        (out / 'COMPLETE.json').write_text(json.dumps({'status': 'PASS', 'scope': 'Independent solver scores and hardware counters.', 'trials': len(rows), 'trials_sha256': sha(out / 'trials.jsonl')}, indent=2))
        print(json.dumps(summary, indent=2))
    except BaseException as error:
        (out / 'FAILED.json').write_text(json.dumps({'error': repr(error)}, indent=2))
        raise
    finally:
        if io is not None:
            io.write(8, 2)  # Leave the solver idle after success or an interrupted run.

if __name__ == '__main__':
    main()
