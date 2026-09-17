// Sparse-neighbor reference for simulation checks.
struct CacheReference {
    std::vector<std::vector<unsigned>> neighbors;
    std::vector<unsigned> degree;
    std::vector<bool> dirty;
    std::vector<int> saved;
    uint64_t reads,visits,cycles;
    CacheReference(const std::vector<uint64_t>& image,unsigned n,uint64_t count,unsigned factors)
        :neighbors(n),degree(n),dirty(n,true),saved(n,0),reads(factors),visits(count),cycles(factors+1) {
        unsigned nw=0,aw=0;while((1u<<nw)<n)++nw;while((1u<<aw)<image.size())++aw;
        for(unsigned i=0;i<n;++i){unsigned base=image[i]&((1u<<aw)-1);degree[i]=image[i]>>aw;
            for(unsigned j=0;j<degree[i];++j){auto w=image[base+j];neighbors[i].push_back(w&((1u<<nw)-1));neighbors[i].push_back((w>>nw)&((1u<<nw)-1));}}
    }
    void commit(uint64_t visit,unsigned site,int field,int old,int next,bool fresh) {
        bool hit=!dirty[site];
        cycles+=hit ? 2 : 3+(degree[site] ? degree[site]+1 : 0);
        if(hit&&saved[site]!=field)throw std::runtime_error("cache reference changed field without invalidation");
        if(!hit)reads+=1+degree[site];
        if(fresh)saved[site]=field;
        if(saved[site]!=field)throw std::runtime_error("XOR saved field is not current after visit");
        dirty[site]=false;
        if(old!=next){
            if(visit<visits){
                reads+=degree[site]+unsigned(hit);
                cycles+=(hit ? 2 : 0)+(degree[site] ? degree[site]+1 : 0);
            }
            for(auto j:neighbors[site])dirty[j]=true;
        }
    }
};
