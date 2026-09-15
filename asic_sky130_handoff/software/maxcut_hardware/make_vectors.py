#!/usr/bin/env python3
"""Stream all native APT/ICM state events into portable reference vectors."""
import hashlib
import json
from pathlib import Path
import shutil
import struct
import tempfile
import time
import numpy as np
from input_adapter import SHARED_ROOT, load_selected, seed_words
from reference_adapter import ReferenceRunner

FINAL=('exact_hit','best_cut','sweeps_executed','local_fresh_rng_words',
       'swap_rng_words','icm_rng_words','total_replica_node_updates')
KINDS={'initialization':1,'color':2,'icm':3,'exchange':4}
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def packed(state):
    return np.packbits(np.asarray(state,dtype=np.uint8).reshape(-1,32),axis=1,bitorder='little').tobytes()
def sources(case):
    import os
    paths=[*SHARED_ROOT.glob('*.py'),SHARED_ROOT/'vendor/apt_icm.py',
           *sorted((case/'inputs').glob('*.json'))]
    return {os.path.relpath(p,case):sha(p) for p in paths}
def prepare(case,output,trials=1,modes=('baseline','epix'),budget=None):
    case=Path(case).resolve();size=int(case.name.removeprefix('maxcut'))
    output=Path(output).resolve();output.mkdir(parents=True,exist_ok=True)
    runner=ReferenceRunner(size);cfg=runner.config;digests=sources(case)
    limit=cfg['maximum_sweeps'] if budget is None else budget
    for mode in modes:
        start=time.monotonic();path=output/(mode+'.bin');receipt=output/(mode+'.json')
        receipt.write_text(json.dumps(dict(passed=False,stage='started'))+'\n')
        outcomes=[]
        with path.with_suffix('.partial').open('wb') as out:
            def emit(values):out.write(struct.pack('<'+'I'*len(values),*[int(v)&0xffffffff for v in values]))
            emit([trials])
            for trial in range(trials):
                count=0;initial=final=None
                with tempfile.TemporaryFile() as events:
                    def observe(event,bank):
                        nonlocal count,initial,final
                        data=packed(bank.state)
                        if initial is None:initial=data
                        final=data;count+=1
                        events.write(struct.pack('<I',KINDS[event['kind']])+data)
                    row=runner.run(trial,mode,observer=observe,diagnostic_budget=budget)
                    assert initial is not None and len(initial)==size*cfg['replicas']['total']//8
                    seeds=[int(v) for stream in (2,3,4) for v in seed_words(size,row['seed'],stream)]
                    emit([trial,*seeds]);out.write(initial);emit([row[key] for key in FINAL]);out.write(final);emit([count])
                    events.seek(0);shutil.copyfileobj(events,out)
                    outcomes.append(dict(trial=trial,seed=row['seed'],events=count,
                        initial_state_sha256=hashlib.sha256(initial).hexdigest(),
                        final_state_sha256=hashlib.sha256(final).hexdigest(),
                        **{key:row[key] for key in FINAL},reuse_audit=row['reuse_audit'],
                        full_software_budget=budget is None,canonical_maximum_sweeps=cfg['maximum_sweeps']))
                    print(f'NATIVE_PASS {case.name} {mode} trial={trial} events={count} sweeps={row["sweeps_executed"]}',flush=True)
        assert digests==sources(case),'Sources changed during native reference run'
        path.with_suffix('.partial').replace(path)
        result=dict(schema_version=1,passed=True,case=case.name,mode=mode,trials=trials,
            sha256=sha(path),sources=digests,outcomes=outcomes,sweep_limit=limit,
            dimensions=dict(n=size,replicas=cfg['replicas']['total'],state_words=size*cfg['replicas']['total']//32),
            input_verification=runner.prepared.verification,
            checks='Every complete replica-bank state after initialization, each color update, accepted ICM move and exchange; native counters and reuse equivalence',
            historical_numpy_rng_equivalence=False,energy_measurement=False,elapsed_seconds=time.monotonic()-start)
        receipt.write_text(json.dumps(result,indent=2)+'\n')
