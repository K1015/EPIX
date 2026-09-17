`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
// 512-bit colored Gibbs solver: search control, decisions, and scores.
module chimera_solver #(
    parameter EPIX_ENABLE=`EPIX_MODE,
    parameter SWEEPS_PER_BETA=937,
    parameter BETA_COUNT=14
)(
    input logic clk,rst,start,seed_we,init_we,
    input logic [15:0] seed_addr,
    input logic cfg_we,test_enable,
    input logic [9:0] cfg_addr,
    output wire cfg_ready,configured,
    input logic [3:0] init_word,
    input logic [31:0] data_in,
    output logic done,success,final_success,
    output logic [15:0] sweeps,
    output logic signed [15:0] best_cut,final_cut,
    output logic [31:0] first_exact_sweep,
    output wire [511:0] state_read,
    output logic [511:0] witness,
    output logic [31:0] local_words,node_visits,fired_cycles,
    output wire [2:0] phase_out,event_out
);

    localparam IDLE=0,INITIAL=1,UPDATE=2,SCORE=3,FINISH=4;
    logic [2:0] phase;
    logic color;
    logic [3:0] beta_step;
    logic [9:0] sweep_in_beta;
wire local_active=phase==UPDATE;
wire score_active=(phase==INITIAL);
wire [3:0] cluster_ready,cluster_configured;
wire [15:0] cluster_fresh[0:3];
wire signed [15:0] cluster_score[0:3];
wire [511:0] update_bits;
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
 for(integer c=0;c<4;c=c+1)begin fresh_count=fresh_count+cluster_fresh[c];score_sum=score_sum+cluster_score[c];end
end
wire [511:0] current=state_bits,dirty_current=dirty_bits;
wire [5:0] replica=0,temperature=beta_step;
wire signed [15:0] current_cut=(phase==SCORE)?final_cut+score_sum:score_sum;
wire commit=local_commit;
wire [31:0] fire_count=fresh_count;
assign state_read=state_bits;
assign phase_out=phase;
assign event_out=(score_commit&&phase==INITIAL)?3'd1:(score_commit&&phase==SCORE?(color?3'd3:3'd2):3'd0);
a2_cluster_0 #(.EPIX(EPIX_ENABLE)) service_0(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(sweep_in_beta),
.current(current),.dirty(dirty_current[0+:128]),.next_bits(update_bits[0+:128]),
.ready(cluster_ready[0]),.configured(cluster_configured[0]),.fresh_count(cluster_fresh[0]),.score_value(cluster_score[0]));
a2_cluster_128 #(.EPIX(EPIX_ENABLE)) service_1(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(sweep_in_beta),
.current(current),.dirty(dirty_current[128+:128]),.next_bits(update_bits[128+:128]),
.ready(cluster_ready[1]),.configured(cluster_configured[1]),.fresh_count(cluster_fresh[1]),.score_value(cluster_score[1]));
a2_cluster_256 #(.EPIX(EPIX_ENABLE)) service_2(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(sweep_in_beta),
.current(current),.dirty(dirty_current[256+:128]),.next_bits(update_bits[256+:128]),
.ready(cluster_ready[2]),.configured(cluster_configured[2]),.fresh_count(cluster_fresh[2]),.score_value(cluster_score[2]));
a2_cluster_384 #(.EPIX(EPIX_ENABLE)) service_3(
.clk(clk),.rst(rst),.test_enable(test_enable),.active(local_active),.score_active(score_active),.accept(local_commit||score_commit),
.seed_we(seed_we&&phase==IDLE),.cfg_we(accepted_cfg),.seed_addr(seed_addr),.cfg_addr(cfg_addr),.data_in(data_in),
.context_id(6'(replica)),.color(2'(color)),.beta(6'(temperature)),.sweep_tag(3'(sweeps)),.beta_sweep(sweep_in_beta),
.current(current),.dirty(dirty_current[384+:128]),.next_bits(update_bits[384+:128]),
.ready(cluster_ready[3]),.configured(cluster_configured[3]),.fresh_count(cluster_fresh[3]),.score_value(cluster_score[3]));
wire [511:0] state_bits,dirty_bits;
`include "spin_state.svh"
wire main_control_clock;
wire main_control_advance=(phase==IDLE)?start_accept:((phase==INITIAL)?score_commit:((phase==UPDATE)?local_commit:1'b1));
sky130_fd_sc_hd__dlclkp_1 main_control_gate(.CLK(clk),.GATE(rst||test_enable||main_control_advance),.GCLK(main_control_clock));
    always_ff @(posedge main_control_clock) begin
        if(rst) begin
            phase<=IDLE;done<=0;success<=0;final_success<=0;best_cut<=0;final_cut<=0;
            sweeps<=0;first_exact_sweep<=32'hffffffff;witness<=0;
            local_words<=0;node_visits<=0;fired_cycles<=0;color<=0;beta_step<=1;sweep_in_beta<=0;
        end else case(phase)
            IDLE: if(start_accept) begin
                done<=0;success<=0;final_success<=0;best_cut<=0;final_cut<=0;
                sweeps<=0;first_exact_sweep<=32'hffffffff;witness<=0;
                local_words<=0;node_visits<=0;fired_cycles<=0;
                color<=0;beta_step<=1;sweep_in_beta<=0;phase<=INITIAL;
            end
            INITIAL: if(score_commit) begin
                best_cut<=current_cut;final_cut<=current_cut;
                if(current_cut==294) begin success<=1;first_exact_sweep<=0;witness<=state_bits;end
                phase<=UPDATE;
            end
            UPDATE: if(commit) begin
                local_words<=local_words+fresh_count;
                node_visits<=node_visits+32'd256;
                fired_cycles<=fired_cycles+fire_count;
                phase<=SCORE;
            end
            SCORE: if(score_commit) begin
                final_cut<=current_cut;
                if(current_cut>best_cut) best_cut<=current_cut;
                if(current_cut==294 && !success) begin success<=1;first_exact_sweep<={16'b0,sweeps}+32'd1;witness<=state_bits;end
                if(!color) begin color<=1;phase<=UPDATE;end
                else begin
                    color<=0;sweeps<=sweeps+1;
                    if(sweep_in_beta==10'(SWEEPS_PER_BETA-1)) begin
                        sweep_in_beta<=0;
                        if(beta_step==4'(BETA_COUNT)) begin final_success<=(current_cut==294);phase<=FINISH;end
                        else begin beta_step<=beta_step+1;phase<=UPDATE;end
                    end else begin sweep_in_beta<=sweep_in_beta+1;phase<=UPDATE;end
                end
            end
            FINISH: begin done<=1;phase<=IDLE;end
            default: phase<=IDLE;
        endcase
    end
endmodule
