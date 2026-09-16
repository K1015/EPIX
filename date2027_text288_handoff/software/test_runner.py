"""Exercise policy selection and register reads against recorded data; no hardware access."""
import importlib.util,json,subprocess,sys,tempfile,types
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
ROWS=[json.loads(l) for l in (ROOT/'recorded/board/text288_100/trials.jsonl').read_text().splitlines()]
BY_KEY={(r['seed'],r['mode']):r for r in ROWS}
OFFSETS={0x28:'final_energy',0x2c:'best_energy',0x30:'best_cut',0x34:'updates',0x38:'rng_words',0x3c:'rng_steps',0x40:'cycles',0x44:'first_hit',0x48:'rng_state',0x4c:'sweeps',0x68:'reuse',0x6c:'fresh',0x70:'refills',0x74:'initial_draws'}
class MMIO:
    fault=False
    last=None
    def __init__(self,base,size):
        assert (base,size)==(0x43c00000,4096)
        self.seed=None;self.mode=None;self.row=None;self.aborted=False;MMIO.last=self
    def write(self,offset,value):
        if offset==0xc:self.seed=value
        elif offset==0x60:self.mode=value
        elif offset==8 and value==1:self.row=BY_KEY[self.seed,self.mode]
        elif offset==8 and value==2:self.aborted=True
    def read(self,offset):
        fixed={0:0x4d433236,4:0x60000,0x14:288,0x10:4 if self.fault else 2,0x200:12}
        if offset in fixed:return fixed[offset]
        if offset in OFFSETS:return self.row[OFFSETS[offset]]&0xffffffff
        for base,name in [(0x100,'initial_bits'),(0x140,'final_bits'),(0x180,'best_bits')]:
            if base<=offset<base+36:return (self.row[name]>>(8*(offset-base)))&0xffffffff
        if 0x400<=offset<0x700:return self.row['trace'][(offset-0x400)//64][(offset%64)//4]
        raise ValueError(offset)
def load(policy):
    spec=importlib.util.spec_from_file_location('runner',str(policy/'run.py'));module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module

def main():
    fake=types.ModuleType('pynq');fake.__version__='record-replay-test';fake.MMIO=MMIO;fake.Clocks=types.SimpleNamespace(fclk0_mhz=100)
    fake.Overlay=lambda p:None;sys.modules['pynq']=fake
    cases=0
    with tempfile.TemporaryDirectory() as temp:
        temp=Path(temp)
        for default in ('iid','epix'):
            policy=ROOT/('lfsr_'+default);runner=load(policy)
            for mode in (None,'iid','epix','paired'):
                out=temp/(default+'_'+str(mode));sys.argv=['run.py','--trials','2','--output',str(out)]
                if mode:sys.argv+=['--mode',mode]
                runner.main();actual=[json.loads(l) for l in (out/'trials.jsonl').read_text().splitlines()]
                selected=mode or default;modes={0,1} if selected=='paired' else {int(selected=='epix')}
                assert len(actual)==2*len(modes) and {r['mode'] for r in actual}==modes
                for row in actual:
                    expected=BY_KEY[row['seed'],row['mode']]
                    for key,value in expected.items():
                        if key!='host_seconds':assert row[key]==value,(key,row[key],value)
                assert MMIO.last.aborted
                cases+=1
            for count in ('0','101'):
                result=subprocess.run([sys.executable,str(policy/'run.py'),'--check','--trials',count],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                assert result.returncode!=0 and b'Trial count must be between 1 and 100' in result.stderr
        # Exercise failure receipt and cleanup on a hardware fault response.
        MMIO.fault=True;out=temp/'fault';sys.argv=['run.py','--trials','1','--output',str(out)]
        try:runner.main();raise AssertionError('Fault was accepted')
        except RuntimeError as error:assert str(error)=='Hardware fault'
        assert (out/'FAILED.json').exists() and not (out/'COMPLETE.json').exists() and MMIO.last.aborted
        MMIO.fault=False
        # A corrupt deployment must fail before importing PYNQ.
        damaged=temp/'damaged';damaged.mkdir();policy=ROOT/'lfsr_iid'
        (damaged/'run.py').write_bytes((policy/'run.py').read_bytes())
        cfg=json.loads((policy/'config.json').read_text());cfg['files_sha256']['problem.json']='0'*64
        (damaged/'config.json').write_text(json.dumps(cfg))
        for name in cfg['files_sha256']:(damaged/name).symlink_to(policy/name)
        result=subprocess.run([sys.executable,str(damaged/'run.py'),'--check'],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        assert result.returncode!=0 and b'Hash mismatch: problem.json' in result.stderr
    print(json.dumps({'status':'PASS','policy_selection_cases':cases,'fault_cleanup':True,'hash_rejection':True,'trial_boundaries':True,'scope':'Recorded register replay only; no hardware was programmed'}))
if __name__=='__main__':main()
