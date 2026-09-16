#include "Vmaxcut26_axi.h"
#include "verilated.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cassert>
int main(int argc,char**argv){
 Verilated::commandArgs(argc,argv);Vmaxcut26_axi d;
 auto tick=[&](){d.s_axi_aclk=0;d.eval();d.s_axi_aclk=1;d.eval();d.s_axi_aclk=0;d.eval();};
 d.s_axi_aresetn=0;d.s_axi_bready=1;d.s_axi_rready=0;d.s_axi_awvalid=0;d.s_axi_wvalid=0;d.s_axi_arvalid=0;tick();tick();d.s_axi_aresetn=1;tick();
 auto write=[&](uint32_t addr,uint32_t value){d.s_axi_awaddr=addr;d.s_axi_wdata=value;d.s_axi_wstrb=15;d.s_axi_awvalid=1;d.s_axi_wvalid=1;tick();d.s_axi_awvalid=0;d.s_axi_wvalid=0;for(int i=0;!d.s_axi_bvalid;i++){assert(i<10);tick();}assert(d.s_axi_bresp==0);tick();};
 auto read=[&](uint32_t addr){d.s_axi_araddr=addr;d.s_axi_arvalid=1;tick();d.s_axi_arvalid=0;for(int i=0;!d.s_axi_rvalid;i++){assert(i<10);tick();}assert(d.s_axi_rresp==0);uint32_t v=d.s_axi_rdata;d.s_axi_rready=1;tick();d.s_axi_rready=0;return v;};
 assert(read(4)==0x60000&&read(0x14)==288);write(0xc,strtoul(argv[1],0,0));write(0x60,atoi(argv[2]));write(8,1);
 for(int i=0;;i++){assert(i<200000);for(int j=0;j<1024;j++)tick();uint32_t status=read(0x10);assert(!(status&12));if(status==2)break;}
 for(int i=0;i<32;i++)tick();assert(read(0x200)==12);
 for(int f=0;f<12;f++){printf("%d",f);for(int k=0;k<16;k++)printf(",%u",read(0x400+f*64+k*4));printf("\n");}
 fprintf(stderr,"cycles=%u words=%u final_energy=%d\n",read(0x40),read(0x38),int32_t(read(0x28)));
}
