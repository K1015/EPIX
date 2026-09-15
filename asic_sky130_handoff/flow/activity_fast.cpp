// Accumulate exact switching counts over search and initialization windows.
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
using Time = int64_t;
struct Windows {
    std::vector<Time> begin, end, prefix{0};
    Time total() const { return prefix.back(); }
    std::pair<Time,bool> at(Time t) const {
        auto n = std::upper_bound(begin.begin(), begin.end(), t) - begin.begin();
        if (!n) return {0,false};
        size_t i = n-1;
        return {prefix[i] + std::min(t,end[i])-begin[i], t<end[i]};
    }
};
struct Target {int id, bit;};
struct Signal {
    int width;
    std::string value;
    std::vector<Target> targets;
    std::array<Time,2> last{0,0};
    std::array<std::vector<Time>,2> toggles, high, unknown;
    Signal(int w): width(w),value(w,'x') {
        for(int k=0;k<2;k++){toggles[k].resize(w);high[k].resize(w);unknown[k].resize(w);}
    }
    void account(const std::array<Time,2>& active, const std::array<bool,2>& inside, const std::string* next){
        for(int k=0;k<2;k++){
            Time dt=active[k]-last[k];
            for(int b=0;b<width;b++){
                char old=value[b];
                if(old=='1') high[k][b]+=dt;
                if(old=='x'||old=='z') unknown[k][b]+=dt;
                if(next && (*next)[b]!=old && inside[k]){
                    if(old=='x'||old=='z'||(*next)[b]=='x'||(*next)[b]=='z'){
                        std::cerr<<"Unknown transition in active window\n";std::exit(2);
                    }
                    toggles[k][b]++;
                }
            }
            last[k]=active[k];
        }
        if(next)value=*next;
    }
};
static uint64_t decode(const std::string &code) {
    uint64_t result=0;
    for (unsigned char c: code) { assert(c>=33 && c<=126); result=result*94+(c-32); }
    return result;
}
int main(int argc,char**argv){
    assert(argc==4);
    std::ios::sync_with_stdio(false);std::cin.tie(nullptr);
    std::unordered_map<std::string,std::vector<Target>> selected;
    std::ifstream targets(argv[1]);std::string line;
    while(std::getline(targets,line)){
        std::istringstream row(line);std::string path;int id,bit;
        row>>id>>bit>>path;selected[path].push_back({id,bit});
    }
    std::array<Windows,2> windows;
    std::ifstream ranges(argv[2]);int which;Time a,b;
    while(ranges>>which>>a>>b){
        assert(a<=b);if(a==b)continue;
        auto &w=windows[which];assert(w.end.empty()||a>=w.end.back());
        w.begin.push_back(a);w.end.push_back(b);w.prefix.push_back(w.total()+b-a);
    }
    std::unordered_map<std::string,int> codes;
    std::vector<Signal> signals;std::vector<std::string> scopes;
    bool time_ok=false;
    while(std::getline(std::cin,line)){
        std::istringstream row(line);std::string keyword;row>>keyword;
        if(keyword=="$scope"){
            std::string kind,name;row>>kind>>name;
            if(!name.empty()&&name[0]=='\\')name.erase(0,1);
            scopes.push_back(name);
        } else if(keyword=="$upscope")scopes.pop_back();
        else if(keyword=="$timescale"){
            std::string token,scale;while(row>>token)scale+=token;
            while(scale.find("$end")==std::string::npos){
                if(!std::getline(std::cin,line)){
                    std::cerr<<"Truncated VCD timescale declaration\n";return 2;
                }
                std::istringstream r(line);while(r>>token)scale+=token;
            }
            assert(scale=="1ps$end");time_ok=true;
        } else if(keyword=="$var"){
            std::string kind,code,name;int width;row>>kind>>width>>code>>name;
            if(!name.empty()&&name[0]=='\\')name.erase(0,1);
            std::string path;for(size_t n=0;n<scopes.size();n++){if(n==0&&scopes[n]=="TOP")continue;path+=scopes[n]+"/";}path+=name;
            auto found=selected.find(path);
            if(found==selected.end())continue;
            auto inserted=codes.emplace(code,signals.size());
            if(inserted.second)signals.emplace_back(width);
            auto &signal=signals[inserted.first->second];assert(signal.width==width);
            for(auto t:found->second){assert(t.bit<width);signal.targets.push_back(t);}
        } else if(keyword=="$enddefinitions")break;
    }
    assert(time_ok);
    uint64_t maximum=0;
    for (const auto &entry:codes) maximum=std::max(maximum,decode(entry.first));
    assert(maximum < 20000000);
    std::vector<int> direct(maximum+1,-1);
    for (const auto &entry:codes) {
        auto index=decode(entry.first); assert(direct[index]==-1); direct[index]=entry.second;
    }
    std::array<Time,2> active{0,0};std::array<bool,2> inside{false,false};
    while(std::getline(std::cin,line)){
        if(line.empty())continue;
        if(line[0]=='#'){
            Time t=std::stoll(line.substr(1));
            for(int k=0;k<2;k++){auto p=windows[k].at(t);active[k]=p.first;inside[k]=p.second;}
            continue;
        }
        if(line[0]=='$'||line[0]=='r')continue;
        std::string code,value;
        if(line[0]=='b'){
            auto space=line.find(' ');if(space==std::string::npos)continue;
            code=line.substr(space+1);value=line.substr(1,space-1);
        }else{code=line.substr(1);value=line.substr(0,1);}
        auto index=decode(code);
        if(index>=direct.size() || direct[index]<0)continue;
        auto &s=signals[direct[index]];
        if(value.size()<size_t(s.width))value.insert(0,s.width-value.size(),value[0]=='x'||value[0]=='z'?value[0]:'0');
        std::reverse(value.begin(),value.end());value.resize(s.width);
        s.account(active,inside,&value);
    }
    std::ofstream out(argv[3]);
    active={windows[0].total(),windows[1].total()};inside={false,false};
    for(auto &s:signals){
        s.account(active,inside,nullptr);
        for(auto t:s.targets){
            out<<t.id;
            for(int k=0;k<2;k++)out<<'\t'<<s.toggles[k][t.bit]<<'\t'<<s.high[k][t.bit]<<'\t'<<s.unknown[k][t.bit];
            out<<'\n';
        }
    }
}
