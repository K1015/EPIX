// Run the solver, check each update, and record setup and search activity.
#include "Vdut.h"
#include "verilated.h"
#include "case.h"
#include <cstdint>
#include <fstream>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>
#if VM_TRACE_SAIF
#include "verilated_saif_c.h"
#endif
extern "C" void a1_set_window(int);
extern "C" void a1_write_counts(const char*);
static void require(bool ok,const std::string& msg){if(!ok)throw std::runtime_error(msg);}
template<class T> static uint32_t limb(const T& x,int k){if constexpr(std::is_integral_v<T>)return uint32_t(uint64_t(x)>>(32*k));else return x[k];}
static int signed_field(uint32_t x){return int32_t(x<<(32-FIELD_BITS))>>(32-FIELD_BITS);}
static uint32_t noise(uint32_t& x){x^=x<<13;x^=x>>17;x^=x<<5;return x;}
int main(int argc,char** argv){try{
    require(argc>=6,"usage: sim coefficients header trace stall_seed trials.tsv [activity.saif]");
    std::ifstream header(argv[2]),reference(argv[3]),memory(argv[1]);require(header.good()&&reference.good()&&memory.good(),"missing inputs");
    uint64_t n,sweeps,mode,expected_visits,initial_e,final_e,best_e,expected_reads;
    header>>n>>sweeps>>mode>>expected_visits>>initial_e>>final_e>>best_e>>expected_reads;require(n==SITES,"wrong size");
    constexpr int W=(SITES+31)/32;std::vector<uint32_t> initial(W),seeds(SITES),final_bits(W),best_bits(W);
    for(auto& v:initial)header>>v;for(auto& v:seeds)header>>v;for(auto& v:final_bits)header>>v;for(auto& v:best_bits)header>>v;
    require(!header.fail(),"bad header");
    auto ctx=std::make_unique<VerilatedContext>();ctx->commandArgs(argc,argv);
#if VM_TRACE_SAIF
    ctx->traceEverOn(true);
#endif
    auto model=std::make_unique<Vdut>(ctx.get());auto& d=*model;
#if VM_TRACE_SAIF
    std::unique_ptr<VerilatedSaifC> trace;
    if(argc>6){trace=std::make_unique<VerilatedSaifC>();d.trace(trace.get(),99);trace->open(argv[6]);}
#endif
    uint64_t last_dump=UINT64_MAX,cycles=0;
    auto eval=[&](){d.eval();
#if VM_TRACE_SAIF
        if(trace&&ctx->time()!=last_dump){trace->dump(ctx->time());last_dump=ctx->time();}
#endif
    };
    auto settle=[&](){if(ctx->time()%200000==0)ctx->timeInc(1);eval();};
    auto snapshot=[&](const char* suffix){
#if VM_TRACE_SAIF
        if(trace)trace->spTrace()->snapshot((std::string(argv[6])+suffix).c_str(),ctx->time());
#endif
    };
    auto tick=[&](){d.clk=0;settle();ctx->timeInc(100000-ctx->time()%200000);d.clk=1;eval();ctx->timeInc(100000);d.clk=0;eval();++cycles;};
    d.clk=0;d.rst=1;d.start=0;d.stop=0;d.step_allow=0;d.test_enable=0;
    d.seed_we=0;d.coeff_we=0;d.coeff_address=0;d.coeff_data=0;d.seed_node=0;d.seed_data=0;d.seed_spin=0;
    d.epix_enable=mode;d.sweeps_per_beta=sweeps;eval();for(int k=0;k<4;++k)tick();
    uint64_t setup_begin=cycles;snapshot(".warm.saif");a1_set_window(1);d.rst=0;
    for(int i=0;i<MEMORY_WORDS;++i){uint64_t value;memory>>std::hex>>value;require(!memory.fail(),"short SRAM image");d.coeff_we=1;d.coeff_address=i;d.coeff_data=value;tick();require(!d.error_code,"coefficient load");}
    d.coeff_we=0;
    for(int i=0;i<SITES;++i){d.seed_we=1;d.seed_node=i;d.seed_data=seeds[i];d.seed_spin=(initial[i/32]>>(i%32))&1;tick();require(!d.error_code,"seed load");}
    d.seed_we=0;settle();require(d.ready,"not ready after configuration");d.start=1;tick();d.start=0;
    uint64_t search_begin=cycles;snapshot(".setup.saif");a1_set_window(0);
    uint32_t random=std::stoul(argv[4]);bool stalls=random!=0;
    uint64_t commits=0,fresh=0,reuse=0,reads=0;auto bits=initial;
    while(!d.done){
        require(cycles-search_begin<uint64_t(MEMORY_WORDS)+expected_visits*(FIELD_BOUND_VALUE+16)*4+10000,"cycle bound");
        d.step_allow=!stalls||noise(random)%5!=0;settle();bool take=d.commit_valid;reads+=d.coeff_read_event;
        if(!d.step_allow)require(!take&&!d.coeff_read_event,"activity during stall");
        uint64_t visit=0,site=0,word=0,beta=0,rf=0,clear=0;int q=0,old=0,next=0,e=0;
        if(take){
            reference>>visit>>site>>q>>old>>next>>e>>word>>beta>>rf>>clear;require(!reference.fail(),"extra commit");
            std::string at=" at visit "+std::to_string(visit);
            require(visit==commits+1&&site==d.event_site,"schedule"+at);
            require(q==signed_field(d.event_field),"field"+at);
            require(old==d.event_old&&next==d.event_new,"sample"+at);
            require(word==d.event_word&&beta==d.event_beta&&rf==d.event_fresh,"RNG/policy"+at);
            bits[site/32]=(bits[site/32]&~(1u<<(site%32)))|(uint32_t(next)<<(site%32));
            ++commits;if(rf)++fresh;else ++reuse;
        }
        tick();
        if(take){require(uint64_t(d.energy)==uint64_t(e),"objective");require(d.visits==commits&&d.fresh_words==fresh&&d.reuse_events==reuse,"counters");for(int k=0;k<W;++k)require(limb(d.spins,k)==bits[k],"full assignment");}
    }
    uint64_t end=cycles;snapshot(".end.saif");a1_set_window(-1);
    require(commits==expected_visits&&reads==expected_reads&&!d.error_code,"final counts");
    require(d.energy==final_e&&d.best_energy==best_e,"final objective");
    for(int k=0;k<W;++k){require(limb(d.spins,k)==final_bits[k],"final assignment");require(limb(d.best_spins,k)==best_bits[k],"best assignment");}
    std::ofstream out(argv[5]);out<<"trial\tsetup_begin\tsearch_begin\tend\tvisits\tenergy\tbest_energy\tfresh\treuse\tcoefficient_reads\tcoefficient_writes\tsetup_coefficient_writes\n";
    out<<0<<'\t'<<setup_begin<<'\t'<<search_begin<<'\t'<<end<<'\t'<<commits<<'\t'<<final_e<<'\t'<<best_e<<'\t'<<fresh<<'\t'<<reuse<<'\t'<<reads<<'\t'<<0<<'\t'<<MEMORY_WORDS<<'\n';out.close();
    a1_write_counts((std::string(argv[5])+".macros.tsv").c_str());
#if VM_TRACE_SAIF
    if(trace)trace->close();
#endif
    d.final();std::cout<<"ALL_PASS 1 commits "<<commits<<" cycles "<<end-setup_begin<<"\n";return 0;
}catch(const std::exception& e){std::cerr<<e.what()<<'\n';return 1;}}
