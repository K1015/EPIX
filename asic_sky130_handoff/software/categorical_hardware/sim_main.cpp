#include "Vcategorical_solver.h"
#include "verilated.h"
#if VM_TRACE_FST
#include "verilated_fst_c.h"
using Trace = VerilatedFstC;
#else
#include "verilated_vcd_c.h"
using Trace = VerilatedVcdC;
#endif
#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <vector>

using Event = std::array<uint32_t,25>;
static const char* names[25]={"kind","state0","state1","state2","state3","flips",
 "raw_words","reused_visits","refills","initial_draws","num_unsat","rng_state",
 "selected_clause","chosen_index","break0","break1","break2","mass0","mass1",
 "mass2","value_lo","value_hi","range_lo","range_hi","cache_age"};
static uint32_t get(std::istream& s){uint32_t x;s.read(reinterpret_cast<char*>(&x),4);
 if(!s)throw std::runtime_error("truncated vectors");return x;}

int main(int argc,char**argv){try{
 if(argc<4)throw std::runtime_error("vectors.bin count receipt.tsv [trace.vcd]");
 std::ifstream input(argv[1],std::ios::binary);
 if(get(input)!=0x43534154 || get(input)!=1)throw std::runtime_error("bad vector format");
 unsigned total=get(input);
 unsigned first=std::getenv("TRIAL_START")?std::stoul(std::getenv("TRIAL_START")):0;
 unsigned requested=std::stoul(argv[2]);
 if(first>=total || !requested || requested>total-first)throw std::runtime_error("invalid trial range");
 auto context=std::make_unique<VerilatedContext>();context->commandArgs(argc,argv);
 bool tracing=argc>4;context->traceEverOn(tracing);
 auto dut=std::make_unique<Vcategorical_solver>(context.get());
 auto trace=std::make_unique<Trace>();
 if(tracing){dut->trace(trace.get(),99);trace->open(argv[4]);}
 uint64_t period=std::getenv("CLOCK_PERIOD_PS")?std::stoull(std::getenv("CLOCK_PERIOD_PS")):100000;
 if(!period || period%2)throw std::runtime_error("clock period must be positive and even");
 uint64_t cycles=0;
 auto eval=[&](){dut->eval();if(tracing)trace->dump(context->time());};
 auto tick=[&](){dut->clk=0;eval();context->timeInc(period/2);dut->clk=1;eval();
   context->timeInc(period/2);dut->clk=0;dut->eval();++cycles;};
 auto event=[&](){return Event{dut->event_out,dut->assignment[0],dut->assignment[1],
   dut->assignment[2],dut->assignment[3],dut->flips,dut->raw_words,dut->reused_visits,
   dut->refills,dut->initial_draws,dut->num_unsat,dut->rng_state_out,
   dut->selected_clause,dut->chosen_index,dut->break0,dut->break1,dut->break2,
   dut->mass0,dut->mass1,dut->mass2,static_cast<uint32_t>(dut->cache_value),
   static_cast<uint32_t>(dut->cache_value>>32),static_cast<uint32_t>(dut->cache_range),
   static_cast<uint32_t>(dut->cache_range>>32),dut->cache_age};};
 std::ofstream receipt(argv[3]);
 if(!receipt)throw std::runtime_error("cannot write receipt");
 receipt<<"trial\tsetup_begin\tsearch_begin\tend\tsuccess\tflips\traw_words\treused_visits\trefills\tinitial_draws\tevents\n";
 for(unsigned k=0;k<first+requested;k++){
   unsigned trial=get(input),seed=get(input),limit=get(input),success=get(input),count=get(input);
   std::vector<Event> expected(count);for(auto& e:expected)for(auto& x:e)x=get(input);
   if(k<first)continue;
   uint64_t setup=cycles,begin=0;unsigned checked=0;
   dut->rst=1;dut->start=0;dut->seed=seed;dut->flip_limit=limit;tick();tick();dut->rst=0;
   dut->start=1;tick();dut->start=0;
   auto check=[&](){if(!dut->event_out)return;
     if(checked>=count)throw std::runtime_error("extra RTL event");
     auto actual=event();
     // Initial event contains solver state and counters; choice metadata is undefined until a flip.
     unsigned fields=actual[0]==1?12:25;
     for(unsigned j=0;j<fields;j++)if(actual[j]!=expected[checked][j])
       throw std::runtime_error("trial "+std::to_string(trial)+" event "+std::to_string(checked)+
         " "+names[j]+" RTL="+std::to_string(actual[j])+" native="+std::to_string(expected[checked][j]));
     if(actual[0]==1)begin=cycles;++checked;
   };
   check();
   while(!dut->done){tick();check();
     if(cycles-setup>2000ull+(uint64_t(limit)+1)*100000ull)
       throw std::runtime_error("RTL cycle guard exceeded");}
   if(checked!=count || dut->success!=success)throw std::runtime_error("incomplete or wrong final outcome");
   auto actual=event();const auto& last=expected.back();
   for(unsigned j=1;j<=11;j++)if(actual[j]!=last[j])
     throw std::runtime_error(std::string("final mismatch: ")+names[j]);
   receipt<<trial<<'\t'<<setup<<'\t'<<begin<<'\t'<<cycles<<'\t'<<unsigned(dut->success)
    <<'\t'<<dut->flips<<'\t'<<dut->raw_words<<'\t'<<dut->reused_visits<<'\t'<<dut->refills
    <<'\t'<<dut->initial_draws<<'\t'<<checked<<'\n';receipt.flush();
   std::cout<<"PASS trial="<<trial<<" events="<<checked<<" cycles="<<cycles-setup<<std::endl;
 }
 if(tracing)trace->close();dut->final();return 0;
}catch(const std::exception& e){std::cerr<<"FAIL "<<e.what()<<std::endl;return 1;}}
