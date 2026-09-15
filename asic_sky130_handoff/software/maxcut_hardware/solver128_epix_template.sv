`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
module corrected_solver #(
    parameter EPIX_ENABLE=`EPIX_MODE,
    parameter RNG_STRIDE=32
)(
    input logic clk, rst, start, seed_we, init_we,
    input logic [7:0] seed_addr,
    input logic [4:0] init_bank, read_bank,
    input logic [1:0] init_word,
    input logic [31:0] data_in,
    input logic [15:0] sweep_limit,
    output logic done, success,
    output logic [15:0] sweeps,
    output logic signed [9:0] best_cut,
    output logic [127:0] state_read, witness,
    output logic [31:0] local_words, swap_words, icm_words, node_visits,
    output logic [4:0] phase_out,
    output logic [2:0] event_out
);
    `include "graph_functions.svh"
    `include "metadata_widths.svh"
    localparam IDLE=0, INITIAL=1, LOCAL=2, SCORE=3, ICM=4, FLOOD=5,
               FLIP=6, ICM_SCORE_A=7, ICM_SCORE_B=8, SWAP=9, FINISH=10;
    logic [4:0] phase,replica;
    logic [1:0] color;
    logic [3:0] icm_temp,swap_left;
    logic swap_copy, pending_hit;
    logic [127:0] spins[0:23];
    logic signed [9:0] cuts[0:23];
    wire [127:0] current=spins[replica];
    wire signed [9:0] current_cut=score(current);
    wire [3:0] temperature=(replica>=12)? replica-12:replica;
    wire [4:0] swap_a=(swap_copy?12:0)+swap_left;
    wire [4:0] swap_b=swap_a+1;
    wire signed [10:0] cut_difference=$signed(cuts[swap_b])-$signed(cuts[swap_a]);
    logic [31:0] swap_rng,icm_rng;
    function automatic [31:0] advance(input logic [31:0] value);
        reg [31:0] x;
        begin
            x=value;
            for(integer k=0;k<RNG_STRIDE;k=k+1)
                x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
            advance=x;
        end
    endfunction
    wire [31:0] swap_next=advance(swap_rng),icm_next=advance(icm_rng);
    wire accept_swap=(cut_difference<=0) || (swap_next<swap_threshold(swap_left,cut_difference[9:0]));
    wire [127:0] disagreement=spins[icm_temp]^spins[icm_temp+12];
    logic [127:0] cluster;
    wire [127:0] expanded=expand(cluster)&disagreement;
    wire [127:0] invalidated=expand(cluster);
    logic [7:0] disagreement_count;
    logic [127:0] seed_mask;
    integer rank,index_count;
    always_comb begin
        disagreement_count=0;
        for(integer i=0;i<128;i=i+1) disagreement_count=disagreement_count+{7'b0,disagreement[i]};
        rank=icm_next % ((disagreement_count==0)?8'd1:disagreement_count);
        index_count=0; seed_mask=0;
        for(integer i=0;i<128;i=i+1) begin
            if(disagreement[i]) begin
                if(index_count==rank) seed_mask[i]=1;
                index_count=index_count+1;
            end
        end
    end
    wire [127:0] refresh_mask;
    logic [7:0] fresh_count;
    always_comb begin
        fresh_count=0;
        for(integer i=0;i<128;i=i+1) fresh_count=fresh_count+{7'b0,refresh_mask[i]};
    end
    assign state_read=spins[(read_bank<24)?read_bank:0];
    assign phase_out=phase;
    assign event_out=(phase==INITIAL && replica==23)?3'd1:
        (phase==SCORE && replica==23)?3'd2:
        (phase==ICM_SCORE_B)?3'd3:
        (phase==SWAP && accept_swap)?3'd4:3'd0;
    wire [3:0] bank_clock[0:23];
    for(genvar r=0;r<24;r=r+1) begin: bank_gate
        for(genvar c=0;c<4;c=c+1) begin: color_gate
            wire enable=rst || (start && phase==IDLE) ||
                (init_we && phase==IDLE && init_bank==r) ||
                (phase==LOCAL && replica==r && color==c) ||
                (phase==FLIP && (icm_temp==r || icm_temp+12==r)) ||
                (phase==SWAP && accept_swap && (swap_a==r || swap_b==r));
            sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),.GATE(enable),.GCLK(bank_clock[r][c]));
        end
    end
    wire [4:0] metadata_replica[0:3];
    for(genvar c=0;c<4;c=c+1) begin: metadata_read_color
        assign metadata_replica[c]=((phase==LOCAL || phase==SCORE) && color==c) ? replica : 5'd0;
    end
    // Each physical node has a distinct RNG; replica states are time-shared.
    for(genvar i=0;i<128;i=i+1) begin: lane
        localparam integer NODE_COLOR=((i/8)%2)*2+(i%2);
        logic [31:0] rng_state;
        localparam integer FIELD_BITS=metadata_field_width(i);
        logic [1:0] remaining[0:23];
        logic signed [FIELD_BITS-1:0] saved_field[0:23];
        wire signed [4:0] local_value=raw_field(i,current);
        wire signed [FIELD_BITS-1:0] encoded_field=$signed(local_value) >>> 1;
        wire nonnegative=(local_value>=0);
        wire selected=(phase==LOCAL)&&(color==NODE_COLOR);
        wire refresh=!EPIX_ENABLE || (remaining[metadata_replica[NODE_COLOR]]==0) ||
             (spins[replica][i]!=nonnegative) ||
             (encoded_field!=saved_field[metadata_replica[NODE_COLOR]]);
        wire [31:0] next_rng=advance(rng_state);
        wire [31:0] threshold=probability(temperature,local_value);
        wire sample=nonnegative ? (next_rng<threshold):(next_rng>threshold);
        assign refresh_mask[i]=selected && refresh;
        wire rng_clock;
        wire rng_enable=rst || (seed_we && phase==IDLE && seed_addr==i) || (selected && refresh);
        sky130_fd_sc_hd__dlclkp_1 rng_gate(.CLK(clk),.GATE(rng_enable),.GCLK(rng_clock));
        always_ff @(posedge rng_clock) begin
            if(rst) rng_state<=0;
            else begin
                if(seed_we && phase==IDLE && seed_addr==i) rng_state<=data_in;
                if(selected && refresh) rng_state<=next_rng;
            end
        end
        for(genvar r=0;r<24;r=r+1) begin: storage
            always_ff @(posedge bank_clock[r][NODE_COLOR]) begin
                if(rst) begin spins[r][i]<=0;remaining[r]<=0;saved_field[r]<=0;end
                else begin
                    if(init_we && phase==IDLE && init_bank==r && init_word==i/32)
                        spins[r][i]<=data_in[i%32];
                    if(start && phase==IDLE) begin remaining[r]<=0;saved_field[r]<=0;end
                    if(selected && replica==r) begin
                        if(refresh) begin
                            spins[r][i]<=sample;remaining[r]<=2; saved_field[r]<=encoded_field;
                        end else remaining[r]<=remaining[r]-1'b1;
                    end
                    if(phase==FLIP && (icm_temp==r || icm_temp+12==r)) begin
                        spins[r][i]<=spins[r][i]^cluster[i];
                        if(invalidated[i]) remaining[r]<=0;
                    end
                    if(phase==SWAP && accept_swap) begin
                        if(swap_a==r) begin spins[r][i]<=spins[swap_b][i];remaining[r]<=0;end
                        if(swap_b==r) begin spins[r][i]<=spins[swap_a][i];remaining[r]<=0;end
                    end
                end
            end
        end
    end
    task automatic begin_swaps;
        begin swap_copy<=0;swap_left<=(sweeps-1)&1;phase<=SWAP;end
    endtask
    task automatic next_icm;
        begin
            if(icm_temp==11) begin_swaps();
            else begin icm_temp<=icm_temp+1'b1;phase<=ICM;end
        end
    endtask
    always_ff @(posedge clk) begin
        if(rst) begin
            phase<=IDLE;done<=0;success<=0;sweeps<=0;best_cut<=-512;witness<=0;
            replica<=0;color<=0;icm_temp<=9;swap_copy<=0;swap_left<=0;
            swap_rng<=0;icm_rng<=0;cluster<=0;pending_hit<=0;
            local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            for(integer r=0;r<24;r=r+1) cuts[r]<=0;
        end else begin
            if(seed_we && phase==IDLE && seed_addr==128) swap_rng<=data_in;
            if(seed_we && phase==IDLE && seed_addr==129) icm_rng<=data_in;
            case(phase)
            IDLE: if(start) begin
                phase<=INITIAL;replica<=0;best_cut<=-512;done<=0;success<=0;
                pending_hit<=0;sweeps<=0;color<=0;local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            end
            INITIAL,SCORE,ICM_SCORE_A,ICM_SCORE_B: begin
                cuts[replica]<=current_cut;
                if(current_cut>best_cut) begin best_cut<=current_cut;witness<=current;end
                if(current_cut>=121) pending_hit<=1;
                if(phase==INITIAL) begin
                    if(replica==23) begin
                        replica<=0;sweeps<=0;
                        if(pending_hit || current_cut>=121 || sweep_limit==0) phase<=FINISH;
                        else begin sweeps<=1;phase<=LOCAL;end
                    end else replica<=replica+1'b1;
                end else if(phase==SCORE) begin
                    if(replica!=23) begin replica<=replica+1'b1;phase<=LOCAL;end
                    else begin
                        replica<=0;
                        if(pending_hit || current_cut>=121) phase<=FINISH;
                        else if(color!=3) begin color<=color+1'b1;phase<=LOCAL;end
                        else if(sweeps[1:0]==0) begin icm_temp<=9;phase<=ICM;end
                        else begin_swaps();
                    end
                end else if(phase==ICM_SCORE_A) begin replica<=icm_temp+12;phase<=ICM_SCORE_B;end
                else begin
                    if(pending_hit || current_cut>=121) phase<=FINISH;
                    else next_icm();
                end
            end
            LOCAL: begin
                local_words<=local_words+fresh_count;node_visits<=node_visits+32;phase<=SCORE;
            end
            ICM: begin
                icm_rng<=icm_next;icm_words<=icm_words+1;
                if(disagreement_count==0 || disagreement_count>64) next_icm();
                else begin cluster<=seed_mask;phase<=FLOOD;end
            end
            FLOOD: begin
                if(expanded==cluster) phase<=FLIP;
                else cluster<=expanded;
            end
            FLIP: begin replica<=icm_temp;phase<=ICM_SCORE_A;end
            SWAP: begin
                swap_rng<=swap_next;swap_words<=swap_words+1;
                if(accept_swap) begin cuts[swap_a]<=cuts[swap_b];cuts[swap_b]<=cuts[swap_a];end
                if(swap_left+2>=11) begin
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
