`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
module corrected_solver #(
    parameter EPIX_ENABLE=`EPIX_MODE,
    parameter RNG_STRIDE=32
)(
    input logic clk, rst, start, seed_we, init_we,
    input logic [15:0] seed_addr,
    input logic cfg_we,test_enable,
    input logic [9:0] cfg_addr,
    output wire cfg_ready,configured,
    input logic [5:0] init_bank, read_bank,
    input logic [4:0] init_word,
    input logic [31:0] data_in,
    input logic [15:0] sweep_limit,
    output logic done, success,
    output logic [15:0] sweeps,
    output logic signed [12:0] best_cut,
    output logic [799:0] state_read, witness,
    output logic [31:0] local_words, swap_words, icm_words, node_visits,
    output logic [4:0] phase_out,
    output logic [2:0] event_out
);
    `include "graph_functions.svh"

    localparam integer NODE_COUNT=800, GRAPH_WIDTH=20;
    localparam integer REPLICAS=64, TEMPERATURES=32, COLOR_NODES=200;
    localparam integer REUSE_LIMIT=4, REMAINING_BITS=3;
    localparam integer ICM_FIRST=26, ICM_LAST=31;
    localparam integer ICM_INTERVAL=4, ICM_MAX_DISAGREEMENT=400;
    localparam integer POP_COUNT_BITS=10, FRESH_COUNT_BITS=8;
    localparam logic signed [12:0] SCORE_INITIAL=-4096;
    localparam logic signed [12:0] EXACT_TARGET=748;
    localparam IDLE=0, INITIAL=1, LOCAL=2, SCORE=3, ICM=4, FLOOD=5,
               FLIP=6, ICM_SCORE_A=7, ICM_SCORE_B=8, SWAP=9, FINISH=10;
    logic [4:0] phase;
    logic [5:0] replica;
    logic [1:0] color;
    logic [4:0] icm_temp,swap_left;
    logic swap_copy, pending_hit;
    wire [799:0] spins[0:REPLICAS-1];
    logic signed [12:0] cuts[0:REPLICAS-1];
    wire [799:0] current=spins[replica];
    wire signed [15:0] current_cut;
    wire [4:0] temperature=(replica>=TEMPERATURES)? replica-TEMPERATURES:replica;
    wire [5:0] swap_a=(swap_copy?TEMPERATURES:0)+swap_left;
    wire [5:0] swap_b=swap_a+1;
    wire signed [13:0] cut_difference=$signed({cuts[swap_b][12],cuts[swap_b]})-$signed({cuts[swap_a][12],cuts[swap_a]});
    wire [31:0] swap_next=swap_word,icm_next=cluster_word;
    wire accept_swap=(cut_difference<=0) || (swap_next<swap_threshold(swap_left,cut_difference[12:0]));
    wire [799:0] disagreement=spins[icm_temp]^spins[icm_temp+TEMPERATURES];
    logic [799:0] cluster;
    wire [799:0] expanded=expand(cluster)&disagreement;
    wire [799:0] invalidated=expand(cluster);
    logic [POP_COUNT_BITS-1:0] disagreement_count;
    logic [799:0] seed_mask;
    integer rank,index_count;
    always_comb begin
        disagreement_count=0;
        for(integer i=0;i<NODE_COUNT;i=i+1) disagreement_count=disagreement_count+{{(POP_COUNT_BITS-1){1'b0}},disagreement[i]};
        rank=icm_next % ((disagreement_count==0)?POP_COUNT_BITS'(1):disagreement_count);
        index_count=0; seed_mask=0;
        for(integer i=0;i<NODE_COUNT;i=i+1) begin
            if(disagreement[i]) begin
                if(index_count==rank) seed_mask[i]=1;
                index_count=index_count+1;
            end
        end
    end
wire local_active=phase==LOCAL;
wire score_active=(phase==INITIAL)||(phase==ICM_SCORE_A)||(phase==ICM_SCORE_B);
wire [6:0] cluster_ready,cluster_configured;
wire [15:0] cluster_fresh[0:6];
wire signed [15:0] cluster_score[0:6];
wire [799:0] update_bits;
wire local_commit=local_active&&(&cluster_ready);
wire score_commit=(phase==SCORE)||(score_active&&(&cluster_ready));
assign configured=&cluster_configured;
assign cfg_ready=(phase==IDLE)&&!rst&&!start&&!seed_we&&!init_we;
wire accepted_cfg=cfg_we&&cfg_ready;
wire start_accept=start&&configured&&!cfg_we&&!seed_we&&!init_we;
reg [31:0] fresh_count;
reg signed [15:0] score_sum;
always_comb begin
 fresh_count=0;score_sum=0;
 for(integer c=0;c<7;c=c+1)begin fresh_count=fresh_count+cluster_fresh[c];score_sum=score_sum+cluster_score[c];end
end
wire [799:0] dirty_current=dirty[replica];
assign current_cut=(phase==SCORE)?$signed(cuts[replica])+score_sum:score_sum;
assign state_read=spins[(read_bank<REPLICAS)?read_bank:0];
assign phase_out=phase;
assign event_out=(score_commit&&phase==INITIAL&&replica==REPLICAS-1)?3'd1:
 (score_commit&&phase==SCORE&&replica==REPLICAS-1)?3'd2:
 (score_commit&&phase==ICM_SCORE_B)?3'd3:(phase==SWAP&&accept_swap)?3'd4:3'd0;
wire [31:0] swap_word,cluster_word;
a2_aux_rng swap_rng(.clk(clk),.rst(rst),.test_enable(test_enable),.seeded(seed_we&&phase==IDLE&&seed_addr==51200),.consume(phase==SWAP),.seed_data(data_in),.word_out(swap_word));
a2_aux_rng cluster_rng(.clk(clk),.rst(rst),.test_enable(test_enable),.seeded(seed_we&&phase==IDLE&&seed_addr==51201),.consume(phase==ICM),.seed_data(data_in),.word_out(cluster_word));
a2_cluster_0 #(.EPIX(EPIX_ENABLE)) service_0(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[0+:128]),.next_bits(update_bits[0+:128]),
.ready(cluster_ready[0]),.configured(cluster_configured[0]),.fresh_count(cluster_fresh[0]),.score_value(cluster_score[0]));
a2_cluster_128 #(.EPIX(EPIX_ENABLE)) service_1(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[128+:128]),.next_bits(update_bits[128+:128]),
.ready(cluster_ready[1]),.configured(cluster_configured[1]),.fresh_count(cluster_fresh[1]),.score_value(cluster_score[1]));
a2_cluster_256 #(.EPIX(EPIX_ENABLE)) service_2(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[256+:128]),.next_bits(update_bits[256+:128]),
.ready(cluster_ready[2]),.configured(cluster_configured[2]),.fresh_count(cluster_fresh[2]),.score_value(cluster_score[2]));
a2_cluster_384 #(.EPIX(EPIX_ENABLE)) service_3(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[384+:128]),.next_bits(update_bits[384+:128]),
.ready(cluster_ready[3]),.configured(cluster_configured[3]),.fresh_count(cluster_fresh[3]),.score_value(cluster_score[3]));
a2_cluster_512 #(.EPIX(EPIX_ENABLE)) service_4(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[512+:128]),.next_bits(update_bits[512+:128]),
.ready(cluster_ready[4]),.configured(cluster_configured[4]),.fresh_count(cluster_fresh[4]),.score_value(cluster_score[4]));
a2_cluster_640 #(.EPIX(EPIX_ENABLE)) service_5(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[640+:128]),.next_bits(update_bits[640+:128]),
.ready(cluster_ready[5]),.configured(cluster_configured[5]),.fresh_count(cluster_fresh[5]),.score_value(cluster_score[5]));
a2_cluster_768 #(.EPIX(EPIX_ENABLE)) service_6(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(10'd0),
.current(current),.dirty(dirty_current[768+:32]),.next_bits(update_bits[768+:32]),
.ready(cluster_ready[6]),.configured(cluster_configured[6]),.fresh_count(cluster_fresh[6]),.score_value(cluster_score[6]));
wire [799:0] dirty[0:63];
wire [799:0] swap_spins_a=spins[swap_a],swap_spins_b=spins[swap_b];
`include "spin_state.svh"
wire main_control_clock;
wire main_control_advance=(phase==IDLE)?start_accept:(((phase==INITIAL)||(phase==SCORE)||(phase==ICM_SCORE_A)||(phase==ICM_SCORE_B))?score_commit:((phase==LOCAL)?local_commit:1'b1));
sky130_fd_sc_hd__dlclkp_1 main_control_gate(.CLK(clk),.GATE(rst||test_enable||main_control_advance),.GCLK(main_control_clock));
    task automatic begin_swaps;
        begin swap_copy<=0;swap_left<=(sweeps-1)&1;phase<=SWAP;end
    endtask
    task automatic next_icm;
        begin
            if(icm_temp==ICM_LAST) begin_swaps();
            else begin icm_temp<=icm_temp+1'b1;phase<=ICM;end
        end
    endtask
    always_ff @(posedge main_control_clock) begin
        if(rst) begin
            phase<=IDLE;done<=0;success<=0;sweeps<=0;best_cut<=SCORE_INITIAL;witness<=0;
            replica<=0;color<=0;icm_temp<=ICM_FIRST;swap_copy<=0;swap_left<=0;
            cluster<=0;pending_hit<=0;
            local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            for(integer r=0;r<REPLICAS;r=r+1) cuts[r]<=0;
        end else begin
            case(phase)
            IDLE: if(start_accept) begin
                phase<=INITIAL;replica<=0;best_cut<=SCORE_INITIAL;done<=0;success<=0;
                pending_hit<=0;sweeps<=0;color<=0;local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            end
            INITIAL,SCORE,ICM_SCORE_A,ICM_SCORE_B: if(score_commit) begin
                cuts[replica]<=current_cut;
                if(current_cut>best_cut) begin best_cut<=current_cut;witness<=current;end
                if(current_cut>=EXACT_TARGET) pending_hit<=1;
                if(phase==INITIAL) begin
                    if(replica==REPLICAS-1) begin
                        replica<=0;sweeps<=0;
                        if(pending_hit || current_cut>=EXACT_TARGET || sweep_limit==0) phase<=FINISH;
                        else begin sweeps<=1;phase<=LOCAL;end
                    end else replica<=replica+1'b1;
                end else if(phase==SCORE) begin
                    if(replica!=REPLICAS-1) begin replica<=replica+1'b1;phase<=LOCAL;end
                    else begin
                        replica<=0;
                        if(pending_hit || current_cut>=EXACT_TARGET) phase<=FINISH;
                        else if(color!=3) begin color<=color+1'b1;phase<=LOCAL;end
                        else if((sweeps % ICM_INTERVAL)==0) begin icm_temp<=ICM_FIRST;phase<=ICM;end
                        else begin_swaps();
                    end
                end else if(phase==ICM_SCORE_A) begin replica<=icm_temp+TEMPERATURES;phase<=ICM_SCORE_B;end
                else begin
                    if(pending_hit || current_cut>=EXACT_TARGET) phase<=FINISH;
                    else next_icm();
                end
            end
            LOCAL: if(local_commit) begin
                local_words<=local_words+fresh_count;node_visits<=node_visits+COLOR_NODES;phase<=SCORE;
            end
            ICM: begin
                icm_words<=icm_words+1;
                if(disagreement_count==0 || disagreement_count>ICM_MAX_DISAGREEMENT) next_icm();
                else begin cluster<=seed_mask;phase<=FLOOD;end
            end
            FLOOD: begin
                if(expanded==cluster) phase<=FLIP;
                else cluster<=expanded;
            end
            FLIP: begin replica<=icm_temp;phase<=ICM_SCORE_A;end
            SWAP: begin
                swap_words<=swap_words+1;
                if(accept_swap) begin cuts[swap_a]<=cuts[swap_b];cuts[swap_b]<=cuts[swap_a];end
                if(swap_left+2>=TEMPERATURES-1) begin
                    if(!swap_copy) begin swap_copy<=1;swap_left<=(sweeps-1)&1;end
                    else if(sweeps>=sweep_limit) phase<=FINISH;
                    else begin sweeps<=sweeps+1'b1;color<=0;replica<=0;phase<=LOCAL;end
                end else swap_left<=swap_left+2;
            end
            FINISH: begin done<=1;success<=pending_hit;phase<=IDLE;end
            default: phase<=IDLE;
            endcase
        end
    end
endmodule
