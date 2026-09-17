#!/usr/bin/env python3
"""Validate all bundled data and the shared reference without external packages."""
import argparse
from collections import Counter
from itertools import product
import hashlib
import json
import math
from pathlib import Path
import platform
import random
import struct
import time

from solvers.model import Problem, problem_signature, require
from solvers.pbit import solve, probability_one
from solvers.catalog import discover_instances

ROOT = Path(__file__).resolve().parent
PREFIX = {'kings':'kings_maxcut','chimera':'chimera_maxcut','sat':'3hypergraph_sat','xor':'3hypergraph_xorsat'}
GROUP_COUNTS = {32:25,128:25,288:25,512:25,800:25,1024:1}


def read(path):
    return json.loads(path.read_text())


def independent_objective(d,bits):
    """Direct scorer, independent of the reference model and its adjacency rows."""
    if d['problem_type']=='signed_weighted_maxcut':
        return sum(edge[2] for edge in d['edges'] if bits[edge[0]] ^ bits[edge[1]])
    violations=0
    for c in d['constraints']:
        if d['problem_type']=='3sat':
            truths=[bits[v] if sign==1 else 1-bits[v] for v,sign in zip(c['variables'],c['signs'])]
            violations += int(sum(truths)==0)
        else:
            a,b,cnode=c['variables']
            violations += int((bits[a]^bits[b]^bits[cnode]) != c['parity'])
    return violations


def independent_energy(d,bits):
    score=independent_objective(d,bits)
    return -score if d['problem_type']=='signed_weighted_maxcut' else score


def kings_links(h,w):
    return {(y*w+x,yy*w+xx) for y in range(h) for x in range(w)
            for yy,xx in ((y,x+1),(y+1,x-1),(y+1,x),(y+1,x+1))
            if yy<h and 0<=xx<w}


def chimera_links(rows,columns):
    def node(r,c,shore,i):
        return ((r*columns+c)*2+shore)*4+i
    links=set()
    for r in range(rows):
        for c in range(columns):
            links.update((node(r,c,0,i),node(r,c,1,j)) for i in range(4) for j in range(4))
            if r+1<rows:
                links.update((node(r,c,0,i),node(r+1,c,0,i)) for i in range(4))
            if c+1<columns:
                links.update((node(r,c,1,i),node(r,c+1,1,i)) for i in range(4))
    return links


