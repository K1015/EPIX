`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
// Autonomous sequential probSAT. ROMs bind this core to the frozen input CNF.
module categorical_solver #(
    parameter integer VARIABLES = 32,
    parameter EPIX_ENABLE = `EPIX_MODE
)(
    input logic clk, rst, start,
    input logic [31:0] seed, flip_limit,
    output logic done, success,
    output logic [VARIABLES-1:0] assignment,
    output logic [31:0] flips, raw_words, reused_visits, refills, initial_draws,
    output logic [15:0] num_unsat,
    output logic [4:0] phase_out,
    output logic [2:0] event_out,
    output logic [15:0] selected_clause,
    output logic [1:0] chosen_index,
    output logic [7:0] break0, break1, break2,
    output logic [16:0] mass0, mass1, mass2,
    output logic [46:0] cache_value, cache_range,
    output logic [7:0] cache_age,
    output logic [31:0] rng_state_out
);
    `include "instance.svh"
    localparam integer CW = $clog2(CLAUSES);
    localparam integer VW=$clog2(VARIABLES), LW=VW+1;
    localparam [15:0] LAST_CLAUSE = 16'(CLAUSES-1);
    localparam [4:0] IDLE=0, INIT_RNG=1, INIT_CLAUSES=2, INIT_DONE=3,
        SELECT_CLAUSE=4, READ_LITERALS=5, SCAN_BREAKS=6, READ_MASSES=7,
        LOAD_CACHE=8, CONDITION=9, REFILL=10, FLIP_ATOM=11,
        UPDATE_POS=12, UPDATE_NEG=13, STEP_DONE=14, FINISH=15;
    logic [4:0] phase;
    logic [15:0] scan_clause;
    logic [VW-1:0] init_index, best_var;
    logic [31:0] limit_reg;
    logic [LW-1:0] selected_lit0, selected_lit1, selected_lit2;
    logic [1:0] true_count [0:CLAUSES-1];
    logic [CW-1:0] false_clause [0:CLAUSES-1];
    logic [CW-1:0] where_false [0:CLAUSES-1];
    // In baseline these arrays are unobserved and synthesis removes them.
    wire [46:0] retained_value [0:CLAUSES-1];
    wire [46:0] retained_range [0:CLAUSES-1];
    wire [7:0] retained_age [0:CLAUSES-1];
    logic [31:0] rng_state;

    function automatic [31:0] advance(input logic [31:0] value);
        reg [31:0] x;
        begin
            x = value ^ (value << 13);
            x = x ^ (x >> 17);
            advance = x ^ (x << 5);
        end
    endfunction
    wire [31:0] next_rng = advance(rng_state);
    wire [30:0] source_word = next_rng[31:1];
    wire [CW-1:0] scan_index=scan_clause[CW-1:0], selected_index=selected_clause[CW-1:0];
    wire [CW-1:0] unsat_tail=CW'(num_unsat-1'b1);
    wire [CW-1:0] select_index=CW'(flips % {16'b0,num_unsat});
    wire refresh_cache = !EPIX_ENABLE || retained_age[selected_index] >= 8'd254;
    wire request_word = phase==INIT_RNG || phase==REFILL ||
        (phase==LOAD_CACHE && refresh_cache);
    wire rng_clock;
    wire rng_enable = rst || (start && phase==IDLE) || request_word;
    sky130_fd_sc_hd__dlclkp_1 rng_gate(
        .CLK(clk), .GATE(rng_enable), .GCLK(rng_clock));
    always_ff @(posedge rng_clock) begin
        if (rst) rng_state <= 32'd1;
        else if (start && phase==IDLE) rng_state <= seed==0 ? 32'd1 : seed;
        else if (request_word) rng_state <= next_rng;
    end

    wire [3*LW-1:0] scan_literals = clause_rom(scan_clause);
    wire [LW-1:0] scan_lit0=scan_literals[LW-1:0],
        scan_lit1=scan_literals[2*LW-1:LW], scan_lit2=scan_literals[3*LW-1:2*LW];
    wire [3*LW-1:0] selected_literals = clause_rom(selected_clause);
    wire [1:0] initial_true =
        {1'b0,(assignment[scan_lit0[VW-1:0]]==scan_lit0[VW])} +
        {1'b0,(assignment[scan_lit1[VW-1:0]]==scan_lit1[VW])} +
        {1'b0,(assignment[scan_lit2[VW-1:0]]==scan_lit2[VW])};
    function automatic has_literal(input logic [3*LW-1:0] packed_clause,
                                    input logic [LW-1:0] literal_value);
        begin
            has_literal = packed_clause[LW-1:0]==literal_value ||
                packed_clause[2*LW-1:LW]==literal_value || packed_clause[3*LW-1:2*LW]==literal_value;
        end
    endfunction
    wire breaks0 = has_literal(scan_literals, selected_lit0 ^ {1'b1,{VW{1'b0}}});
    wire breaks1 = has_literal(scan_literals, selected_lit1 ^ {1'b1,{VW{1'b0}}});
    wire breaks2 = has_literal(scan_literals, selected_lit2 ^ {1'b1,{VW{1'b0}}});
    wire makes_true = has_literal(scan_literals, {assignment[best_var],best_var});
    wire makes_false = has_literal(scan_literals, {~assignment[best_var],best_var});
    wire [33:0] packed_mass = mass_rom(break0,break1,break2);
    wire [30:0] unit_range = cache_range[46:16];
    wire [46:0] usable_range = {unit_range,16'b0};
    wire [46:0] width0 = unit_range * mass0;
    wire [46:0] width1 = unit_range * mass1;
    wire [46:0] width2 = unit_range * mass2;
    logic [1:0] sampled_index;
    logic [46:0] sampled_value, sampled_range;
    always_comb begin
        if (cache_value < width0) begin
            sampled_index=0; sampled_value=cache_value; sampled_range=width0;
        end else if (cache_value < width0+width1) begin
            sampled_index=1; sampled_value=cache_value-width0; sampled_range=width1;
        end else begin
            sampled_index=2; sampled_value=cache_value-width0-width1; sampled_range=width2;
        end
    end
    wire [VW-1:0] chosen_var = chosen_index==0 ? selected_lit0[VW-1:0] :
        chosen_index==1 ? selected_lit1[VW-1:0] : selected_lit2[VW-1:0];
    wire store_sample=phase==CONDITION && cache_range>=47'd65536 && cache_value<usable_range;
    if (EPIX_ENABLE) begin: retained_storage
        for (genvar c=0; c<CLAUSES; c=c+1) begin: clause_cache
            wire cache_clock;
            logic [46:0] value_reg, range_reg;
            logic [7:0] age_reg;
            assign retained_value[c]=value_reg;
            assign retained_range[c]=range_reg;
            assign retained_age[c]=age_reg;
            wire cache_enable=(phase==INIT_CLAUSES && scan_clause==16'(c)) ||
                (store_sample && selected_clause==16'(c));
            sky130_fd_sc_hd__dlclkp_1 cache_gate(
                .CLK(clk), .GATE(cache_enable), .GCLK(cache_clock));
            always_ff @(posedge cache_clock) begin
                if (phase==INIT_CLAUSES) begin
                    value_reg<=0; range_reg<=0; age_reg<=255;
                end else begin
                    value_reg<=sampled_value;
                    range_reg<=sampled_range;
                    age_reg<=cache_age;
                end
            end
        end
    end else begin: no_retained_storage
        for (genvar c=0; c<CLAUSES; c=c+1) begin: clause_cache
            assign retained_value[c]=0;
            assign retained_range[c]=0;
            assign retained_age[c]=255;
        end
    end
    assign phase_out=phase;
    assign event_out=phase==INIT_DONE ? 3'd1 : phase==STEP_DONE ? 3'd2 : 3'd0;
    assign rng_state_out=rng_state;

    always_ff @(posedge clk) begin
        if (rst) begin
            phase<=IDLE; done<=0; success<=0; assignment<=0;
            flips<=0; raw_words<=0; reused_visits<=0; refills<=0; initial_draws<=0;
            num_unsat<=0; selected_clause<=0; chosen_index<=0;
            break0<=0; break1<=0; break2<=0; mass0<=0; mass1<=0; mass2<=0;
            cache_value<=0; cache_range<=0; cache_age<=0;
            scan_clause<=0; init_index<=0; best_var<=0; limit_reg<=0;
            selected_lit0<=0; selected_lit1<=0; selected_lit2<=0;
        end else begin
            case (phase)
                IDLE: if (start) begin
                    done<=0; success<=0; assignment<=0;
                    flips<=0; raw_words<=0; reused_visits<=0; refills<=0; initial_draws<=0;
                    num_unsat<=0; selected_clause<=0; chosen_index<=0;
                    break0<=0; break1<=0; break2<=0; mass0<=0; mass1<=0; mass2<=0;
                    cache_value<=0; cache_range<=0; cache_age<=0;
                    scan_clause<=0; init_index<=0; limit_reg<=flip_limit; phase<=INIT_RNG;
                end
                INIT_RNG: begin
                    assignment[init_index]<=source_word[0];
                    initial_draws<=initial_draws+1;
                    if (init_index==VW'(VARIABLES-1)) begin scan_clause<=0; phase<=INIT_CLAUSES; end
                    else init_index<=init_index+1;
                end
                INIT_CLAUSES: begin
                    true_count[scan_index]<=initial_true;
                    where_false[scan_index]<=0;
                    if (initial_true==0) begin
                        false_clause[num_unsat[CW-1:0]]<=scan_index;
                        where_false[scan_index]<=num_unsat[CW-1:0];
                        num_unsat<=num_unsat+1;
                    end
                    if (scan_clause==LAST_CLAUSE) phase<=INIT_DONE;
                    else scan_clause<=scan_clause+1;
                end
                INIT_DONE: begin
                    if (num_unsat==0 || limit_reg==0) phase<=FINISH;
                    else phase<=SELECT_CLAUSE;
                end
                SELECT_CLAUSE: begin
                    selected_clause <= {{(16-CW){1'b0}},false_clause[select_index]};
                    phase<=READ_LITERALS;
                end
                READ_LITERALS: begin
                    selected_lit0<=selected_literals[LW-1:0];
                    selected_lit1<=selected_literals[2*LW-1:LW];
                    selected_lit2<=selected_literals[3*LW-1:2*LW];
                    break0<=0; break1<=0; break2<=0; scan_clause<=0; phase<=SCAN_BREAKS;
                end
                SCAN_BREAKS: begin
                    if (true_count[scan_index]==1) begin
                        break0<=break0+{7'b0,breaks0};
                        break1<=break1+{7'b0,breaks1};
                        break2<=break2+{7'b0,breaks2};
                    end
                    if (scan_clause==LAST_CLAUSE) phase<=READ_MASSES;
                    else scan_clause<=scan_clause+1;
                end
                READ_MASSES: begin
                    mass0<=packed_mass[16:0]; mass1<=packed_mass[33:17];
                    mass2<=17'd65536-packed_mass[16:0]-packed_mass[33:17];
                    phase<=LOAD_CACHE;
                end
                LOAD_CACHE: begin
                    if (refresh_cache) begin
                        cache_value<={16'b0,source_word}; cache_range<=47'd2147483648;
                        cache_age<=0; raw_words<=raw_words+1;
                    end else begin
                        cache_value<=retained_value[selected_index];
                        cache_range<=retained_range[selected_index];
                        cache_age<=retained_age[selected_index]+1;
                        reused_visits<=reused_visits+1;
                    end
                    phase<=CONDITION;
                end
                CONDITION: begin
                    if (cache_range<65536) phase<=REFILL;
                    else if (cache_value>=usable_range) begin
                        cache_value<=cache_value-usable_range;
                        cache_range<=cache_range-usable_range;
                    end else begin
                        chosen_index<=sampled_index;
                        cache_value<=sampled_value; cache_range<=sampled_range;
                        phase<=FLIP_ATOM;
                    end
                end
                REFILL: begin
                    cache_value<={cache_value[15:0],source_word};
                    cache_range<={cache_range[15:0],31'b0};
                    raw_words<=raw_words+1; refills<=refills+1; phase<=CONDITION;
                end
                FLIP_ATOM: begin
                    assignment[chosen_var]<=~assignment[chosen_var];
                    best_var<=chosen_var; scan_clause<=0; phase<=UPDATE_POS;
                end
                UPDATE_POS: begin
                    if (makes_true) begin
                        if (true_count[scan_index]==0) begin
                            false_clause[where_false[scan_index]]<=false_clause[unsat_tail];
                            where_false[false_clause[unsat_tail]]<=where_false[scan_index];
                            where_false[scan_index]<=0;
                            num_unsat<=num_unsat-1;
                        end
                        true_count[scan_index]<=true_count[scan_index]+1;
                    end
                    if (scan_clause==LAST_CLAUSE) begin scan_clause<=0; phase<=UPDATE_NEG; end
                    else scan_clause<=scan_clause+1;
                end
                UPDATE_NEG: begin
                    if (makes_false) begin
                        if (true_count[scan_index]==1) begin
                            false_clause[num_unsat[CW-1:0]]<=scan_index;
                            where_false[scan_index]<=num_unsat[CW-1:0]; num_unsat<=num_unsat+1;
                        end
                        true_count[scan_index]<=true_count[scan_index]-1;
                    end
                    if (scan_clause==LAST_CLAUSE) begin flips<=flips+1; phase<=STEP_DONE; end
                    else scan_clause<=scan_clause+1;
                end
                STEP_DONE: begin
                    if (num_unsat==0 || flips>=limit_reg) phase<=FINISH;
                    else phase<=SELECT_CLAUSE;
                end
                FINISH: begin done<=1; success<=num_unsat==0; phase<=IDLE; end
                default: phase<=IDLE;
            endcase
        end
    end
endmodule
