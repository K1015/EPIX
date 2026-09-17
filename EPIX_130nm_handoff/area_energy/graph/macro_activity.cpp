// Count SRAM clock edges by enable and write state.
// Window 0 is search; window 1 is setup.
#include <array>
#include <map>
#include <string>
#include <fstream>
#include <cstdint>
using Counts=std::array<std::array<uint64_t,8>,2>;
static std::map<std::string,Counts> counts;
static int window=-1;
extern "C" void a1_set_window(int w){window=w;}
extern "C" void a1_macro_init(const char*name){counts.emplace(name,Counts{});}
extern "C" void a1_macro_edge(const char*name,int rising,int ce,int we){if(window>=0)counts[name][window][(rising?0:4)+2*ce+we]++;}
extern "C" void a1_write_counts(const char*path){std::ofstream f(path);f<<"instance\twindow\trise_ce0_we0\trise_ce0_we1\trise_ce1_we0\trise_ce1_we1\tfall_ce0_we0\tfall_ce0_we1\tfall_ce1_we0\tfall_ce1_we1\n";for(auto&entry:counts)for(int w=0;w<2;w++){f<<entry.first<<'\t'<<w;for(auto c:entry.second[w])f<<'\t'<<c;f<<'\n';}}
