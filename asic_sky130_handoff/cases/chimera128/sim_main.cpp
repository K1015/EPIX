#include "Vchimera_solver.h"
#include "verilated.h"
#if VM_TRACE_FST
#include "verilated_fst_c.h"
using Trace = VerilatedFstC;
#else
#include "verilated_vcd_c.h"
using Trace = VerilatedVcdC;
#endif
#include <array>
#include <vector>
#include <fstream>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <algorithm>
using State=std::array<uint32_t,4>;
uint32_t get(std::istream& in){uint32_t x;in.read(reinterpret_cast<char*>(&x),4);if(!in)throw std::runtime_error("truncated vector");return x;}
template<size_t N>std::array<uint32_t,N> get_array(std::istream& in){std::array<uint32_t,N>x;for(auto&w:x)w=get(in);return x;}
struct Event {uint32_t kind;State state;std::array<uint32_t,6> values;};
int signed10(unsigned value){return (value&32768)?int(value)-65536:int(value);}
int main(int argc,char**argv){try{
    if(argc<4)throw std::runtime_error("vectors.bin limit receipt.tsv [trace.vcd]");
    std::ifstream input(argv[1],std::ios::binary);if(!input)throw std::runtime_error("missing vectors");
    unsigned total=get(input);
    unsigned first=std::getenv("TRIAL_START")?std::stoul(std::getenv("TRIAL_START")):0;
    if(first>=total)throw std::runtime_error("trial offset out of range");
    unsigned count=std::min(total-first,static_cast<unsigned>(std::stoul(argv[2])));
    std::ofstream receipt(argv[3]);
    auto context=std::make_unique<VerilatedContext>();context->commandArgs(argc,argv);
    bool tracing=argc>4;context->traceEverOn(tracing);
    uint64_t period_ps=std::getenv("CLOCK_PERIOD_PS")?std::stoull(std::getenv("CLOCK_PERIOD_PS")):100000;
    if(period_ps%2)throw std::runtime_error("odd clock period");
    auto dut=std::make_unique<Vchimera_solver>(context.get());
    auto trace=std::make_unique<Trace>();
    if(tracing){dut->trace(trace.get(),99);trace->open(argv[4]);}
    uint64_t cycles=0;
    auto evaluate=[&](){dut->eval();if(tracing)trace->dump(context->time());};
    auto tick=[&](){dut->clk=0;evaluate();context->timeInc(period_ps/2);dut->clk=1;evaluate();context->timeInc(period_ps/2);dut->clk=0;dut->eval();++cycles;};
    auto state=[&](){State x;for(int j=0;j<4;j++)x[j]=dut->state_read[j];return x;};
    auto witness=[&](){State x;for(int j=0;j<4;j++)x[j]=dut->witness[j];return x;};
    receipt<<"trial\tsetup_begin\tsearch_begin\tend\tsuccess\tfinal_success\tsweeps\tbest_cut\tfinal_cut\tfirst_exact_sweep\tlocal_words\tvisits\tfired_cycles\tevents\n";
    for(unsigned k=0;k<first+count;k++){
        unsigned trial=get(input);auto seeds=get_array<128>(input);auto initial=get_array<4>(input);auto expected=get_array<9>(input);
        auto final=get_array<4>(input);auto expected_witness=get_array<4>(input);
        unsigned n=get(input);std::vector<Event>events(n);
        for(auto&e:events){e.kind=get(input);e.state=get_array<4>(input);e.values=get_array<6>(input);}
        if(k<first)continue;
        uint64_t setup=cycles;
        dut->rst=1;dut->start=0;dut->seed_we=0;dut->init_we=0;tick();tick();dut->rst=0;
        dut->seed_we=1;for(int i=0;i<128;i++){dut->seed_addr=i;dut->data_in=seeds[i];tick();}dut->seed_we=0;
        dut->init_we=1;for(int j=0;j<4;j++){dut->init_word=j;dut->data_in=initial[j];tick();}dut->init_we=0;
        dut->start=1;tick();dut->start=0;uint64_t begin=cycles;unsigned checked=0;
        while(!dut->done){
            dut->eval();unsigned event=dut->event_out;
            bool servicing=dut->phase_out==2;
            auto before=state();
            std::array<uint32_t,3> before_counts{dut->local_words,dut->node_visits,dut->fired_cycles};
            tick();
            // Serving an RNG request must not expose a partial color update.
            if(servicing && dut->phase_out==2 && (before!=state() || before_counts!=std::array<uint32_t,3>{dut->local_words,dut->node_visits,dut->fired_cycles}))
                throw std::runtime_error("state or counters changed before color commit");
            if(event){
                std::array<uint32_t,6> values{uint32_t(signed10(dut->final_cut)),uint32_t(signed10(dut->best_cut)),dut->local_words,dut->node_visits,dut->fired_cycles,dut->first_exact_sweep};
                if(checked>=events.size()||events[checked].kind!=event||events[checked].state!=state()||events[checked].values!=values){
                    std::cerr<<"got ";for(auto w:values)std::cerr<<w<<",";std::cerr<<" expected ";if(checked<events.size())for(auto w:events[checked].values)std::cerr<<w<<",";std::cerr<<"\n";
                    throw std::runtime_error("semantic mismatch trial="+std::to_string(trial)+" event="+std::to_string(checked)+" kind="+std::to_string(event));
                }
                checked++;
            }
            // Two color updates per sweep: at most 32 service cycles plus score.
            if(cycles-begin>2ULL*13118*(32+1)+2)throw std::runtime_error("timeout");
        }
        uint64_t end=cycles;
        std::array<uint32_t,9> got{dut->success,dut->final_success,dut->sweeps,uint32_t(signed10(dut->best_cut)),uint32_t(signed10(dut->final_cut)),dut->first_exact_sweep,dut->local_words,dut->node_visits,dut->fired_cycles};
        if(got!=expected||state()!=final||witness()!=expected_witness||checked!=events.size())throw std::runtime_error("final mismatch");
        receipt<<trial<<'\t'<<setup<<'\t'<<begin<<'\t'<<end;for(auto w:got)receipt<<'\t'<<w;receipt<<'\t'<<checked<<'\n';receipt.flush();
        std::cout<<"PASS "<<trial<<" cycles="<<end-begin<<" events="<<checked<<std::endl;
    }
    dut->final();if(tracing)trace->close();std::cout<<"ALL_PASS "<<count<<std::endl;
}catch(const std::exception&e){std::cerr<<e.what()<<std::endl;return 1;}}
