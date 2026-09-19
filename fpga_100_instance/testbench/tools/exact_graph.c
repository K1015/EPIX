/* Exact integer branch-and-bound for zero-field Ising graphs, N <= 32.
 * Maximizes S=sum(Jij*si*sj), hence Emin=-Smax. For each partial assignment,
 * S <= assigned_score + sum(abs(assigned_field[j])) + sum(abs(unassigned_Jij)).
 * The suffix bound is tightened by disjoint frustrated triangles: each must
 * lose at least twice its smallest absolute edge relative to that edge bound.
 * Fixing s0=+1 removes only global inversion symmetry. No floating arithmetic.
 * Input: N followed by N*N signed integer couplings. Output: JSON certificate.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <limits.h>
static int n, jmat[32][32], order[32], spins[32], fields[32], suffix[33];
static int best=INT_MIN;
static uint32_t witness;
static uint64_t nodes;
static uint32_t state_bits(void) {
    uint32_t x=0;
    for(int i=0;i<n;i++) if(spins[i]>0) x|=UINT32_C(1)<<order[i];
    return x;
}
static void search(int k,int score) {
    nodes++;
    int upper=score+suffix[k];
    for(int i=k;i<n;i++) upper+=abs(fields[i]);
    if(upper<=best) return;
    if(k==n) {best=score;witness=state_bits();return;}
    int first=fields[k]<0?-1:1;
    for(int branch=0;branch<2;branch++) {
        int s=branch?-first:first;
        spins[k]=s;
        for(int i=k+1;i<n;i++) fields[i]+=s*jmat[k][i];
        search(k+1,score+s*fields[k]);
        for(int i=k+1;i<n;i++) fields[i]-=s*jmat[k][i];
    }
}
int main(void) {
    if(scanf("%d",&n)!=1 || n<1 || n>32) return 2;
    int original[32][32],degree[32]={0};
    for(int i=0;i<n;i++) for(int j=0;j<n;j++) {
        if(scanf("%d",&original[i][j])!=1 || abs(original[i][j])>1000) return 2;
        degree[i]+=abs(original[i][j]);
    }
    for(int i=0;i<n;i++) {order[i]=i;for(int j=0;j<n;j++)
        if(original[i][j]!=original[j][i] || (i==j && original[i][j])) return 2;}
    for(int i=0;i<n;i++) for(int j=i+1;j<n;j++) if(degree[order[j]]>degree[order[i]]) {
        int t=order[i];order[i]=order[j];order[j]=t;
    }
    for(int i=0;i<n;i++) for(int j=0;j<n;j++) jmat[i][j]=original[order[i]][order[j]];
    for(int k=0;k<n;k++) {
        int used[32][32]={{0}};
        for(int a=k;a<n;a++) for(int b=a+1;b<n;b++) suffix[k]+=abs(jmat[a][b]);
        for(int a=k;a<n;a++) for(int b=a+1;b<n;b++) for(int c=b+1;c<n;c++) {
            int x=jmat[a][b],y=jmat[b][c],z=jmat[a][c];
            if(x && y && z && ((x<0)+(y<0)+(z<0))%2 && !used[a][b] && !used[b][c] && !used[a][c]) {
                int m=abs(x);if(abs(y)<m)m=abs(y);if(abs(z)<m)m=abs(z);
                suffix[k]-=2*m;used[a][b]=used[b][c]=used[a][c]=1;
            }
        }
    }
    /* Deterministic local ascent supplies lower bounds only, never pruning rules. */
    uint32_t rng=UINT32_C(0x817351ad);
    for(int trial=0;trial<128;trial++) {
        for(int i=0;i<n;i++){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;spins[i]=(rng&1)?1:-1;}
        for(int pass=0;pass<100;pass++) {
            int changed=0;
            for(int i=0;i<n;i++) {
                int h=0;for(int j=0;j<n;j++)h+=jmat[i][j]*spins[j];
                if(spins[i]*h<0){spins[i]=-spins[i];changed=1;}
            }
            if(!changed)break;
        }
        int score=0;for(int i=0;i<n;i++)for(int j=i+1;j<n;j++)score+=jmat[i][j]*spins[i]*spins[j];
        if(score>best){best=score;witness=state_bits();}
    }
    spins[0]=1;for(int i=1;i<n;i++)fields[i]=jmat[0][i];
    search(1,0);
    printf("{\"minimum_ising_energy\":%d,\"lower_bound\":%d,\"witness_state\":%"PRIu32",\"nodes\":%"PRIu64",\"method\":\"complete_integer_branch_and_bound_with_triangle_bound\"}\n",-best,-best,witness,nodes);
    return 0;
}
