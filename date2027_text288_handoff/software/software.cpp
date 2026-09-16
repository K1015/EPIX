#include "graph_reference.hpp"
void frame(std::ofstream& f,Reference&r,int index){
 f<<r.seed<<","<<r.mode<<","<<index;
 for(int k=0;k<9;k++)f<<","<<uint32_t(((r.bits>>(32*k))&State(0xffffffffu)).to_ulong());
 f<<","<<uint32_t(r.energy)<<","<<(175682u+r.updates*614u-33u*r.reuse)<<","<<r.words<<","<<r.updates<<","<<uint32_t(r.best)<<","<<r.reuse<<","<<r.fresh<<"\n";
}
int main(int argc,char**argv){
 std::ifstream seeds(argv[1]);std::ofstream traces(argv[2]);uint32_t seed;
 const int sweeps[]={0,1,2,4,8,16,32,64,128,256,512,1024};
 while(seeds>>std::hex>>seed)for(int mode=0;mode<2;mode++){
  Reference r(seed,mode,-540);int index=0;frame(traces,r,index++);
  while(r.updates<294912){r.step();if(r.updates==uint32_t(sweeps[index]*288)){frame(traces,r,index++);}}
  assert(index==12&&r.score(r.bits)==r.energy);r.output();
 }
}
