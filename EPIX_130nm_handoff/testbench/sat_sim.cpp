#include "Va2_core.h"
#include "verilated.h"
#include "reference.h"
#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>

static void require(bool ok,const std::string& msg) { if(!ok) throw std::runtime_error(msg); }
template<class T> static uint32_t limb(const T& x,int k) {
    if constexpr(std::is_integral_v<T>) return uint32_t(uint64_t(x)>>(32*k));
    else return x[k];
}
template<class T> static uint32_t extract(const T& x,int offset,int width) {
    uint64_t v=limb(x,offset/32);int shift=offset%32;
    if(shift+width>32)v|=uint64_t(limb(x,offset/32+1))<<32;
    return uint32_t(v>>shift)&(width==32?0xffffffffu:((1u<<width)-1));
}
static int signed_field(uint32_t x) {return int32_t(x<<(32-FIELD_BITS))>>(32-FIELD_BITS);}
static uint32_t random_step(uint32_t& x) {x^=x<<13;x^=x>>17;x^=x<<5;return x;}

int main(int argc,char** argv) {
    try {
        require(argc>=5,"usage: sim coefficients.hex header trace stall_seed [control]");
        Verilated::commandArgs(argc,argv);Va2_core d;
        uint64_t ticks=0;
        auto low=[&](){d.clk=0;d.eval();d.eval();};
        auto high=[&](){d.clk=1;d.eval();d.eval();++ticks;};
        auto tick=[&](){low();high();};
        d.rst=1;d.start=0;d.stop=0;d.step_allow=0;d.test_enable=0;d.seed_we=0;d.coeff_we=0;d.epix_enable=0;d.sweeps_per_beta=0;
        tick();tick();d.rst=0;tick();
        if(argc>5) {
            d.start=1;tick();require(d.error_code==3,"unconfigured start accepted");d.start=0;
            d.seed_we=1;d.seed_node=0;d.seed_data=0;tick();require(d.error_code==2,"zero seed accepted");d.seed_we=0;
            d.coeff_we=1;d.coeff_address=1;d.coeff_data=0;tick();require(d.error_code==1,"out-of-order coefficient accepted");d.coeff_we=0;
            d.rst=1;tick();d.rst=0;tick();
        }
        std::ifstream header(argv[2]),trace(argv[3]),memory(argv[1]);
        require(header.good()&&trace.good()&&memory.good(),"cannot open inputs");
        uint64_t n,sweeps,mode,expected_visits,initial_e,final_e,best_e,expected_reads;
        header>>n>>sweeps>>mode>>expected_visits>>initial_e>>final_e>>best_e>>expected_reads;
        require(n==SITES,"wrong instance size");
        constexpr int W=(SITES+31)/32;
        std::vector<uint32_t> initial(W),seeds(SITES),final_bits(W),best_bits(W);
        for(auto& v:initial)header>>v;for(auto& v:seeds)header>>v;
        for(auto& v:final_bits)header>>v;for(auto& v:best_bits)header>>v;
        require(!header.fail(),"bad header");
        uint64_t coefficient;
        for(int i=0;i<MEMORY_WORDS;++i) {
            memory>>std::hex>>coefficient;require(!memory.fail(),"truncated coefficient image");
            d.coeff_we=1;d.coeff_address=i;d.coeff_data=coefficient;tick();require(d.error_code==0,"coefficient configuration error");
        }
        d.coeff_we=0;
        for(int i=0;i<SITES;++i) {
            d.seed_we=1;d.seed_node=i;d.seed_data=seeds[i];d.seed_spin=(initial[i/32]>>(i%32))&1;tick();
            require(d.error_code==0,"seed configuration error");
        }
        d.seed_we=0;low();require(d.ready,"configuration did not become ready");
        d.epix_enable=mode;d.sweeps_per_beta=sweeps;d.start=1;tick();d.start=0;
        uint32_t stall_rng=std::stoul(argv[4]);bool stalls=stall_rng!=0;
        auto rng=seeds;std::vector<int> fields(SITES,0),ages(SITES,0),valid(SITES,0);auto bits=initial;
        uint64_t commits=0,fresh=0,reused=0,reads=0,stalled=0,run_cycles=0,rng_pulses=0;
        uint64_t run_limit=uint64_t(MEMORY_WORDS)+expected_visits*(FIELD_BOUND_VALUE+16)*4+10000;
        while(!d.done) {
            require(run_cycles++<run_limit,"simulation exceeded cycle bound");
            d.step_allow=(!stalls || random_step(stall_rng)%5!=0);low();
            bool take=d.commit_valid;bool coefficient_read=d.coeff_read_event;
            if(!d.step_allow) {++stalled;require(!take&&!coefficient_read,"activity during a stalled cycle");}
            reads+=coefficient_read;
            uint64_t visit=0,site=0,word=0,beta=0,rf=0,clear=0;int q=0,old=0,next=0,e=0;
            if(take) {
                trace>>visit>>site>>q>>old>>next>>e>>word>>beta>>rf>>clear;
                require(!trace.fail(),"RTL produced an extra commit");
                std::string where="visit "+std::to_string(visit);
                require(visit==commits+1&&site==d.event_site,where+": schedule");
                require(q==signed_field(d.event_field),where+": field");
                require(old==d.event_old&&next==d.event_new,where+": sample");
                require(word==d.event_word&&beta==d.event_beta&&rf==d.event_fresh,where+": RNG/policy");
                rng[site]=word;
                if(rf){fields[site]=q;ages[site]=0;valid[site]=1;++fresh;}else{++ages[site];++reused;}
                if(clear){std::fill(ages.begin(),ages.end(),0);std::fill(valid.begin(),valid.end(),0);}
                bits[site/32]=(bits[site/32]&~(1u<<(site%32)))|(uint32_t(next)<<(site%32));
                ++commits;
            }
            high();
            for(int i=0;i<SITES;++i) {
                require(limb(d.debug_rng,i)==rng[i],"private RNG changed unexpectedly at site "+std::to_string(i));
                bool pulse=extract(d.debug_rng_clocks,i,1);
                require(pulse==(take&&rf&&site==uint64_t(i)),"incorrect private RNG clock pulse");
                rng_pulses+=pulse;
            }
            if(take) {
                require(uint64_t(d.energy)==uint64_t(e),"objective mismatch");
                for(int i=0;i<SITES;++i) {
                    require(signed_field(extract(d.debug_saved_field,i*FIELD_BITS,FIELD_BITS))==fields[i],"saved-field mismatch");
                    require(int(extract(d.debug_age,i*AGE_BITS,AGE_BITS))==ages[i],"age mismatch");
                    require(int(extract(d.debug_valid,i,1))==valid[i],"validity mismatch");
                }
                for(int i=0;i<W;++i)require(limb(d.spins,i)==bits[i],"state-vector mismatch");
            }
        }
        require(commits==expected_visits&&d.visits==commits,"visit count mismatch");
        require(d.fresh_words==fresh&&d.reuse_events==reused&&rng_pulses==fresh,"RNG counters mismatch");
        require(reads==expected_reads,"coefficient read count mismatch");
        require(d.energy==final_e&&d.best_energy==best_e,"final objective mismatch");
        for(int i=0;i<W;++i){require(limb(d.spins,i)==final_bits[i],"final assignment mismatch");require(limb(d.best_spins,i)==best_bits[i],"best assignment mismatch");}
        for(int i=0;i<8;++i){d.step_allow=1;tick();require(!d.coeff_read_event,"SRAM active after completion");for(int j=0;j<SITES;++j)require(limb(d.debug_rng,j)==rng[j],"RNG changed after completion");}
        if(argc>5) {
            d.start=1;tick();d.start=0;d.step_allow=1;tick();
            d.stop=1;tick();d.stop=0;low();require(d.done&&!d.busy&&!d.coeff_read_event,"stop did not quiesce engine");
        }
        std::cout<<"{\"passed\":true,\"commits\":"<<commits<<",\"fresh_words\":"<<fresh<<",\"reuse_events\":"<<reused<<",\"coefficient_reads\":"<<reads<<",\"rng_clock_pulses\":"<<rng_pulses<<",\"cycles\":"<<run_cycles<<",\"stalled_cycles\":"<<stalled<<",\"best_energy\":"<<best_e<<",\"control_checks\":"<<(argc>5?"true":"false")<<"}\n";
        d.final();return 0;
    } catch(const std::exception& e) {std::cerr<<"VALIDATION_FAILURE: "<<e.what()<<"\n";return 1;}
}
