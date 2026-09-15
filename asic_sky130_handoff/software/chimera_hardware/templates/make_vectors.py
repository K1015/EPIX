#!/usr/bin/env python3
"""Reproducible full-budget reference vectors and native operation audit."""
import hashlib
import json
from pathlib import Path
import struct
import time
from reference import ROOT, NATIVE, GROUPS, run, validate_native
FIELDS=['success','final_success','sweeps','best_cut','final_cut','first_exact_sweep','local_words','visits','fired_cycles']
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def packed(state): return [sum(int(state[32*k+j])<<j for j in range(32)) for k in range(4)]
def write(out, values):
    out.write(struct.pack('<'+'I'*len(values), *(int(v)&0xffffffff for v in values)))
def search_cycles(record):
    # Banks work concurrently; a color waits for the busiest bank, then scores.
    cycles=2  # Initial score and completion.
    for index,(refresh,_,_) in enumerate(record['policy_events']):
        counts=[0]*(len(record['seeds'])//32)
        for node in GROUPS[index%2][refresh]:
            counts[int(node)//32]+=1
        cycles+=max(1,max(counts))+1
    return cycles
def sources():
    names=['reference.py','make_vectors.py','graph.json','software_spec.json','certificate.json']
    names += [str(path.relative_to(ROOT)) if path.is_relative_to(ROOT) else '../../software/chimera_native/'+path.name for path in sorted(NATIVE.glob('*.py'))]
    return {name:sha(ROOT/name) for name in names}
def prepare(directory,trials,modes):
    directory=Path(directory);directory.mkdir(parents=True,exist_ok=True)
    for mode in modes:
        start=time.monotonic();outcomes=[];native_checks=[]
        receipt=directory/(mode+'.json')
        receipt.write_text(json.dumps(dict(passed=False,stage='started',mode=mode,trials=trials))+'\n')
        source_hashes=sources()
        with (directory/(mode+'.bin')).open('wb') as out:
            write(out,[trials])
            for trial in range(trials):
                record=run(trial,mode)
                audit=validate_native(record)
                record['result']['rng32_search_cycles']=search_cycles(record)
                native_checks.append(audit);outcomes.append(record['result'])
                write(out,[trial]);write(out,record['seeds']);write(out,packed(record['initial']))
                write(out,[record['result'][key] for key in FIELDS]);write(out,packed(record['final']));write(out,packed(record['witness']))
                write(out,[len(record['events'])])
                for kind,state,current,best,words,visits,fired,first in record['events']:
                    write(out,[kind+1,*packed(state),current,best,words,visits,fired,first])
                print(f'NATIVE_PASS {mode} trial={trial} color_states={audit["compared_color_states"]} words={record["result"]["local_words"]}',flush=True)
        assert sources()==source_hashes
        receipt.write_text(json.dumps(dict(schema_version=1,passed=True,mode=mode,trials=trials,sha256=sha(directory/(mode+'.bin')),sources=source_hashes,outcomes=outcomes,native_checks=native_checks,
            elapsed_seconds=time.monotonic()-start,energy_measurement=False,
            rng_scope='Physical per-lane 32-step XNOR recurrence; native semantics checked using identical injected raw words, not the original NumPy RNG trajectory.'),indent=2)+'\n')
