`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE __EPIX_DEFAULT__
`endif
// 800-bit native colored Gibbs search. All decisions and scores are computed here.
module chimera_solver #(
    parameter EPIX_ENABLE=`EPIX_MODE,
    parameter SWEEPS_PER_BETA=937,
    parameter BETA_COUNT=14
)(
    input logic clk,rst,start,seed_we,init_we,
    input logic [9:0] seed_addr,
    input logic [4:0] init_word,
    input logic [31:0] data_in,
    output logic done,success,final_success,
    output logic [15:0] sweeps,
    output logic signed [15:0] best_cut,final_cut,
    output logic [31:0] first_exact_sweep,
    output wire [799:0] state_read,
    output logic [799:0] witness,
    output logic [31:0] local_words,node_visits,fired_cycles,
    output wire [2:0] phase_out,event_out
);
    `include "graph_functions.svh"
    localparam IDLE=0,INITIAL=1,UPDATE=2,SCORE=3,FINISH=4;
    logic [2:0] phase;
    logic color;
    logic [3:0] beta_step;
    logic [9:0] sweep_in_beta;
    localparam integer RNG_BANKS=800/32;
    wire [799:0] state_bits;
    wire [31:0] rng_words [0:799];
    wire [31:0] bank_word [0:RNG_BANKS-1];
    wire [4:0] bank_offset [0:RNG_BANKS-1];
    wire [RNG_BANKS-1:0] bank_valid,bank_done;
    wire commit=(phase==UPDATE) && (&bank_done);
    wire signed [15:0] current_cut=score(state_bits);
    wire [799:0] refresh_mask,fire_mask;
    logic [15:0] fresh_count,fire_count;
    always_comb begin
        fresh_count=0;
        fire_count=0;
        for(integer i=0;i<800;i=i+1) begin
            fresh_count=fresh_count+{15'b0,refresh_mask[i]};
            fire_count=fire_count+{15'b0,fire_mask[i]};
        end
    end
    function automatic [31:0] advance(input logic [31:0] value);
        reg [31:0] x;
        begin
            x=value;
            for(integer k=0;k<32;k=k+1)
                x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
            advance=x;
        end
    endfunction
    // Each bank advances one requested stream per cycle. Spins stay fixed until
    // every bank has served its requests, so the color update remains simultaneous.
    for(genvar b=0;b<RNG_BANKS;b=b+1) begin: rng_bank
        logic [31:0] served;
        wire [31:0] pending=refresh_mask[b*32+:32] & ~served;
        logic [4:0] offset;
        always_comb begin
            offset=0;
            for(integer k=31;k>=0;k=k-1)
                if(pending[k]) offset=5'(k);
        end
        wire valid=|pending;
        wire [31:0] service_mask=valid ? (32'd1<<offset) : 32'd0;
        assign bank_offset[b]=offset;
        assign bank_valid[b]=valid;
        assign bank_done[b]=((pending & ~service_mask)==0);
        assign bank_word[b]=advance(rng_words[b*32+offset]);
        always_ff @(posedge clk) begin
            if(rst || phase!=UPDATE) served<=0;
            else served<=served | service_mask;
        end
    end
    assign state_read=state_bits;
    assign phase_out=phase;
    // Event is sampled before the scoring edge; state and score after that edge.
    assign event_out=(phase==INITIAL)?3'd1:(phase==SCORE ? (color ? 3'd3:3'd2):3'd0);
    for(genvar i=0;i<800;i=i+1) begin: lane
        localparam bit NODE_COLOR=1'(((i/80)+(i/8)%10+(i/4)%2)%2);
        localparam logic [4:0] NODE_WORD=5'(i/32);
        logic spin;
        logic [31:0] rng_state;
        logic signed [15:0] saved_numerator;
        logic [1:0] remaining;
        wire selected=(phase==UPDATE)&&(color==NODE_COLOR);
        wire signed [7:0] raw_value=raw_field(i,state_bits);
        wire signed [15:0] numerator=$signed(raw_value)*$signed({1'b0,beta_step});
        wire nonnegative=(numerator>=0);
        wire [15:0] magnitude=nonnegative?numerator:-numerator;
        wire [17:0] unbounded_address=({2'b00,magnitude}*18'd4+18'd2)/18'd4;
        wire [7:0] address=(unbounded_address>127)?8'd127:unbounded_address[7:0];
        wire [31:0] threshold=probability(address);
        // Adjacent numerator values differ by 1/8, greater than delta=0.05.
        wire refresh=!EPIX_ENABLE || (remaining==0) || (spin!=nonnegative) || (saved_numerator!=numerator);
        wire servicing=(phase==UPDATE) && bank_valid[i/32] && (bank_offset[i/32]==5'(i%32));
        // The final serviced word is used on the same edge as the color commit.
        wire [31:0] sample_word=servicing?bank_word[i/32]:rng_state;
        wire sample=nonnegative?(threshold>sample_word):(sample_word>threshold);
        wire fire=refresh || (sample!=spin);
        assign refresh_mask[i]=selected && refresh;
        assign fire_mask[i]=selected && fire;
        assign state_bits[i]=spin;
        assign rng_words[i]=rng_state;
        wire rng_clock,spin_clock;
        wire rng_enable=rst || (seed_we && phase==IDLE && seed_addr==i) || servicing;
        wire spin_enable=rst || (init_we && phase==IDLE && init_word==NODE_WORD) || (commit && selected && fire);
        sky130_fd_sc_hd__dlclkp_1 rng_gate(.CLK(clk),.GATE(rng_enable),.GCLK(rng_clock));
        sky130_fd_sc_hd__dlclkp_1 spin_gate(.CLK(clk),.GATE(spin_enable),.GCLK(spin_clock));
        always_ff @(posedge rng_clock) begin
            if(rst) rng_state<=0;
            else if(seed_we && phase==IDLE && seed_addr==i) rng_state<=data_in;
            else if(servicing) rng_state<=bank_word[i/32];
        end
        always_ff @(posedge spin_clock) begin
            if(rst) spin<=0;
            else if(init_we && phase==IDLE && init_word==NODE_WORD) spin<=data_in[i%32];
            else if(commit && selected && fire) spin<=sample;
        end
        always_ff @(posedge clk) begin
            if(rst || (start && phase==IDLE)) begin remaining<=0;saved_numerator<=0;end
            else if(commit && selected) begin
                if(refresh) begin remaining<=2;saved_numerator<=numerator;end
                else remaining<=remaining-1'b1;
            end
        end
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            phase<=IDLE;done<=0;success<=0;final_success<=0;best_cut<=0;final_cut<=0;
            sweeps<=0;first_exact_sweep<=32'hffffffff;witness<=0;
            local_words<=0;node_visits<=0;fired_cycles<=0;color<=0;beta_step<=1;sweep_in_beta<=0;
        end else case(phase)
            IDLE: if(start) begin
                done<=0;success<=0;final_success<=0;best_cut<=0;final_cut<=0;
                sweeps<=0;first_exact_sweep<=32'hffffffff;witness<=0;
                local_words<=0;node_visits<=0;fired_cycles<=0;
                color<=0;beta_step<=1;sweep_in_beta<=0;phase<=INITIAL;
            end
            INITIAL: begin
                best_cut<=current_cut;final_cut<=current_cut;
                if(current_cut==522) begin success<=1;first_exact_sweep<=0;witness<=state_bits;end
                phase<=UPDATE;
            end
            UPDATE: if(commit) begin
                local_words<=local_words+{16'b0,fresh_count};
                node_visits<=node_visits+32'd400;
                fired_cycles<=fired_cycles+{16'b0,fire_count};
                phase<=SCORE;
            end
            SCORE: begin
                final_cut<=current_cut;
                if(current_cut>best_cut) best_cut<=current_cut;
                if(current_cut==522 && !success) begin success<=1;first_exact_sweep<={16'b0,sweeps}+32'd1;witness<=state_bits;end
                if(!color) begin color<=1;phase<=UPDATE;end
                else begin
                    color<=0;sweeps<=sweeps+1;
                    if(sweep_in_beta==10'(SWEEPS_PER_BETA-1)) begin
                        sweep_in_beta<=0;
                        if(beta_step==4'(BETA_COUNT)) begin final_success<=(current_cut==522);phase<=FINISH;end
                        else begin beta_step<=beta_step+1;phase<=UPDATE;end
                    end else begin sweep_in_beta<=sweep_in_beta+1;phase<=UPDATE;end
                end
            end
            FINISH: begin done<=1;phase<=IDLE;end
            default: phase<=IDLE;
        endcase
    end
endmodule
