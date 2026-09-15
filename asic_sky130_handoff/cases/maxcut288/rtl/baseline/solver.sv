`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
module corrected_solver #(
    parameter EPIX_ENABLE=`EPIX_MODE,
    parameter RNG_STRIDE=32
)(
    input logic clk, rst, start, seed_we, init_we,
    input logic [8:0] seed_addr,
    input logic [4:0] init_bank, read_bank,
    input logic [3:0] init_word,
    input logic [31:0] data_in,
    input logic [15:0] sweep_limit,
    output logic done, success,
    output logic [15:0] sweeps,
    output logic signed [11:0] best_cut,
    output logic [287:0] state_read, witness,
    output logic [31:0] local_words, swap_words, icm_words, node_visits,
    output logic [4:0] phase_out,
    output logic [2:0] event_out
);
    `include "graph_functions.svh"
    `include "metadata_widths.svh"
    localparam integer NODE_COUNT=288, GRAPH_WIDTH=12;
    localparam integer REPLICAS=32, TEMPERATURES=16, COLOR_NODES=72;
    localparam integer REUSE_LIMIT=4, REMAINING_BITS=3;
    localparam integer ICM_FIRST=11, ICM_LAST=15;
    localparam integer ICM_INTERVAL=4, ICM_MAX_DISAGREEMENT=144;
    localparam integer POP_COUNT_BITS=9, FRESH_COUNT_BITS=7;
    localparam logic signed [11:0] SCORE_INITIAL=-2048;
    localparam logic signed [11:0] EXACT_TARGET=262;
    localparam IDLE=0, INITIAL=1, LOCAL=2, SCORE=3, ICM=4, FLOOD=5,
               FLIP=6, ICM_SCORE_A=7, ICM_SCORE_B=8, SWAP=9, FINISH=10;
    logic [4:0] phase;
    logic [4:0] replica;
    logic [1:0] color;
    logic [3:0] icm_temp,swap_left;
    logic swap_copy, pending_hit;
    logic [287:0] spins[0:REPLICAS-1];
    logic signed [11:0] cuts[0:REPLICAS-1];
    wire [287:0] current=spins[replica];
    wire signed [11:0] current_cut=score(current);
    wire [3:0] temperature=(replica>=TEMPERATURES)? replica-TEMPERATURES:replica;
    wire [4:0] swap_a=(swap_copy?TEMPERATURES:0)+swap_left;
    wire [4:0] swap_b=swap_a+1;
    wire signed [12:0] cut_difference=$signed({cuts[swap_b][11],cuts[swap_b]})-$signed({cuts[swap_a][11],cuts[swap_a]});
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
    wire accept_swap=(cut_difference<=0) || (swap_next<swap_threshold(swap_left,cut_difference[11:0]));
    wire [287:0] disagreement=spins[icm_temp]^spins[icm_temp+TEMPERATURES];
    logic [287:0] cluster;
    wire [287:0] expanded=expand(cluster)&disagreement;
    wire [287:0] invalidated=expand(cluster);
    logic [POP_COUNT_BITS-1:0] disagreement_count;
    logic [287:0] seed_mask;
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
    wire [287:0] refresh_mask;
    logic [FRESH_COUNT_BITS-1:0] fresh_count;
    always_comb begin
        fresh_count=0;
        for(integer i=0;i<NODE_COUNT;i=i+1) fresh_count=fresh_count+{{(FRESH_COUNT_BITS-1){1'b0}},refresh_mask[i]};
    end
    assign state_read=spins[(read_bank<REPLICAS)?read_bank:0];
    assign phase_out=phase;
    assign event_out=(phase==INITIAL && replica==REPLICAS-1)?3'd1:
        (phase==SCORE && replica==REPLICAS-1)?3'd2:
        (phase==ICM_SCORE_B)?3'd3:
        (phase==SWAP && accept_swap)?3'd4:3'd0;
    localparam integer RNG_BANKS=9;
    wire [31:0] local_rng_word[0:287];
    wire [RNG_BANKS-1:0] rng_bank_ready;
    wire local_commit=(phase==LOCAL) && (&rng_bank_ready);
    // Service independent streams; commit the color only when every bank is ready.
    for(genvar b=0;b<RNG_BANKS;b=b+1) begin: rng_bank
        logic [31:0] state[0:31];
        logic [31:0] served;
        wire [31:0] requests=refresh_mask[32*b+:32] & ~served;
        logic [4:0] service_node;
        logic service_valid;
        always_comb begin
            service_node=0;
            service_valid=0;
            for(integer j=0;j<32;j=j+1) begin
                if(requests[j] && !service_valid) begin
                    service_node=5'(j);
                    service_valid=1;
                end
            end
        end
        wire [31:0] service_word=advance(state[service_node]);
        assign rng_bank_ready[b]=((requests & (requests-1'b1))==0);
        for(genvar j=0;j<32;j=j+1) begin: word_read
            // Earlier words are already in state; bypass the word produced now.
            assign local_rng_word[32*b+j]=(service_valid && service_node==5'(j)) ?
                service_word : state[j];
        end
        always_ff @(posedge clk) begin
            if(rst) begin
                served<=0;
                for(integer j=0;j<32;j=j+1) state[j]<=0;
            end else begin
                if(seed_we && phase==IDLE && (seed_addr/32)==b)
                    state[seed_addr[4:0]]<=data_in;
                if(phase!=LOCAL || local_commit) served<=0;
                else if(service_valid) served[service_node]<=1;
                if(phase==LOCAL && service_valid) state[service_node]<=service_word;
            end
        end
    end
    wire [3:0] bank_clock[0:REPLICAS-1];
    for(genvar r=0;r<REPLICAS;r=r+1) begin: bank_gate
        for(genvar c=0;c<4;c=c+1) begin: color_gate
            wire enable=rst || (start && phase==IDLE) ||
                (init_we && phase==IDLE && init_bank==r) ||
                (local_commit && replica==r && color==c) ||
                (phase==FLIP && (icm_temp==r || icm_temp+TEMPERATURES==r)) ||
                (phase==SWAP && accept_swap && (swap_a==r || swap_b==r));
            sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),.GATE(enable),.GCLK(bank_clock[r][c]));
        end
    end
    // Each node retains its stream; replicas share the node bank.
    for(genvar i=0;i<NODE_COUNT;i=i+1) begin: lane
        localparam integer NODE_COLOR=((i/GRAPH_WIDTH)%2)*2+((i%GRAPH_WIDTH)%2);
        localparam integer FIELD_BITS=metadata_field_width(i);
        logic [REMAINING_BITS-1:0] remaining[0:REPLICAS-1];
        logic signed [FIELD_BITS-1:0] saved_field[0:REPLICAS-1];
        wire signed [4:0] local_value=raw_field(i,current);
        wire signed [FIELD_BITS-1:0] encoded_field=$signed(local_value) >>> 1;
        wire nonnegative=(local_value>=0);
        wire selected=(phase==LOCAL)&&(color==NODE_COLOR);
        wire refresh=!EPIX_ENABLE || (remaining[replica]==0) ||
             (spins[replica][i]!=nonnegative) ||
             (encoded_field!=saved_field[replica]);
        wire [31:0] next_rng=local_rng_word[i];
        wire [31:0] threshold=probability(temperature,local_value);
        wire sample=nonnegative ? (next_rng<threshold):(next_rng>threshold);
        assign refresh_mask[i]=selected && refresh;
        for(genvar r=0;r<REPLICAS;r=r+1) begin: storage
            always_ff @(posedge bank_clock[r][NODE_COLOR]) begin
                if(rst) begin spins[r][i]<=0;remaining[r]<=0;saved_field[r]<=0;end
                else begin
                    if(init_we && phase==IDLE && init_bank==r && init_word==i/32)
                        spins[r][i]<=data_in[i%32];
                    if(start && phase==IDLE) begin remaining[r]<=0;saved_field[r]<=0;end
                    if(local_commit && selected && replica==r) begin
                        if(refresh) begin
                            spins[r][i]<=sample;remaining[r]<=REMAINING_BITS'(REUSE_LIMIT); saved_field[r]<=encoded_field;
                        end else remaining[r]<=remaining[r]-1'b1;
                    end
                    if(phase==FLIP && (icm_temp==r || icm_temp+TEMPERATURES==r)) begin
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
            if(icm_temp==ICM_LAST) begin_swaps();
            else begin icm_temp<=icm_temp+1'b1;phase<=ICM;end
        end
    endtask
    always_ff @(posedge clk) begin
        if(rst) begin
            phase<=IDLE;done<=0;success<=0;sweeps<=0;best_cut<=SCORE_INITIAL;witness<=0;
            replica<=0;color<=0;icm_temp<=ICM_FIRST;swap_copy<=0;swap_left<=0;
            swap_rng<=0;icm_rng<=0;cluster<=0;pending_hit<=0;
            local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            for(integer r=0;r<REPLICAS;r=r+1) cuts[r]<=0;
        end else begin
            if(seed_we && phase==IDLE && seed_addr==NODE_COUNT) swap_rng<=data_in;
            if(seed_we && phase==IDLE && seed_addr==NODE_COUNT+1) icm_rng<=data_in;
            case(phase)
            IDLE: if(start) begin
                phase<=INITIAL;replica<=0;best_cut<=SCORE_INITIAL;done<=0;success<=0;
                pending_hit<=0;sweeps<=0;color<=0;local_words<=0;swap_words<=0;icm_words<=0;node_visits<=0;
            end
            INITIAL,SCORE,ICM_SCORE_A,ICM_SCORE_B: begin
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
                icm_rng<=icm_next;icm_words<=icm_words+1;
                if(disagreement_count==0 || disagreement_count>ICM_MAX_DISAGREEMENT) next_icm();
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
