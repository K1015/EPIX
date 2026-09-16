"""Run the 288-variable DATE2027 demo in IID, EPIX or paired mode (Python 3.6)."""
import argparse,fcntl,hashlib,json,os,platform,subprocess,time,uuid
from pathlib import Path

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def require(ok,msg):
 if not ok:raise RuntimeError(msg)
def signed(v):return v-2**32 if v>=2**31 else v
def save(p,d):p.write_text(json.dumps(d,indent=2)+'\n')
def main():
 ap=argparse.ArgumentParser(description=__doc__)
 ap.add_argument('--check',action='store_true',help='Verify the deployment without PYNQ or programming hardware')
 ap.add_argument('--mode',choices=['iid','epix','paired'])
 ap.add_argument('--trials',type=int,default=1,help='Number of seeds per policy (1 to 100)')
 ap.add_argument('--output',type=Path)
 a=ap.parse_args();p=Path(__file__).resolve().parent
 require(1<=a.trials<=100,'Trial count must be between 1 and 100')
 out=Path(os.path.abspath(str(a.output or p/'runs'/str(uuid.uuid4()))))
 cfg=json.loads((p/'config.json').read_text());problem=json.loads((p/'problem.json').read_text());native='clauses' in problem
 require(cfg['pbits']==problem['pbits']==288 and problem['auxiliary_variables']==0,'288 logical variables required')
 require(cfg['rng_instances']==1 and cfg['clock_mhz']==100,'Shared source and frequency')
 stem=cfg['overlay_stem'];require(set(cfg['files_sha256'])=={stem+ext for ext in ['.bit','.hwh','.tcl']}|{'problem.json'},'Incomplete deployment')
 for name,digest in cfg['files_sha256'].items():require(sha(p/name)==digest,'Hash mismatch: '+name)
 require(len(problem['trial_seeds'])==100 and len(set(problem['trial_seeds']))==100,'Unique seed list')
 require(problem['family']=='text288' and problem['target_energy']==-540,'Fixed DATE2027 instance')
 selected=a.mode or cfg['default_mode'];modes=[0,1] if selected=='paired' else [int(selected=='epix')]
 if a.check:
  print(json.dumps({'status':'PASS','mode':selected,'pbits':288,'files':sorted(cfg['files_sha256'])}));return
 lock=open('/tmp/date2027-pynq-board.lock','a');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 out.mkdir(parents=True,exist_ok=False)
 import pynq
 from pynq import Overlay,MMIO,Clocks
 identity={'machine':platform.machine(),'python':platform.python_version(),'pynq':getattr(pynq,'__version__',None),'board_environment':os.environ.get('BOARD'),'board_wall_time_untrusted':time.time()}
 save(out/'IDENTITY.json',identity)
 save(out/'PROVENANCE.json',{'case':problem['family'],'trials_per_policy':a.trials,'mode':selected,'config':cfg,'runner_sha256':sha(Path(__file__)),'paired_seeds_sha256':hashlib.sha256(json.dumps(problem['trial_seeds']).encode()).hexdigest()})
 # Keep the shared lock across programming and all trials.
 rows=[];io=None
 try:
  overlay=Overlay(str(p/(stem+'.bit')));io=MMIO(0x43c00000,4096)
  expected=0x53413236 if problem['family']=='sat288' else 0x584f3236 if native else 0x4d433236
  require(io.read(0)==expected and io.read(4)==0x60000 and io.read(0x14)==288,'Hardware ABI/size identity')
  require(float(Clocks.fclk0_mhz)==100,'Clock mismatch');io.write(8,4)
  with (out/'trials.jsonl').open('x') as log:
   for trial in range(a.trials):
    for mode in (modes if trial%2==0 else list(reversed(modes))):
     seed=problem['trial_seeds'][trial];io.write(0xc,seed);io.write(0x60,mode);io.write(8,1);start=time.perf_counter()
     while True:
      status=io.read(0x10);require(not status&12,'Hardware fault')
      if status==2:break
      require(time.perf_counter()-start<120,'Hardware timeout');time.sleep(.001)
     r={'trial':trial,'seed':seed,'mode':mode,'host_seconds':time.perf_counter()-start}
     for name,offset in [('final_energy',0x28),('best_energy',0x2c),('best_cut',0x30),('updates',0x34),('rng_words',0x38),('rng_steps',0x3c),('cycles',0x40),('first_hit',0x44),('rng_state',0x48),('sweeps',0x4c),('reuse',0x68),('fresh',0x6c),('refills',0x70),('initial_draws',0x74)]:r[name]=io.read(offset)
     for name,base in [('initial_bits',0x100),('final_bits',0x140),('best_bits',0x180)]:r[name]=sum(io.read(base+4*k)<<(32*k) for k in range(9))
     trace_status=io.read(0x200)
     while trace_status&32:
      require(time.perf_counter()-start<120,'Trace timeout');trace_status=io.read(0x200)
     require(trace_status==12,'Trace count/overflow')
     r['trace']=[[io.read(0x400+64*f+4*k) for k in range(16)] for f in range(12)]
     for name in ['final_energy','best_energy']:r[name]=signed(r[name])
     require(r['rng_steps']==32*r['rng_words'],'32 serial steps per source word');require(r['fresh']+r['reuse']==r['updates'],'Policy accounting')
     require(mode or (r['reuse']==0 and r['fresh']==r['updates']),'IID accounting')
     if native:
      require(r['updates']<=294912 and r['initial_draws']==288 and r['rng_words']==288+r['fresh']+r['refills'],'Native counters')
      unsat=sum(not any(((r['final_bits']>>(abs(v)-1))&1)==(v>0) for v in c) for c in problem['clauses']);require(r['final_energy']==unsat,'CNF rescore');require(unsat==0 or r['updates']==294912,'Native stop budget');r['success']=unsat==0
      if problem['family']=='xorsat288':
       x=json.loads((p/'input_xor.json').read_text());violated=sum((sum((r['final_bits']>>i)&1 for i in c)%2)!=b for c,b in zip(x['clauses'],x['parity']));require(violated==unsat,'Native XOR rescore');r['native_violations']=violated
     else:
      require(r['updates']==294912 and r['sweeps']==1024 and r['rng_words']==288+r['fresh'],'Graph counters')
      for bits,en in [('final_bits','final_energy'),('best_bits','best_energy')]:
       cut=sum(w for i,j,w in problem['edges'] if ((r[bits]>>i)^(r[bits]>>j))&1);require(r[en]==problem['total_edge_weight']-2*cut,'Graph rescore')
      require(r['best_cut']==(problem['total_edge_weight']-r['best_energy'])//2,'Cut register')
      require(r['cycles']==181251650-33*r['reuse'],'Graph cycle accounting');r['success']=r['best_energy']==problem['target_energy']
     require(float(Clocks.fclk0_mhz)==100,'Clock changed');r['core_seconds']=r['cycles']/100000000.;rows.append(r);log.write(json.dumps(r)+'\n');log.flush()
    if trial%25==0:print(problem['family'],trial+1,'/',a.trials,flush=True)
  summary={}
  for mode in modes:
   group=[r for r in rows if r['mode']==mode];result={'trials':len(group),'successes':sum(r['success'] for r in group)}
   for key in ['updates','rng_words','rng_steps','cycles','core_seconds','host_seconds','reuse','fresh','best_energy']:result['mean_'+key]=sum(r[key] for r in group)/len(group)
   summary['EPIX' if mode else 'IID']=result
  save(out/'SUMMARY.json',summary);save(out/'COMPLETE.json',{'status':'PASS','scope':'Physical board execution, direct objective rescoring and counter validation; target attainment reported separately','trials':len(rows),'trials_sha256':sha(out/'trials.jsonl')});print(json.dumps(summary),flush=True)
 except BaseException as e:save(out/'FAILED.json',{'error':repr(e)});raise
 finally:
  if io is not None:io.write(8,2)
if __name__=='__main__':main()
