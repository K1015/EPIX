"""Build and run the integer software reference without FPGA access."""
import argparse, hashlib, json, shutil, subprocess
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
def digest(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--trials', type=int, default=100)
    ap.add_argument('--output', required=True, type=Path)
    a = ap.parse_args()
    if not 1 <= a.trials <= 100: ap.error('--trials must be between 1 and 100')
    compiler = shutil.which('c++')
    if compiler is None: ap.error('Install a C++14 compiler (c++)')
    out = a.output.resolve(); out.mkdir(parents=True, exist_ok=False)
    seeds = json.loads((ROOT/'lfsr_iid/problem.json').read_text())['trial_seeds'][:a.trials]
    (out/'seeds.hex').write_text(''.join('{:08x}\n'.format(s) for s in seeds))
    subprocess.check_call([compiler, '-O2', '-std=c++14', str(ROOT/'software/software.cpp'), '-o', str(out/'reference')])
    with (out/'reference.csv').open('w') as f:
        subprocess.check_call([str(out/'reference'), str(out/'seeds.hex'), str(out/'trace_reference.csv')], cwd=str(ROOT/'lfsr_iid/vivado/ip_repo/maxcut26/src'), stdout=f)
    for name, count in [('reference.csv', 2*a.trials), ('trace_reference.csv', 24*a.trials)]:
        actual=(out/name).read_text().splitlines()
        expected=(ROOT/'recorded/software'/name).read_text().splitlines()[:count]
        if actual != expected: raise RuntimeError('Software mismatch: '+name)
    result={'status':'PASS','trials':2*a.trials,'frames':24*a.trials,'scope':'Fresh C++ software matches the recorded reference exactly; no FPGA access','files_sha256':{n:digest(out/n) for n in ('reference.csv','trace_reference.csv')}}
    (out/'VALIDATION.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__ == '__main__': main()
