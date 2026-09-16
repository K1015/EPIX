"""Compare a completed board run with the independent integer reference."""
import argparse,hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def require(ok,message):
    if not ok:raise RuntimeError(message)
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('run',type=Path)
    parser.add_argument('--reference',type=Path,default=ROOT/'recorded/software')
    parser.add_argument('--output',type=Path)
    args=parser.parse_args();refs={};frames={}
    for line in (args.reference/'reference.csv').read_text().splitlines():
        v=list(map(int,line.split(',')));r={'seed':v[0],'mode':v[1]}
        for k,name in enumerate(['initial_bits','final_bits','best_bits']):r[name]=sum(v[2+9*k+j]<<(32*j) for j in range(9))
        r.update(zip(['final_energy','best_energy','updates','rng_words','reuse','fresh','rng_state','first_hit','cycles'],v[29:]))
        r['cycles']=181251650-33*r['reuse'];r['rng_steps']=32*r['rng_words'];r['sweeps']=1024
        refs[v[0],v[1]]=r
    for line in (args.reference/'trace_reference.csv').read_text().splitlines():
        v=list(map(int,line.split(',')));key=tuple(v[:2]);require(v[2]==len(frames.get(key,[])),'Reference frame order');frames.setdefault(key,[]).append(v[3:])
    trialfile=args.run/'trials.jsonl';rows=[json.loads(line) for line in trialfile.read_text().splitlines()]
    digest=hashlib.sha256(trialfile.read_bytes()).hexdigest();receipt=json.loads((args.run/'COMPLETE.json').read_text())
    require(receipt['status']=='PASS' and receipt['trials_sha256']==digest and receipt['trials']==len(rows),'Completion receipt')
    require(rows and len({(r['seed'],r['mode']) for r in rows})==len(rows),'Nonempty unique trials')
    fields=0
    for row in rows:
        key=row['seed'],row['mode'];require(key in refs and key in frames,'Seed/policy absent from reference')
        for name,value in refs[key].items():require(row[name]==value,'Mismatch: trial {} mode {} {}'.format(row['trial'],row['mode'],name));fields+=1
        require(len(row['trace'])==12 and row['trace']==frames[key],'Trace mismatch');fields+=192
    result={'status':'PASS','trials':len(rows),'frames':12*len(rows),'compared_fields':fields,'trials_sha256':digest,'scope':'Final solver states/counters and every captured frame match software; host duration excluded'}
    if args.output:args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
