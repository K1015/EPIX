#!/usr/bin/env python3
"""Generate four 1024-variable inputs and their construction records; no solver runs."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import random

from solvers.model import problem_signature

ROOT = Path(__file__).resolve().parent
PREFIX = {'kings':'kings_maxcut','chimera':'chimera_maxcut','sat':'3hypergraph_sat','xor':'3hypergraph_xorsat'}
SEEDS = {'kings':20260917102401,'chimera':20260917102402,'sat':20260917102403,'xor':20260917102404}
N = 1024


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compact_json(value, level=0):
    if isinstance(value,list) and all(not isinstance(x,(dict,list)) for x in value):
        return json.dumps(value)
    if isinstance(value,(dict,list)) and not value:
        return '{}' if isinstance(value,dict) else '[]'
    pad='  '*(level+1)
    if isinstance(value,list):
        return '[\n'+',\n'.join(pad+compact_json(x,level+1) for x in value)+'\n'+'  '*level+']'
    if isinstance(value,dict):
        return '{\n'+',\n'.join(pad+json.dumps(str(k))+': '+compact_json(v,level+1) for k,v in value.items())+'\n'+'  '*level+'}'
    return json.dumps(value,allow_nan=False)


def write_new(path,value):
    path.parent.mkdir(parents=True,exist_ok=True)
    with path.open('x') as stream:stream.write(compact_json(value)+'\n')


def topology_stats(terms):
    degrees=[0]*N
    for term in terms:
        for node in term:degrees[node]+=1
    return dict(variables=N,edges_or_factors=len(terms),degree_histogram=dict(sorted(Counter(degrees).items()))),degrees


def kings(rng):
    side=32
    edges=[[r*side+c,(r+dr)*side+c+dc,rng.choice((-1,1))]
           for r in range(side) for c in range(side)
           for dr,dc in ((0,1),(1,-1),(1,0),(1,1))
           if r+dr<side and 0<=c+dc<side]
    stats,_=topology_stats([edge[:2] for edge in edges])
    topology=dict(name="Open-boundary square King's graph",rows=side,columns=side,
        grid_short_side=side,grid_long_side=side,boundary='open',
        node_numbering='node = row * columns + column',**stats)
    construction=dict(method='Complete king-move connectivity; independent equiprobable signed weights',
        edge_weight_values=[-1,1],edge_enumeration_offsets=[[0,1],[1,-1],[1,0],[1,1]],
        enumeration='row-major source nodes; offsets in the recorded order; omit out-of-range neighbors')
    return topology,construction,dict(edges=edges,edge_columns=['source','destination','weight']),None,None,dict(
        kind='target_not_computed',status='input_only',description='No optimization or optimum certification was performed for this new input.')


def chimera_links(rows,cols):
    def node(r,c,shore,index):return ((r*cols+c)*2+shore)*4+index
    links=[]
    for r in range(rows):
        for c in range(cols):
            links.extend((node(r,c,0,i),node(r,c,1,j)) for i in range(4) for j in range(4))
            if r+1<rows:links.extend((node(r,c,0,i),node(r+1,c,0,i)) for i in range(4))
            if c+1<cols:links.extend((node(r,c,1,i),node(r,c+1,1,i)) for i in range(4))
    return sorted(links)


def sample_cycle(neighbors,rng):
    for _ in range(20000):
        start=rng.randrange(N);path=[start];positions={start:0};previous=-1
        while len(path)<=N:
            current=path[-1];choices=[x for x in neighbors[current] if x!=previous]
            if not choices:break
            nxt=rng.choice(choices)
            if nxt in positions:
                cycle=path[positions[nxt]:]
                if 4<=len(cycle)<=8:return cycle
                break
            positions[nxt]=len(path);path.append(nxt);previous=current
    raise RuntimeError('Could not sample a short simple Chimera cycle')


def chimera(rng):
    rows,cols=8,16;links=chimera_links(rows,cols)
    neighbors=[[] for _ in range(N)]
    for u,v in links:neighbors[u].append(v);neighbors[v].append(u)
    neighbors=[sorted(row) for row in neighbors]
    witness=[rng.getrandbits(1) for _ in range(N)]
    aggregate=Counter();loops=[];target=0
    for _ in range(round(0.4*N)):
        cycle=sample_cycle(neighbors,rng);frustrated=rng.randrange(len(cycle));weights=[]
        for k,u in enumerate(cycle):
            v=cycle[(k+1)%len(cycle)]
            w=1 if witness[u]!=witness[v] else -1
            if k==frustrated:w=-w
            weights.append(w);aggregate[tuple(sorted((u,v)))]+=w
        bound=len(cycle)-1-sum(w<0 for w in weights);target+=bound
        loops.append(dict(cycle_nodes=cycle,edge_weights=weights,maximum_signed_cut=bound))
    edges=[[u,v,w] for (u,v),w in sorted(aggregate.items()) if w]
    assert sum(w for u,v,w in edges if witness[u]!=witness[v])==target
    stats,degrees=topology_stats([edge[:2] for edge in edges])
    topology=dict(name='Planted frustrated-loop subgraph of open-boundary rectangular Chimera C_(8,16,4)',
        cell_rows=rows,cell_columns=cols,cell_graph='K_4,4',full_lattice_edges=len(links),
        zero_degree_variables=degrees.count(0),boundary='open',
        node_numbering='node = (((row * cell_columns + column) * 2 + shore) * 4 + local_index)',
        coordinate_ranges=dict(row=[0,rows-1],column=[0,cols-1],shore=[0,1],local_index=[0,3]),**stats)
    construction=dict(method='Planted frustrated loops on a rectangular Chimera lattice; aggregate weights and omit zero sums',
        alpha=0.4,loop_count=len(loops),loop_length_bounds=[4,8],
        geometry_reason='1024 = 8 * 8 * 16; no integer L gives 1024 = 8 * L^2')
    evidence=dict(kind='compositional_frustrated_loop_bound',optimum_upper_bound=target,
        description='The generated witness attains every signed-loop upper bound. Their sum bounds the aggregate graph.',
        edge_order='edge_weights[k] applies to cycle_nodes[k] and the next node, wrapping at the end',loops=loops)
    return topology,construction,dict(edges=edges,edge_columns=['source','destination','weight']),target,witness,evidence


def sat(rng):
    witness=[rng.getrandbits(1) for _ in range(N)];constraints=[]
    for _ in range(round(4.3*N)):
        variables=rng.sample(range(N),3);mask=rng.randrange(1,8)
        signs=[1 if bool(witness[v])==bool((mask>>k)&1) else -1 for k,v in enumerate(variables)]
        constraints.append(dict(variables=variables,signs=signs))
    stats,_=topology_stats([c['variables'] for c in constraints])
    topology=dict(name='Random 3-uniform hypergraph with planted 3-SAT clauses',clause_density=len(constraints)/N,**stats)
    construction=dict(method='Conventional planted random 3-SAT',clause_count=len(constraints),clause_count_rule='round(4.3 * N)',
        variable_selection='Three distinct variables sampled uniformly for each clause',
        literal_selection='Uniform choice among the seven patterns satisfying a uniformly sampled planted assignment',
        repeated_variable_triples='Allowed across clauses; every clause remains a separate constraint')
    return topology,construction,dict(constraints=constraints,literal_sign_convention='+1 means x; -1 means NOT x'),0,witness,dict(
        kind='satisfying_witness_and_zero_lower_bound',optimum_lower_bound=0,known_by_construction=True)


def connected(triples):
    neighbors=[set() for _ in range(N)]
    for triple in triples:
        for v in triple:neighbors[v].update(x for x in triple if x!=v)
    seen={0};todo=[0]
    while todo:
        node=todo.pop()
        for x in neighbors[node]-seen:seen.add(x);todo.append(x)
    return len(seen)==N


def xor(rng):
    m=2*N//3+1;degree=[2]*N
    for node in rng.sample(range(N),3*m-2*N):degree[node]+=1
    for attempt in range(10000):
        slots=[node for node,d in enumerate(degree) for _ in range(d)];rng.shuffle(slots)
        triples=[slots[i:i+3] for i in range(0,len(slots),3)]
        if any(len(set(t))!=3 for t in triples):continue
        if len({tuple(sorted(t)) for t in triples})!=m or not connected(triples):continue
        break
    else:raise RuntimeError('XOR generation exhausted its attempt budget')
    witness=[rng.getrandbits(1) for _ in range(N)]
    constraints=[dict(variables=t,parity=witness[t[0]]^witness[t[1]]^witness[t[2]]) for t in triples]
    stats,_=topology_stats(triples)
    topology=dict(name='Connected mixed-degree 3-uniform hypergraph with planted XOR constraints',
        constraint_density=m/N,connected=True,encoded_cnf_clauses=4*m,additional_encoding_variables=0,**stats)
    construction=dict(method='Connected configuration model with variable degrees two and three; planted parity',
        constraint_count=m,constraint_count_rule='floor(2 * N / 3) + 1',minimum_variable_degree=2,maximum_variable_degree=3,
        distinct_variable_triples=True,connected=True,generation_attempt=attempt,
        parity_selection='XOR of the three bits in a uniformly sampled planted assignment',
        cnf_encoding=dict(clauses_per_constraint=4,extra_variables=0))
    return topology,construction,dict(constraints=constraints),0,witness,dict(
        kind='satisfying_witness_and_zero_lower_bound',optimum_lower_bound=0,known_by_construction=True)


def generate(output):
    for prefix in PREFIX.values():
        if (output/f'{prefix}{N}').exists():raise FileExistsError('1024 group already exists; use a fresh --output directory to regenerate')
    source_hash=sha(Path(__file__))
    for family,prefix in PREFIX.items():
        group=f'{prefix}{N}';iid=f'{group}_instance1';seed=SEEDS[family]
        topology,construction,body,target,witness,evidence=globals()[family](random.Random(seed))
        construction.update(generator_seed=seed,rng='Python random.Random (Mersenne Twister)',
            generator_source='pbit-software-benchmark/generate_1024.py',generator_source_sha256=source_hash,
            source_campaign='1024_input_extension_v1',optimization_run=False)
        graph=family in ('kings','chimera')
        objective=dict(name='signed_weighted_cut' if graph else ('unsatisfied_sat_clauses' if family=='sat' else 'violated_xor_constraints'),
            sense='maximize' if graph else 'minimize',target=target,
            target_status='not_computed' if target is None else 'known_by_construction',
            reference_energy='negative signed weighted cut' if graph else 'violated constraint count')
        original_key=f'extension1024_{family}_{seed}'
        problem=dict(schema_version='epix.problem.v1',instance_id=iid,group=group,
            original_instance_id=iid,original_cohort_key=original_key,source_family=family,
            origin='newly_generated_1024_input',problem_type='signed_weighted_maxcut' if graph else ('3sat' if family=='sat' else '3xorsat'),
            n_variables=N,node_index_base=0,variable_domain=[0,1],objective=objective,topology=topology,
            construction=construction,asic_case_id=None,**body)
        digest=problem_signature(problem);problem['mathematical_problem_sha256']=digest
        certificate=dict(schema_version='epix.certificate.v1',instance_id=iid,mathematical_problem_sha256=digest,
            target=target,witness=witness,evidence=evidence,source=dict(generator_sha256=source_hash,optimization_run=False))
        folder=output/group/iid
        write_new(folder/'problem.json',problem)
        write_new(folder/'certificate.json',certificate)
    print(json.dumps(dict(added_instances=4,total_instances=len(list(output.glob('*/*/problem.json'))),
        optimization_runs=0,output=str(output)),indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT)
    generate(parser.parse_args().output.resolve())
