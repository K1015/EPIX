#include "Vcorrected_solver.h"
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
using Words=std::array<uint32_t,96>;
struct Event {uint32_t kind;Words state;};
uint32_t get(std::istream& in){uint32_t x;in.read(reinterpret_cast<char*>(&x),4);if(!in)throw std::runtime_error("truncated vector");return x;}
Words get_state(std::istream& in){Words x;for(auto& w:x)w=get(in);return x;}
int main(int argc,char**argv){
 try {
    if(argc<4)throw std::runtime_error("vectors.bin limit receipt.tsv [trace.vcd]");
    std::ifstream input(argv[1],std::ios::binary);if(!input)throw std::runtime_error("missing vectors");
    unsigned total=get(input);
    unsigned first=std::getenv("TRIAL_START")?std::stoul(std::getenv("TRIAL_START")):0;
    if(first>=total)throw std::runtime_error("trial offset out of range");
    unsigned count=std::min(total-first,static_cast<unsigned>(std::stoul(argv[2])));
    std::ofstream receipt(argv[3]);
    auto context=std::make_unique<VerilatedContext>();context->commandArgs(argc,argv);
    bool tracing=argc>4; context->traceEverOn(tracing);
    uint64_t period_ps=std::getenv("CLOCK_PERIOD_PS")?std::stoull(std::getenv("CLOCK_PERIOD_PS")):100000;
    if(period_ps%2)throw std::runtime_error("odd clock period");
    auto dut=std::make_unique<Vcorrected_solver>(context.get());
    auto trace=std::make_unique<Trace>();
    if(tracing){dut->trace(trace.get(),99);trace->open(argv[4]);}
    uint64_t cycles=0;
    auto evaluate=[&](){dut->eval();if(tracing)trace->dump(context->time());};
    auto tick=[&](){dut->clk=0;evaluate();context->timeInc(period_ps/2);dut->clk=1;evaluate();context->timeInc(period_ps/2);dut->clk=0;dut->eval();++cycles;};
    auto state=[&](){Words a;for(int r=0;r<24;r++){dut->read_bank=r;dut->eval();for(int j=0;j<4;j++)a[r*4+j]=dut->state_read[j];}dut->read_bank=0;dut->eval();return a;};
    receipt<<"trial\tsetup_begin\tsearch_begin\tend\tsuccess\tsweeps\tlocal_words\tswap_words\ticm_words\tvisits\tevents\n";
    dut->rst=1;dut->start=0;dut->seed_we=0;dut->init_we=0;dut->read_bank=0;dut->sweep_limit=256;tick();tick();
    for(unsigned k=0;k<first+count;k++){
        unsigned trial=get(input);std::array<uint32_t,130> seeds;for(auto&w:seeds)w=get(input);
        Words initial=get_state(input);std::array<uint32_t,7> expected;for(auto&w:expected)w=get(input);
        Words final=get_state(input);unsigned n=get(input);std::vector<Event> events(n);
        for(auto&e:events){e.kind=get(input);e.state=get_state(input);}
        if(k<first)continue;
        uint64_t setup=cycles;
        dut->rst=1;dut->start=0;dut->seed_we=0;dut->init_we=0;dut->read_bank=0;dut->sweep_limit=256;tick();tick();
        dut->rst=0;
        dut->seed_we=1;for(int i=0;i<130;i++){dut->seed_addr=i;dut->data_in=seeds[i];tick();}dut->seed_we=0;
        dut->init_we=1;for(int r=0;r<24;r++)for(int j=0;j<4;j++){dut->init_bank=r;dut->init_word=j;dut->data_in=initial[r*4+j];tick();}dut->init_we=0;
        dut->start=1;tick();dut->start=0;uint64_t begin=cycles;unsigned checked=0;
        while(!dut->done){
            dut->eval();unsigned e=dut->event_out;tick();
            if(e){
                if(checked>=events.size()||events[checked].kind!=e||events[checked].state!=state())
                    throw std::runtime_error("semantic state mismatch trial="+std::to_string(trial)+" event="+std::to_string(checked)+" kind="+std::to_string(e)+" cycle="+std::to_string(cycles-begin));
                ++checked;
            }
            if(cycles-begin>2000000)throw std::runtime_error("timeout");
        }
        uint64_t end=cycles;
        int best=(dut->best_cut&512)?static_cast<int>(dut->best_cut)-1024:dut->best_cut;
        std::array<uint32_t,7> got{dut->success,static_cast<uint32_t>(best),dut->sweeps,dut->local_words,dut->swap_words,dut->icm_words,dut->node_visits};
        if(got!=expected || state()!=final || checked!=events.size()){
            std::cerr<<"trial "<<trial<<" got ";for(auto w:got)std::cerr<<w<<",";std::cerr<<" expected ";for(auto w:expected)std::cerr<<w<<",";std::cerr<<"\n";
            throw std::runtime_error("final mismatch");
        }
        receipt<<trial<<'\t'<<setup<<'\t'<<begin<<'\t'<<end<<'\t'<<int(dut->success)<<'\t'<<dut->sweeps<<'\t'<<dut->local_words<<'\t'<<dut->swap_words<<'\t'<<dut->icm_words<<'\t'<<dut->node_visits<<'\t'<<checked<<'\n';receipt.flush();
        if(k%25==0)std::cout<<"PASS "<<trial<<" cycles "<<end-begin<<std::endl;
    }
    dut->final();if(tracing)trace->close();std::cout<<"ALL_PASS "<<count<<std::endl;
 }catch(const std::exception&e){std::cerr<<e.what()<<std::endl;return 1;}
}
