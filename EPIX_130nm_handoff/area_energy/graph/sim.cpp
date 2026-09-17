#include "Vdut.h"
#include "verilated.h"
#if VM_TRACE_FST
#include "verilated_fst_c.h"
using Trace=VerilatedFstC;
#else
#include "verilated_vcd_c.h"
using Trace=VerilatedVcdC;
#endif
#include <array>
#include <vector>
#include <random>
#include <iostream>
#include <fstream>
#include <memory>
#include <stdexcept>
#include <algorithm>
#include <set>
#include <cstdlib>
#include "case.hpp"
#ifdef A1_POWER
extern "C" void a1_set_window(int);
extern "C" void a1_write_counts(const char*);
#endif
using State=std::array<uint32_t,N/32>;
using Bank=std::array<State,R>;
struct Event {unsigned kind;Bank states;};
bool bit(const State&s,int i){return (s[i/32]>>(i%32))&1;}
void setbit(State&s,int i,bool v){s[i/32]=(s[i/32]&~(1u<<(i%32)))|(uint32_t(v)<<(i%32));}
uint32_t advance(uint32_t x){for(int k=0;k<32;k++)x=(x<<1)|(1^((x>>31)^(x>>21)^(x>>1)^x)&1);return x;}
int score(const State&s){int z=0;for(auto&e:edges)if(bit(s,e[0])!=bit(s,e[1]))z+=e[2];return z;}
int raw(const State&s,int i){int z=0;for(auto&e:adj[i])z-=e.second*(bit(s,e.first)?1:-1);return z;}
struct Model {
 Bank initial,states;std::array<std::array<uint32_t,N>,R> seeds,rng;
 std::array<uint32_t,2> auxiliary_seeds,auxiliary_rng;
 std::array<std::array<int,N>,R> saved{},remaining{};
 std::array<std::array<bool,N>,R> valid{};
 std::vector<Event> events;
 uint64_t words=0,swapwords=0,icmwords=0,visits=0,reads=0;
 int best=-1000000,sweeps=0;bool success=false;
 Model(unsigned trial){
  std::mt19937 setup(20260917u+N*1000u+FAMILY*1000000u+trial);
  std::set<uint32_t> used;
  auto draw=[&](){uint32_t x;do{x=setup();}while(x==0xffffffff||!used.insert(x).second);return x;};
  for(auto&row:seeds)for(auto&x:row)x=draw();
  for(auto&x:auxiliary_seeds)x=draw();
  rng=seeds;auxiliary_rng=auxiliary_seeds;
  for(auto&s:initial)for(auto&x:s)x=setup();states=initial;
 }
 void event(unsigned k){events.push_back({k,states});}
 void update(int r,int color,int beta){State next=states[r];for(int i=0;i<N;i++)if(colors[i]==color){
    int f=raw(states[r],i);if(!FAMILY)f*=beta;
    bool positive=f>=0;
    bool refresh=!EPIX||!remaining[r][i]||bit(states[r],i)!=positive||saved[r][i]!=f;
    visits++;reads++;valid[r][i]=true;
    if(refresh){auto&g=rng[r][i];g=advance(g);words++;
      uint32_t threshold;
      if(FAMILY)threshold=local_lut[beta*17+f+8];
      else threshold=local_lut[std::min((4*std::abs(f)+NORMALIZER/2)/NORMALIZER,127)];
      setbit(next,i,positive?threshold>g:g>threshold);saved[r][i]=f;remaining[r][i]=AGE;
    }else remaining[r][i]--;
 }states[r]=next;}
 void note(const State&s,bool scan=true){if(scan)reads+=N;int x=score(s);if(x>TARGET)throw std::runtime_error("cut exceeds certified target");best=std::max(best,x);success|=x>=TARGET;}
 void run(int budget){
  for(auto&s:states)note(s);event(1);
  if(!FAMILY){for(int sw=0;sw<budget;sw++){int beta=1+sw/937;for(int c=0;c<2;c++){update(0,c,beta);note(states[0],false);event(c+2);}sweeps++;}return;}
  if(success||budget==0)return;
  for(sweeps=1;sweeps<=budget;sweeps++){
   for(int c=0;c<4;c++){for(int r=0;r<R;r++){update(r,c,r%(R/2));note(states[r],false);}event(2);if(success)return;}
   if(sweeps%4==0){for(int t=ICM_FIRST;t<R/2;t++){
      auto&s=states[t];auto&q=states[t+R/2];std::vector<int>d;for(int i=0;i<N;i++)if(bit(s,i)!=bit(q,i))d.push_back(i);
      auxiliary_rng[1]=advance(auxiliary_rng[1]);icmwords++;
      if(d.empty()||d.size()>N/2)continue;
      int seed=d[auxiliary_rng[1]%d.size()];std::array<bool,N>cl{};cl[seed]=true;std::vector<int>queue{seed};
      for(size_t k=0;k<queue.size();k++)for(auto&v:adj[queue[k]])if(!cl[v.first]&&bit(s,v.first)!=bit(q,v.first)){cl[v.first]=true;queue.push_back(v.first);}
      std::array<bool,N>invalid=cl;
      for(int i:queue)for(auto&v:adj[i])invalid[v.first]=true;
      for(int i=0;i<N;i++){if(cl[i]){setbit(s,i,!bit(s,i));setbit(q,i,!bit(q,i));}if(invalid[i]){remaining[t][i]=remaining[t+R/2][i]=0;valid[t][i]=valid[t+R/2][i]=false;}}
      note(s);note(q);event(3);if(success)return;
   }}
   for(int copy=0;copy<2;copy++)for(int left=(sweeps-1)&1;left<R/2-1;left+=2){
     int a=copy*(R/2)+left,b=a+1,gap=score(states[b])-score(states[a]);
     auxiliary_rng[0]=advance(auxiliary_rng[0]);swapwords++;
     if(gap<=0||auxiliary_rng[0]<swap_lut[left][gap]){std::swap(states[a],states[b]);remaining[a].fill(0);remaining[b].fill(0);valid[a].fill(false);valid[b].fill(false);event(4);}
   }
   if(sweeps==budget)return;
  }
 }
};
int main(int argc,char**argv){try{
 if(argc<5)throw std::runtime_error("trial count budget receipt.tsv [trace.fst]");
 unsigned first=std::stoul(argv[1]),count=std::stoul(argv[2]);int budget=std::stoi(argv[3]);
 const uint64_t period=200000;
 auto ctx=std::make_unique<VerilatedContext>();ctx->threads(1);ctx->commandArgs(argc,argv);ctx->traceEverOn(argc>5);
 auto dut=std::make_unique<Vdut>(ctx.get());auto trace=std::make_unique<Trace>();
 if(argc>5){dut->trace(trace.get(),99);trace->open(argv[5]);}
 uint64_t cycles=0;
 auto eval=[&](){dut->eval();if(argc>5)trace->dump(ctx->time());};
 auto tick=[&](){dut->clk=0;eval();ctx->timeInc(period/2);dut->clk=1;eval();ctx->timeInc(period/2);dut->clk=0;dut->eval();cycles++;};
 auto get_state=[&](){Bank z;for(int r=0;r<R;r++){
#if FAMILY
   dut->read_bank=r;dut->eval();
#endif
   for(int j=0;j<N/32;j++){
#if N == 32
    z[r][j]=dut->state_read;
#else
    z[r][j]=dut->state_read[j];
#endif
   }
 }
#if FAMILY
 dut->read_bank=0;dut->eval();
#endif
 return z;};
 std::ofstream receipt(argv[4]);receipt<<"trial\tsetup_begin\tsearch_begin\tend\tsuccess\tsweeps\tbest_cut\tlocal_words\tswap_words\ticm_words\tvisits\tevents\tcomplete\tcoefficient_reads_model\n";
#ifdef A1_POWER
 // Set known signals before measuring setup.
 dut->rst=1;dut->start=0;dut->seed_we=0;dut->init_we=0;dut->cfg_we=0;dut->test_enable=0;tick();tick();
#endif
 for(unsigned trial=first;trial<first+count;trial++){
   Model model(trial);model.run(budget);size_t checked=0;
   auto setup=cycles;
#ifdef A1_POWER
   a1_set_window(1);
#endif
   dut->rst=1;dut->start=0;dut->seed_we=0;dut->init_we=0;dut->cfg_we=0;dut->test_enable=0;tick();tick();dut->rst=0;
#if FAMILY
   dut->sweep_limit=budget;dut->read_bank=0;
#endif
   // Load coefficients through the SRAM port. RNG state is separate.
   dut->start=1;tick();dut->start=0;
   if(dut->phase_out!=0)throw std::runtime_error("accepted start before coefficients");
   dut->cfg_we=1;
   for(int i=0;i<N;i++){dut->cfg_addr=i;dut->data_in=coefficient_rows[i];tick();}
   dut->cfg_we=0;dut->eval();
   if(!dut->configured)throw std::runtime_error("coefficient initialization incomplete");
   dut->seed_we=1;
   for(int r=0;r<R;r++)for(int i=0;i<N;i++){dut->seed_addr=r*N+i;dut->data_in=model.seeds[r][i];tick();}
#if FAMILY
   for(int i=0;i<2;i++){dut->seed_addr=R*N+i;dut->data_in=model.auxiliary_seeds[i];tick();}
#endif
   dut->seed_we=0;
   dut->init_we=1;for(int r=0;r<R;r++)for(int j=0;j<N/32;j++){
#if FAMILY
    dut->init_bank=r;
#endif
    dut->init_word=j;dut->data_in=model.initial[r][j];tick();
   }dut->init_we=0;dut->start=1;tick();dut->start=0;auto begin=cycles;
#ifdef A1_POWER
   a1_set_window(0);
#endif
   while(!dut->done){dut->eval();unsigned ev=dut->event_out;unsigned oldphase=dut->phase_out;
     tick();
     if(ev){Bank actual=get_state();
      if(checked>=model.events.size()||ev!=model.events[checked].kind||actual!=model.events[checked].states){
       std::cerr<<"Mismatch trial="<<trial<<" event="<<checked<<" kind="<<ev<<" phase="<<oldphase<<" cycle="<<cycles-begin<<"\n";
       if(checked<model.events.size())for(int r=0;r<R;r++)for(int j=0;j<N/32;j++)if(actual[r][j]!=model.events[checked].states[r][j])std::cerr<<" replica="<<r<<" word="<<j<<" got="<<std::hex<<actual[r][j]<<" expected="<<model.events[checked].states[r][j]<<std::dec<<"\n";
       throw std::runtime_error("semantic state mismatch");}
      checked++;
#if !FAMILY
      if(budget<13118&&checked==model.events.size())break;
#endif
     }
     if(cycles-begin>uint64_t(budget+1)*R*8192+100000)throw std::runtime_error("cycle watchdog");
   }
   int best=(dut->best_cut&(1u<<(SCORE_BITS-1)))?int(dut->best_cut)-(1u<<SCORE_BITS):dut->best_cut;
   if(checked!=model.events.size()||get_state()!=model.states||best!=model.best||dut->local_words!=model.words||dut->node_visits!=model.visits)throw std::runtime_error("final values mismatch");
#if FAMILY
   if(dut->swap_words!=model.swapwords||dut->icm_words!=model.icmwords||dut->sweeps!=model.sweeps||bool(dut->success)!=model.success)throw std::runtime_error("scheduler counters mismatch");
#endif
   receipt<<trial<<'\t'<<setup<<'\t'<<begin<<'\t'<<cycles<<'\t'<<model.success<<'\t'<<model.sweeps<<'\t'<<best<<'\t'<<model.words<<'\t'<<model.swapwords<<'\t'<<model.icmwords<<'\t'<<model.visits<<'\t'<<checked<<'\t'<<int(dut->done)<<'\t'<<model.reads<<'\n';receipt.flush();
   std::cout<<"PASS "<<trial<<" cycles="<<cycles-begin<<" events="<<checked<<" words="<<model.words<<std::endl;
 }
 if(argc>5){eval();trace->close();}
#ifdef A1_POWER
 a1_set_window(-1);a1_write_counts((std::string(argv[4])+".macros.tsv").c_str());
#endif
 dut->final();std::cout<<"ALL_PASS "<<count<<std::endl;
}catch(const std::exception&e){std::cerr<<e.what()<<std::endl;return 1;}}
