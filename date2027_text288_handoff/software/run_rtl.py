"""Recreate the full first-seed AXI simulation with Verilator and a C++ compiler."""
import argparse,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    rtl=ROOT/'lfsr_iid/vivado/ip_repo/maxcut26/src';obj=out/'obj'
    seed=json.loads((ROOT/'lfsr_iid/problem.json').read_text())['trial_seeds'][0]
    with (out/'build.log').open('w') as log:
        subprocess.check_call(['verilator','--cc','--exe','-Wno-fatal','--top-module','maxcut26_axi','--Mdir',str(obj)]+[str(f) for f in sorted(rtl.glob('*.sv'))]+[str(ROOT/'software/axi_sim.cpp')],stdout=log,stderr=subprocess.STDOUT)
        subprocess.check_call(['make','-C',str(obj),'-f','Vmaxcut26_axi.mk','-j4'],stdout=log,stderr=subprocess.STDOUT)
    expected={}
    for line in (ROOT/'recorded/software/trace_reference.csv').read_text().splitlines():
        v=list(map(int,line.split(',')));expected[tuple(v[:3])]=v[3:]
    records=[]
    for mode in (0,1):
        result=subprocess.run([str(obj/'Vmaxcut26_axi'),str(seed),str(mode)],cwd=str(rtl),universal_newlines=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
        lines=result.stdout.splitlines()
        if len(lines)!=12:raise RuntimeError('Expected 12 frames')
        for index,line in enumerate(lines):
            values=list(map(int,line.split(',')))
            if values[0]!=index or values[1:]!=expected[seed,mode,index]:raise RuntimeError('AXI frame mismatch')
        (out/('rtl_trace_'+str(mode)+'.csv')).write_text(result.stdout)
        records.append({'seed':seed,'mode':mode,'result':result.stderr.strip()})
        print(records[-1],flush=True)
    (out/'SIMULATION.json').write_text(json.dumps({'status':'PASS','scope':'Fresh AXI simulation; all frame words match the software reference','trials':records},indent=2)+'\n')
if __name__=='__main__':main()
