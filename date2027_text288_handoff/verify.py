"""Verify the public package, recorded FPGA results and independent references offline."""
import argparse, hashlib, json, subprocess, sys, tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def require(ok,message):
    if not ok: raise RuntimeError(message)
def state(words): return sum(v<<(32*k) for k,v in enumerate(words))
def signed(v): return v-2**32 if v>=2**31 else v
def verify():
    problem=json.loads((ROOT/'lfsr_iid/problem.json').read_text()); edges=problem['edges']
    target=sum(b<<i for i,b in enumerate(problem['target_bits'])); mask=(1<<288)-1
    require(problem['pbits']==288 and len(edges)==540,'Problem size')
    require(len(set(problem['trial_seeds']))==100,'Unique seeds')
    require(all(w==-((2*problem['target_bits'][i]-1)*(2*problem['target_bits'][j]-1)) for i,j,w in edges),'Planted couplings')
    seen={0}
    while True:
        new=seen|{j for i,j,w in edges if i in seen}|{i for i,j,w in edges if j in seen}
        if new==seen:break
        seen=new
    require(len(seen)==288,'Connected graph: exactly two optimum states')
    def energy(bits):return problem['total_edge_weight']-2*sum(w for i,j,w in edges if ((bits>>i)^(bits>>j))&1)
    require(energy(target)==-540 and (problem['total_edge_weight']+540)//2==167,'Target proof')
    refs={}; frames={}
    for line in (ROOT/'recorded/software/reference.csv').read_text().splitlines():
        v=list(map(int,line.split(',')));r=dict(seed=v[0],mode=v[1])
        for k,name in enumerate(['initial_bits','final_bits','best_bits']):r[name]=state(v[2+9*k:11+9*k])
        r.update(zip(['final_energy','best_energy','updates','rng_words','reuse','fresh','rng_state','first_hit','cycles'],v[29:]))
        r['cycles']=181251650-33*r['reuse'];r['rng_steps']=32*r['rng_words'];r['sweeps']=1024
        for b,e in [('final_bits','final_energy'),('best_bits','best_energy')]:require(energy(r[b])==r[e],'Software rescore')
        require((r['best_bits'] in (target,target^mask))==(r['best_energy']==-540),'Optimum bitmap equivalence')
        refs[v[0],v[1]]=r
    require(len(refs)==200,'Software trial count')
    for line in (ROOT/'recorded/software/trace_reference.csv').read_text().splitlines():
        v=list(map(int,line.split(',')));key=tuple(v[:2]);f=v[3:]
        require(v[2]==len(frames.get(key,[])),'Frame order')
        frames.setdefault(key,[]).append(f)
        require(len(f)==16 and energy(state(f[:9]))==signed(f[9]),'Frame energy')
        require(f[12]==288*problem['trace_sweeps'][v[2]],'Sweep metadata')
        require(f[14]+f[15]==f[12] and f[11]==288+f[15],'Frame source accounting')
        require(f[10]==175682+614*f[12]-33*f[14],'Frame cycle accounting')
    require(len(frames)==200 and all(len(f)==12 for f in frames.values()),'Software frame count')
    for run,count in [('text288_100',200),('text288_smoke',6)]:
        folder=ROOT/'recorded/board'/run;trialfile=folder/'trials.jsonl'
        rows=[json.loads(line) for line in trialfile.read_text().splitlines()]
        require(len(rows)==count and len({(r['seed'],r['mode']) for r in rows})==count,'Board count')
        require(json.loads((folder/'COMPLETE.json').read_text())['trials_sha256']==sha(trialfile),'Board receipt hash')
        for row in rows:
            key=row['seed'],row['mode'];require(row['trace']==frames[key],'All 16 words of every FPGA frame')
            for name,value in refs[key].items():require(row[name]==value,'Board/reference '+name)
            require(row['success']==(row['best_energy']==-540),'Success flag')
        summary=json.loads((folder/'SUMMARY.json').read_text())
        for mode,label in [(0,'IID'),(1,'EPIX')]:
            group=[r for r in rows if r['mode']==mode]
            require(summary[label]['trials']==len(group) and summary[label]['successes']==sum(r['success'] for r in group),'Summary counts')
            for name,value in summary[label].items():
                if name.startswith('mean_'):require(abs(value-sum(r[name[5:]] for r in group)/len(group))<1e-8,'Summary '+name)
    build=json.loads((ROOT/'recorded/build/BUILD_AUDIT.json').read_text())
    for mode in ('iid','epix'):
        policy=ROOT/('lfsr_'+mode);cfg=json.loads((policy/'config.json').read_text())
        require(cfg['default_mode']==mode,'Default policy')
        subprocess.check_call([sys.executable,str(policy/'run.py'),'--check'])
        for name,digest in build['packaged_source_hashes'].items():require(sha(policy/'vivado/ip_repo/maxcut26/src'/name)==digest,'RTL provenance '+name)
        for name,digest in cfg['files_sha256'].items():
            if name.endswith(('.bit','.hwh','.tcl')):require(digest==build['overlay_hashes'][name],'Overlay provenance '+name)
        notebook=json.loads((policy/'Demo.ipynb').read_text())
        for cell in notebook['cells']:
            if cell['cell_type']=='code':
                require(cell['execution_count'] is None and cell['outputs']==[],'Clean notebook')
                compile(''.join(cell['source']),'Demo.ipynb','exec')
    with tempfile.TemporaryDirectory() as temp:
        output=Path(temp)/'generated'
        subprocess.check_call([sys.executable,str(ROOT/'hex_generation/generate.py'),'--output',str(output)])
        for p in output.glob('*.hex'):require(sha(p)==sha(ROOT/'lfsr_iid/vivado/ip_repo/maxcut26/src'/p.name),'Regenerated ROM '+p.name)
    return {'status':'PASS','recorded_board_trials':206,'recorded_board_frames':2472,'software_trials':200,'software_frames':2400,'scope':'Offline package checks, exact recorded board/reference comparison, direct rescoring, ROM regeneration and notebook syntax; no new FPGA run or Vivado build'}
if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--output',type=Path);a=ap.parse_args();result=verify()
    if a.output:a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
