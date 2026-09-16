#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <array>
#include <cassert>
#include <fstream>
#include <iostream>
#include <bitset>
using State=std::bitset<288>;
struct Reference {
 int J[288][288],field[288],spin[288],cached_q[288]={},age[288]={};bool valid[288]={};
 int8_t qrom[131072];uint32_t thresholds[256],history[288]={};
 uint32_t rng,seed,words=0,fresh=0,reuse=0,updates=0,causes[4]={},first=0xffffffff;
 State bits=0,initial=0,best_bits=0;int energy,best,target,mode,q,raw;uint32_t consumed;bool take;
 uint32_t word(){for(int k=0;k<32;k++)rng=(rng>>1)^((rng&1)?0x80200003u:0);words++;return rng;}
 int score(State state){int e=0;for(int i=0;i<288;i++)for(int j=i+1;j<288;j++)e-=J[i][j]*((state[i]!=state[j])?-1:1);return e;}
 Reference(uint32_t s,int m,int t):rng(s?s:0xa5c36efe),seed(s),target(t),mode(m){
  unsigned v;FILE*f=fopen("weights.hex","r");assert(f);for(int i=0;i<82944;i++){assert(fscanf(f,"%x",&v)==1);J[i/288][i%288]=v<8?v:int(v)-16;}fclose(f);
  f=fopen("quantization_rom.hex","r");for(auto &x:qrom){assert(fscanf(f,"%x",&v)==1);x=v;}fclose(f);
  f=fopen("threshold_rom.hex","r");for(auto &x:thresholds){assert(fscanf(f,"%x",&v)==1);x=v;}fclose(f);
  for(int i=0;i<288;i++){int b=word()&1;bits|=State(b)<<i;spin[i]=2*b-1;}
  initial=best_bits=bits;energy=best=score(bits);if(best==target)first=0;
  for(int i=0;i<288;i++){field[i]=0;for(int j=0;j<288;j++)field[i]+=J[i][j]*spin[j];}
 }
 void step(){int node=updates%288,sweep=updates/288;raw=field[node];q=qrom[sweep*128+(raw&127)];
  bool flags[]={!valid[node],int(bits[node])!=(q>=0),q!=cached_q[node],age[node]>=2};take=!mode||flags[0]||flags[1]||flags[2]||flags[3];
  if(take){consumed=word();fresh++;history[node]=consumed;cached_q[node]=q;age[node]=0;valid[node]=1;for(int i=0;i<4;i++)causes[i]+=flags[i];}
  else{consumed=history[node];reuse++;age[node]++;}
  int b=q>=0?consumed<thresholds[q&255]:consumed>thresholds[q&255],old=spin[node];
  if(b!=int(bits[node])){energy+=2*old*field[node];spin[node]=-old;bits^=State(1)<<node;for(int j=0;j<288;j++)field[j]-=2*old*J[j][node];}
  updates++;if(energy<best){best=energy;best_bits=bits;}if(energy==target&&first==0xffffffff)first=updates;
 }
 void output(uint32_t cycles=0){
  std::cout<<seed<<","<<mode;for(State s:{initial,bits,best_bits})for(int k=0;k<9;k++)std::cout<<","<<uint32_t(((s>>(32*k)) & State(0xffffffffu)).to_ulong());
  std::cout<<","<<energy<<","<<best<<","<<updates<<","<<words<<","<<reuse<<","<<fresh<<","<<rng<<","<<first<<","<<cycles<<"\n";
 }
};
