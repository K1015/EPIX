#!/usr/bin/env python3
"""Generate complete dimensioned APT/ICM RTL from frozen, certified inputs."""
import argparse
import json
from input_adapter import load_selected, SHARED_ROOT
from reference_adapter import load_private_kernel
from graph_rtl_adapter import generate_functions
from solver_rtl_adapter import generate_solver
from banked_rng import bank_solver

ROOT=SHARED_ROOT.parents[1]

def hardware_adapter(case, nodes, replicas):
    adapter=json.loads((case/'asic.json').read_text())
    for mode in ('baseline','epix'):
        adapter['modes'][mode]['expected_icg_count']=4*replicas
    adapter['simulation']=dict(driver='sim_main.cpp',prefix='Vcorrected_solver',
        compare_fields=['trial','success','sweeps','local_words','swap_words','icm_words','visits','events'],
        fresh_word_fields=['local_words','swap_words','icm_words'],
        setup_rng_words=nodes+2+nodes*replicas//32,
        boundary=f'{nodes//32} local RNG engines serve {nodes} independent node streams in contiguous 32-node banks; {replicas} replica states, unchanged swaps and clusters, ideal root clock and no routed interconnect.')
    adapter['rng_audit']=dict(nets=[dict(name=f'rng_bank[{b}].state',width=1024)
        for b in range(nodes//32)],expected_registers=32*nodes)
    adapter['rng_sharing']=dict(stored_variables=nodes,variables_per_engine=32,
        local_engines=nodes//32,stream_states=nodes,auxiliary_engines=2,
        words_per_engine_per_cycle=1,mapping='contiguous groups of 32 variables',kind='banked')
    return json.dumps(adapter,indent=2)+'\n'

def hardware_metadata(case, nodes, replicas):
    meta=json.loads((case/'metadata.json').read_text())
    meta.update(hardware_rng_lanes=nodes//32,local_rng_computation_engines=nodes//32,
        local_rng_state_words=nodes,nodes_per_rng_engine=32,physical_clock_gates_per_mode=4*replicas)
    return json.dumps(meta,indent=2)+'\n'

def generate128(check=False):
    case=ROOT/'cases/maxcut128'
    files={f'rtl/{mode}/solver.sv':bank_solver((SHARED_ROOT/f'solver128_{mode}_template.sv').read_text(),128)
           for mode in ('baseline','epix')}
    files['asic.json']=hardware_adapter(case,128,24)
    files['metadata.json']=hardware_metadata(case,128,24)
    for name,value in files.items():
        if check:
            if (case/name).read_text()!=value:raise ValueError('Generated artifact differs: '+str(case/name))
        else:(case/name).write_text(value)
    print(f'maxcut128: {"verified" if check else "generated"} {len(files)} files',flush=True)

def generate(size,check=False):
    if size==128:return generate128(check)
    item=load_selected(size);case=ROOT/'cases'/f'maxcut{size}'
    text,cfg,widths,_=generate_solver(item,(SHARED_ROOT/'solver_template.sv').read_text())
    functions=generate_functions(item,load_private_kernel())
    fields='function automatic integer metadata_field_width(input integer node);\nbegin case(node)\n'
    fields+=''.join(f'{i}: metadata_field_width={w};\n' for i,w in enumerate(widths))
    fields+='default: metadata_field_width=5;\nendcase end\nendfunction\n'
    dimensions='#pragma once\n'+''.join(f'#define {k} {v}\n' for k,v in {
        'MAXCUT_N':size,'MAXCUT_REPLICAS':cfg['replicas']['total'],
        'MAXCUT_SWEEPS':cfg['maximum_sweeps'],'MAXCUT_SCORE_BITS':cfg['widths']['score']}.items())
    files={'dimensions.hpp':dimensions,
           'inputs/graph.json':json.dumps(item.graph.record(),indent=2)+'\n',
           'asic.json':hardware_adapter(case,size,cfg['replicas']['total']),
           'metadata.json':hardware_metadata(case,size,cfg['replicas']['total'])}
    for mode in ('baseline','epix'):
        for name,value in {'solver.sv':text,'graph_functions.svh':functions,
                          'metadata_widths.svh':fields,'clock_gate_sim.sv':(SHARED_ROOT/'clock_gate_sim.sv').read_text()}.items():
            files['rtl/'+mode+'/'+name]=value
    for name,value in files.items():
        path=case/name
        if check:
            if path.read_text()!=value:raise ValueError('Generated artifact differs: '+str(path))
        else:
            path.parent.mkdir(parents=True,exist_ok=True);path.write_text(value)
    print(f'{case.name}: {"verified" if check else "generated"} {len(files)} files',flush=True)
if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sizes',type=int,nargs='+',choices=(32,128,288,512,800),default=[32,128,288,512,800])
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args()
    for n in args.sizes:generate(n,args.check)
