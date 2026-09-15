"""Frozen software solver with explicit physical per-node LFSR ablations."""
import hashlib, json, pathlib, sys
import numpy as np
try:
    from numba import njit
except ImportError:
    def njit(*args,**kwargs): return lambda f:f
ROOT = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT/'vendor'))
import apt_icm as K
SPEC = json.loads((ROOT/'inputs/software_spec.json').read_text())
ORIGINAL_STREAM = K.stream_rng
ORIGINAL_UPDATE = K.update_color

def instance():
    x=SPEC; h,w=x['height'],x['width']; n=h*w
    edges=[(r*w+c,(r+dr)*w+c+dc) for r in range(h) for c in range(w)
           for dr,dc in ((0,1),(1,-1),(1,0),(1,1))
           if r+dr<h and 0<=c+dc<w]
    u=np.array([a for a,b in edges],dtype=np.int32)
    v=np.array([b for a,b in edges],dtype=np.int32)
    ew=np.random.default_rng(x['generator_seed']).choice(np.array([-1,1],dtype=np.int8),len(edges))
    ni=np.full((n,8),n,dtype=np.int32); nw=np.zeros((n,8),dtype=np.int8)
    count=np.zeros(n,dtype=int); adj=[[] for _ in range(n)]
    for a,b,c in zip(u,v,ew):
        for i,j in ((a,b),(b,a)):
            ni[i,count[i]]=j; nw[i,count[i]]=c; count[i]+=1; adj[i].append(int(j))
    colors=((np.arange(n)//w)%2*2+(np.arange(n)%w)%2).astype(np.int8)
    inst=K.KingsInstance(x['instance'],w,n,u,v,ew,ni,nw,colors,tuple(tuple(sorted(a)) for a in adj))
    assert K.instance_digest(inst)==x['instance_digest']
    return inst

def lfsr_step(x):
    return ((x << 1)&0xffffffff) | (1 ^ ((x>>31 ^ x>>21 ^ x>>1 ^ x)&1))

@njit(cache=True)
def draw_array(state,indices,stride):
    out=np.empty(len(indices),dtype=np.uint64)
    for j in range(len(indices)):
        i=indices[j]; word=state[i]
        for _ in range(stride):
            word=((word << np.uint64(1)) & np.uint64(0xffffffff)) | (np.uint64(1) ^ ((word>>np.uint64(31) ^ word>>np.uint64(21) ^ word>>np.uint64(1) ^ word)&np.uint64(1)))
        state[i]=word; out[j]=word
    return out

def seed_words(seed,stream,n):
    words=[]
    for i in range(n):
        x=int.from_bytes(hashlib.sha256(f'corrected128/{seed}/{stream}/{i}'.encode()).digest()[:4],'little')
        # XNOR LFSR forbidden all-one state.
        words.append(x if x!=0xffffffff else 1)
    return np.array(words,dtype=np.uint64)

class LFSR:
    def __init__(self,seed,stream,stride):
        self.state=seed_words(seed,stream,128 if stream==2 else 1)
        self.stride=stride; self.indices=None
    def integers(self,low,high,size=None,dtype=None):
        assert low==0 and high==2**32
        if self.indices is None:
            assert len(self.state)==1
            indices=np.zeros(1 if size is None else size,dtype=int)
        else:
            indices=self.indices; assert len(indices)==size
        out=draw_array(self.state,indices,self.stride)
        return np.uint64(out[0]) if size is None else np.array(out,dtype=np.uint64)

def physical_update(inst,bank,betas,color,rng,method,epic_enabled,delta,age_max):
    group=np.flatnonzero(inst.colors==color); chains=bank.state.shape[0]*bank.state.shape[1]
    state=bank.state.reshape(chains,inst.n)
    spins=2*state.astype(np.int16)-1
    pad=np.concatenate((spins,np.zeros((chains,1),dtype=np.int16)),axis=1)
    local=-np.sum(inst.neigh_w[group][None,:,:]*pad[:,inst.neigh_idx[group]],axis=2,dtype=np.int32)
    bfield=np.tile(betas,bank.state.shape[0])[:,None]*local
    field=np.clip(np.rint(K.FIELD_SCALE*bfield),-K.FIELD_LIMIT,K.FIELD_LIMIT)
    refresh=(~bank.valid.reshape(chains,inst.n)[:,group]) | ((field>=0)!=(state[:,group]==1))
    refresh |= np.abs(bfield-bank.stored_bfield.reshape(chains,inst.n)[:,group])>=delta
    refresh |= bank.age.reshape(chains,inst.n)[:,group]>=age_max
    if method!='epic_apt_icm' or not epic_enabled: refresh[:]=True
    rng.indices=np.broadcast_to(group,refresh.shape)[refresh]
    before=state[:,group].copy()
    result=ORIGINAL_UPDATE(inst,bank,betas,color,rng,method,epic_enabled,delta,age_max)
    assert np.array_equal((np.abs(bfield-bank.stored_bfield.reshape(chains,inst.n)[:,group])>=delta)[~refresh],np.zeros(np.sum(~refresh),dtype=bool))
    assert np.array_equal(state[:,group][~refresh],before[~refresh]),'Reuse cannot be elided'
    return result

def run(trial,method,variant='native',budget=256):
    x=SPEC; seed=x['seed_namespace']+x['instance_code']*x['trial_stride']+trial
    K.stream_rng=ORIGINAL_STREAM; K.update_color=ORIGINAL_UPDATE
    if variant!='native':
        stride={'lfsr1':1,'lfsr32':32}[variant]
        K.stream_rng=lambda seed,stream: ORIGINAL_STREAM(seed,stream) if stream==1 else LFSR(seed,stream,stride)
        K.update_color=physical_update
    result=K.run_apt_icm(instance(),x['target'],x['target_kind'],
        'iid_apt_icm' if method=='baseline' else 'epic_apt_icm',trial,seed,x['betas'],budget,[budget],
        copies=2,icm_interval=4,icm_beta_min=1.2,max_disagreement_fraction=.5,
        max_cluster_fraction=.5,field_refresh_delta=.05,max_hold_age=2,stop_on_exact=True)
    return dict(result,variant=variant,hardware_method=method)

if __name__=='__main__':
    inst=instance(); cert=json.loads((ROOT/'inputs/certificate.json').read_text())
    bits=np.array(list(map(int,cert['witness_bits'])),dtype=np.int8)
    assert K.exact_maxcut_dp(inst)==K.cut_bits_direct(inst,bits)==K.cut_bits_adjacency(inst,bits)==SPEC['target']
    print('EXACT_CERTIFICATE_PASS',SPEC['target'])