def verify_topology(d):
    n=d['n_variables'];f=d['source_family'];t=d['topology']
    terms=[edge[:2] for edge in d['edges']] if f in ('kings','chimera') else [c['variables'] for c in d['constraints']]
    degrees=[0]*n
    for term in terms:
        for v in term:degrees[v]+=1
    histogram={str(k):v for k,v in sorted(Counter(degrees).items())}
    require(histogram==t['degree_histogram'],'Degree histogram mismatch')
    require(len(terms)==t['edges_or_factors'] and t['variables']==n,'Topology size mismatch')
    links={tuple(sorted(term)) for term in terms}
    if f=='kings':
        require(t['rows']*t['columns']==n,'King grid dimension mismatch')
        require(links==kings_links(t['rows'],t['columns']),'Incorrect King connectivity')
        require(all(w in (-1,1) for _,_,w in d['edges']),'Unexpected King edge weight')
    elif f=='chimera':
        require(8*t['cell_rows']*t['cell_columns']==n,'Chimera dimensions mismatch')
        require(links<=chimera_links(t['cell_rows'],t['cell_columns']),'Non-Chimera edge')
        require(degrees.count(0)==t['zero_degree_variables'],'Inactive-node count mismatch')
    elif f=='sat':
        require(len(terms)==round(4.3*n),'SAT density mismatch')
    else:
        require(len(terms)==2*n//3+1 and len(links)==len(terms),'XOR count/duplicate mismatch')
        require(set(degrees)=={2,3},'XOR variable degrees changed')
        neighbors=[set() for _ in range(n)]
        for term in terms:
            for v in term:neighbors[v].update(x for x in term if x!=v)
        seen={0};queue=[0]
        while queue:
            v=queue.pop()
            for x in neighbors[v]-seen:seen.add(x);queue.append(x)
        require(len(seen)==n,'XOR input disconnected')


def verify_certificate(d,c):
    require(c['instance_id']==d['instance_id'],'Certificate ID mismatch')
    require(c['mathematical_problem_sha256']==problem_signature(d),'Certificate input mismatch')
    require(c['target']==d['objective']['target'],'Certificate target mismatch')
    if c['target'] is None:
        require(d['instance_id']=='kings_maxcut1024_instance1','Unexpected uncomputed target')
        require(c['witness'] is None and c['evidence']['kind']=='target_not_computed','Invalid pending certificate')
        require(d['objective']['target_status']=='not_computed' and d['construction']['optimization_run'] is False,'Uncomputed target is mislabelled')
        return False
    bits=c['witness'];Problem(d).check_bits(bits)
    require(independent_objective(d,bits)==c['target'],'Witness fails direct objective')
    evidence=c['evidence'];kind=evidence['kind']
    if d['source_family']=='kings':
        r=evidence['original_record']
        require(kind=='retained_exact_integer_dp_record' and r['eligible'] and r['kind']=='exact_integer_dp','Invalid DP record')
        edges=d['edges']
        encoded=(b''.join(struct.pack('<i',u) for u,_,_ in edges)
                 + b''.join(struct.pack('<i',v) for _,v,_ in edges)
                 + struct.pack(f'{len(edges)}b',*(w for _,_,w in edges)))
        require(r['instance_digest']==hashlib.sha256(encoded).hexdigest() and r['target']==c['target'],'DP record identity mismatch')
        require(r['instance']==d['original_instance_id'] and r['n']==d['n_variables'],'DP record dimensions or ID mismatch')
        require(''.join(map(str,bits))==r['witness_bits'],'DP witness changed')
    elif d['source_family']=='chimera':
        require(kind=='compositional_frustrated_loop_bound','Missing Chimera proof')
        aggregate=Counter();bound=0
        allowed=chimera_links(d['topology']['cell_rows'],d['topology']['cell_columns'])
        require(len(evidence['loops'])==d['construction']['loop_count'],'Loop count mismatch')
        for loop in evidence['loops']:
            nodes=loop['cycle_nodes'];weights=loop['edge_weights'];length=len(nodes)
            require(length==len(set(nodes))==len(weights),'Loop is not a simple cycle')
            lower,upper=d['construction']['loop_length_bounds']
            require(lower<=length<=upper and all(w in (-1,1) for w in weights),'Invalid loop shape or weights')
            require(sum(w==1 for w in weights)%2==1,'Cycle lacks frustration')
            expected=length-1-sum(w==-1 for w in weights)
            require(expected==loop['maximum_signed_cut'],'Incorrect loop upper bound')
            score=0
            for k,w in enumerate(weights):
                u,v=sorted((nodes[k],nodes[(k+1)%length]))
                require((u,v) in allowed,'Loop edge outside Chimera lattice')
                aggregate[(u,v)]+=w;score+=w*int(bits[u]!=bits[v])
            require(score==expected,'Witness does not attain a loop bound')
            bound+=expected
        edges={(u,v):w for u,v,w in d['edges']}
        require({edge:w for edge,w in aggregate.items() if w}==edges,'Loop sum differs from exported graph')
        require(bound==evidence['optimum_upper_bound']==c['target'],'Chimera bound mismatch')
    else:
        require(kind=='satisfying_witness_and_zero_lower_bound' and evidence['optimum_lower_bound']==c['target']==0,'Incorrect constraint lower bound')
    return True


def field_checks(d,bits,sites):
    model=Problem(d)
    require(model.objective(bits)==independent_objective(d,bits),'Objective implementations disagree')
    for site in sites:
        zero=bits.copy();one=bits.copy();zero[site]=0;one[site]=1
        expected=independent_energy(d,zero)-independent_energy(d,one)
        require(model.conditional_q(bits,site)==expected,'Conditional field does not equal exact energy difference')
    return len(sites)


def exhaustive_small_checks():
    checks=0
    for weight in (-3,-1,1,4):
        d=dict(n_variables=2,node_index_base=0,problem_type='signed_weighted_maxcut',edges=[[0,1,weight]])
        for bits in product((0,1),repeat=2):checks+=field_checks(d,list(bits),list(range(2)))
    for signs in product((-1,1),repeat=3):
        d=dict(n_variables=3,node_index_base=0,problem_type='3sat',constraints=[dict(variables=[0,1,2],signs=list(signs))])
        for bits in product((0,1),repeat=3):checks+=field_checks(d,list(bits),list(range(3)))
    for parity in (0,1):
        d=dict(n_variables=3,node_index_base=0,problem_type='3xorsat',constraints=[dict(variables=[0,1,2],parity=parity)])
        for bits in product((0,1),repeat=3):checks+=field_checks(d,list(bits),list(range(3)))
    for q in (-1000,-3,0,3,1000):
        require(probability_one(0,q)==0.5,'Zero-beta sampling is biased')
        require(math.isclose(probability_one(2,q)+probability_one(2,-q),1,abs_tol=1e-14),'Logistic complement mismatch')
    return checks


def validate(skip_sampler=False):
    started=time.monotonic();rows=discover_instances(ROOT)
    expected={f'{prefix}{n}':count for prefix in PREFIX.values() for n,count in GROUP_COUNTS.items()}
    total=sum(expected.values())
    require(len(rows)==total,'Incorrect collection instance count')
    require(Counter(r['group'] for r in rows)==Counter(expected),'Incorrect group coverage')
    require(len({r['instance_id'] for r in rows})==total,'Duplicate instance IDs')
    field_count=0;smoke_count=0;replay_count=0;checked_groups=set();rng=random.Random(17092026)
    witness_count=0;certificate_kinds=Counter()
    original_ids=set();asic_ids={};problem_digests=[]
    tiny_count=exhaustive_small_checks()
    for row in rows:
        group=row['group'];iid=row['instance_id']
        require(iid==f'{group}_instance{row["instance_number"]}','Folder naming mismatch')
        require(1<=row['instance_number']<=expected[group],'Invalid instance number')
        path=row['problem_path'];certificate_path=path.with_name('certificate.json')
        require(certificate_path.resolve().is_relative_to(ROOT.resolve()),'External certificate dependency')
        d=read(path);certificate=read(certificate_path);model=Problem(d)
        require(d['instance_id']==iid and d['group']==group,'Input ID mismatch')
        require(d['original_cohort_key'] not in original_ids,'Duplicate original ID')
        original_ids.add(d['original_cohort_key'])
        require(d['n_variables']==row['n_variables'],'Variable count mismatch')
        require(d['mathematical_problem_sha256']==problem_signature(d),'Mathematical input identity changed')
        problem_digests.append((iid,d['mathematical_problem_sha256']))
        if d['asic_case_id']:
            require(d['asic_case_id'] not in asic_ids,'Duplicate ASIC selection')
            asic_ids[d['asic_case_id']]=iid
        verify_topology(d)
        witness_count+=int(verify_certificate(d,certificate))
        certificate_kinds[certificate['evidence']['kind']]+=1
        for _ in range(2):
            bits=[rng.randrange(2) for _ in range(model.n)]
            field_count+=field_checks(d,bits,rng.sample(range(model.n),8))
        if not skip_sampler:
            result=solve(model,seed=17,betas=[0.25],sweeps_per_beta=1)
            require(independent_objective(d,[int(x) for x in result['best_assignment']])==result['best_objective'],'Returned assignment fails independent scorer')
            require(result['sampling_uniform_draws']==result['visits'],'Sampling count mismatch')
            smoke_count+=1
            if group not in checked_groups:
                require(result==solve(model,seed=17,betas=[0.25],sweeps_per_beta=1),'Seeded replay changed')
                replay_count+=1;checked_groups.add(group)
    for group in expected:
        require(len(list((ROOT/group).glob('*/problem.json')))==expected[group],'Extra or missing instance folder')
    expected_asic={}
    for family,prefix in PREFIX.items():
        for n in (32,128,288,512,800):
            tag={'kings':'maxcut','chimera':'chimera','sat':'sat','xor':'xorsat'}[family]
            number=4 if family=='chimera' and n==512 else 1
            expected_asic[f'{tag}{n}']=f'{prefix}{n}_instance{number}'
    require(asic_ids==expected_asic,'ASIC selection mapping changed')
    return dict(passed=True,instances=total,groups=len(expected),instances_per_size_group=GROUP_COUNTS,
                instance_file_sets_checked=total,mathematical_input_hashes_verified=total,
                topologies_verified=total,witnesses_independently_rescored=witness_count,
                retained_king_dp_records=certificate_kinds['retained_exact_integer_dp_record'],
                chimera_compositional_proofs_verified=certificate_kinds['compositional_frustrated_loop_bound'],
                sat_xor_zero_lower_bounds_verified=certificate_kinds['satisfying_witness_and_zero_lower_bound'],
                uncomputed_targets=certificate_kinds['target_not_computed'],asic_selections_verified=20,
                exhaustive_small_field_checks=tiny_count,full_instance_field_checks=field_count,
                bounded_sampler_checks=smoke_count,deterministic_group_replays=replay_count,
                sampler_checks_skipped=skip_sampler,
                collection_identity_sha256=hashlib.sha256(json.dumps(problem_digests,separators=(',',':')).encode()).hexdigest(),
                python_version=platform.python_version(),
                elapsed_seconds=round(time.monotonic()-started,3),
                scope=('Input, certificate and local-field checks only; no solver was run.' if skip_sampler else
                       'Data, certificates and bounded reference-sampler validation; original King DP optimization and production experiments were not rerun.'))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path)
    parser.add_argument('--skip-sampler',action='store_true',help='Check inputs and certificates without any search runs')
    args=parser.parse_args()
    result=validate(skip_sampler=args.skip_sampler);text=json.dumps(result,indent=2)+'\n'
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(text)
    print(text,end='')


if __name__=='__main__':
    main()
