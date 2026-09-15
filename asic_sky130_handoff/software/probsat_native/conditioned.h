#pragma once
#include <stdint.h>
#include <math.h>
#include <assert.h>
// Positive 16-bit categorical masses, deterministic largest-remainder rounding.
static void quantize(const double p[3],unsigned w[3]){
 double sum=p[0]+p[1]+p[2],fraction[3];unsigned total=0;
 assert(sum>0);
 for(int i=0;i<3;i++){double x=65533*p[i]/sum;unsigned k=(unsigned)floor(x);w[i]=1+k;fraction[i]=x-k;total+=w[i];}
 assert(total<=65536 && total>=65534);
 while(total<65536){int best=0;for(int j=1;j<3;j++)if(fraction[j]>fraction[best])best=j;w[best]++;fraction[best]=-1;total++;}
}
static unsigned conditioned(uint64_t *value,uint64_t *range,const unsigned w[3],uint32_t (*source)(void)){
 assert(w[0]+w[1]+w[2]==65536);
 for(;;){
  assert(*range>0 && *value<*range);
  if(*range<65536){uint32_t word=source();*value=(*value<<31)|word;*range<<=31;}
  uint64_t unit=*range/65536,usable=unit*65536;
  if(*value>=usable){*value-=usable;*range-=usable;continue;}
  uint64_t offset=0;
  for(unsigned i=0;i<3;i++){uint64_t width=unit*w[i];if(*value<offset+width){*value-=offset;*range=width;return i;}offset+=width;}
 }
}
