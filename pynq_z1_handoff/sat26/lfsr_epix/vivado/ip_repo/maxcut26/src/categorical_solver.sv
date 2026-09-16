`timescale 1ns/1ps
// Autonomous sequential probSAT. ROMs bind this core to the frozen input CNF.
module categorical_solver(
    input logic clk, rst, start,
    input logic epix_enable,
    output logic busy,
    output logic [31:0] cycles, initial_assignment,
    output wire [31:0] source_words, source_steps,
    input logic [31:0] seed, flip_limit,
    output logic done, success,
    output logic [25:0] assignment,
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
    localparam integer CLAUSES=112;
    logic epix_active;
    (* rom_style = "block" *) reg [31:0] masses [0:4095];
    reg [31:0] packed_mass_data;
    initial begin $readmemh("masses.hex",masses); end
    // Explicit constant cases avoid tool-dependent global-array function inference.
    function automatic [23:0] clause_rom(input logic [15:0] index);
        begin case(index)
            16'd0: clause_rom=24'h0c970f;
            16'd1: clause_rom=24'h089883;
            16'd2: clause_rom=24'h8c1812;
            16'd3: clause_rom=24'h021694;
            16'd4: clause_rom=24'h86958f;
            16'd5: clause_rom=24'h811799;
            16'd6: clause_rom=24'h0f1096;
            16'd7: clause_rom=24'h86810a;
            16'd8: clause_rom=24'h0f0704;
            16'd9: clause_rom=24'h958300;
            16'd10: clause_rom=24'h148f0b;
            16'd11: clause_rom=24'h808c94;
            16'd12: clause_rom=24'h150603;
            16'd13: clause_rom=24'h930b85;
            16'd14: clause_rom=24'h99040a;
            16'd15: clause_rom=24'h160e02;
            16'd16: clause_rom=24'h098f05;
            16'd17: clause_rom=24'h118f10;
            16'd18: clause_rom=24'h079388;
            16'd19: clause_rom=24'h830d88;
            16'd20: clause_rom=24'h84890b;
            16'd21: clause_rom=24'h839415;
            16'd22: clause_rom=24'h898386;
            16'd23: clause_rom=24'h010f84;
            16'd24: clause_rom=24'h0b8a88;
            16'd25: clause_rom=24'h89910b;
            16'd26: clause_rom=24'h8a8705;
            16'd27: clause_rom=24'h928b93;
            16'd28: clause_rom=24'h0c9205;
            16'd29: clause_rom=24'h8c8a09;
            16'd30: clause_rom=24'h029592;
            16'd31: clause_rom=24'h830218;
            16'd32: clause_rom=24'h150f90;
            16'd33: clause_rom=24'h031309;
            16'd34: clause_rom=24'h899000;
            16'd35: clause_rom=24'h941681;
            16'd36: clause_rom=24'h170d13;
            16'd37: clause_rom=24'h0c8291;
            16'd38: clause_rom=24'h839716;
            16'd39: clause_rom=24'h0a1314;
            16'd40: clause_rom=24'h191806;
            16'd41: clause_rom=24'h0b0399;
            16'd42: clause_rom=24'h960a01;
            16'd43: clause_rom=24'h940c12;
            16'd44: clause_rom=24'h908f17;
            16'd45: clause_rom=24'h16918f;
            16'd46: clause_rom=24'h148b19;
            16'd47: clause_rom=24'h0f988d;
            16'd48: clause_rom=24'h101697;
            16'd49: clause_rom=24'h18158a;
            16'd50: clause_rom=24'h068280;
            16'd51: clause_rom=24'h0f9307;
            16'd52: clause_rom=24'h089303;
            16'd53: clause_rom=24'h898b02;
            16'd54: clause_rom=24'h890302;
            16'd55: clause_rom=24'h058695;
            16'd56: clause_rom=24'h081894;
            16'd57: clause_rom=24'h03170b;
            16'd58: clause_rom=24'h0f868a;
            16'd59: clause_rom=24'h140d0b;
            16'd60: clause_rom=24'h19100e;
            16'd61: clause_rom=24'h151189;
            16'd62: clause_rom=24'h8e0596;
            16'd63: clause_rom=24'h828f0e;
            16'd64: clause_rom=24'h010317;
            16'd65: clause_rom=24'h859816;
            16'd66: clause_rom=24'h898a03;
            16'd67: clause_rom=24'h071590;
            16'd68: clause_rom=24'h060599;
            16'd69: clause_rom=24'h831793;
            16'd70: clause_rom=24'h129781;
            16'd71: clause_rom=24'h081418;
            16'd72: clause_rom=24'h878280;
            16'd73: clause_rom=24'h0d9896;
            16'd74: clause_rom=24'h041106;
            16'd75: clause_rom=24'h8e1789;
            16'd76: clause_rom=24'h93088d;
            16'd77: clause_rom=24'h04080e;
            16'd78: clause_rom=24'h850d8c;
            16'd79: clause_rom=24'h820907;
            16'd80: clause_rom=24'h959809;
            16'd81: clause_rom=24'h030701;
            16'd82: clause_rom=24'h129506;
            16'd83: clause_rom=24'h039397;
            16'd84: clause_rom=24'h86018e;
            16'd85: clause_rom=24'h97830a;
            16'd86: clause_rom=24'h0f0580;
            16'd87: clause_rom=24'h8b0486;
            16'd88: clause_rom=24'h0b8506;
            16'd89: clause_rom=24'h81170e;
            16'd90: clause_rom=24'h198b0f;
            16'd91: clause_rom=24'h080397;
            16'd92: clause_rom=24'h809006;
            16'd93: clause_rom=24'h0f0a07;
            16'd94: clause_rom=24'h93080f;
            16'd95: clause_rom=24'h160108;
            16'd96: clause_rom=24'h8c830f;
            16'd97: clause_rom=24'h010394;
            16'd98: clause_rom=24'h081512;
            16'd99: clause_rom=24'h901700;
            16'd100: clause_rom=24'h0d0e03;
            16'd101: clause_rom=24'h091294;
            16'd102: clause_rom=24'h998301;
            16'd103: clause_rom=24'h82800d;
            16'd104: clause_rom=24'h0c9882;
            16'd105: clause_rom=24'h121790;
            16'd106: clause_rom=24'h928013;
            16'd107: clause_rom=24'h820703;
            16'd108: clause_rom=24'h8e1803;
            16'd109: clause_rom=24'h8d910c;
            16'd110: clause_rom=24'h878a0d;
            16'd111: clause_rom=24'h8a8919;
            default: clause_rom=0;
        endcase end
    endfunction
    localparam integer CW = $clog2(CLAUSES);
    localparam [15:0] LAST_CLAUSE = 16'(CLAUSES-1);
    localparam [4:0] IDLE=0, INIT_RNG=1, INIT_CLAUSES=2, INIT_DONE=3,
        SELECT_CLAUSE=4, READ_LITERALS=5, SCAN_BREAKS=6, READ_MASSES=7,
        LOAD_CACHE=8, CONDITION=9, REFILL=10, FLIP_ATOM=11,
        UPDATE_POS=12, UPDATE_NEG=13, STEP_DONE=14, FINISH=15, MASS_WAIT=16, MUL1=17, MUL2=18, SAMPLE=19, MOD_STEP=20, MOD_DONE=21;
    logic [4:0] phase;
    always @(posedge clk) if (phase==READ_MASSES) packed_mass_data<=masses[{break0[3:0],break1[3:0],break2[3:0]}];
    logic [15:0] scan_clause;
    logic [6:0] init_index, best_var;
    logic [31:0] limit_reg;
    logic [7:0] selected_lit0, selected_lit1, selected_lit2;
    logic [1:0] true_count [0:CLAUSES-1];
    logic [CW-1:0] false_clause [0:CLAUSES-1];
    logic [CW-1:0] where_false [0:CLAUSES-1];
    // In baseline these arrays are unobserved and synthesis removes them.
    wire [46:0] retained_value [0:CLAUSES-1];
    wire [46:0] retained_range [0:CLAUSES-1];
    wire [7:0] retained_age [0:CLAUSES-1];
    wire [31:0] rng_state, word32;
    wire source_busy, source_valid;
    wire [30:0] source_word = word32[31:1];
    wire [CW-1:0] scan_index=scan_clause[CW-1:0], selected_index=selected_clause[CW-1:0];
    wire [CW-1:0] unsat_tail=CW'(num_unsat-1'b1);
    wire refresh_cache = !epix_active || retained_age[selected_index] >= 8'd254;
    wire need_word=phase==INIT_RNG || phase==REFILL || (phase==LOAD_CACHE && refresh_cache);
    (* DONT_TOUCH = "yes", KEEP_HIERARCHY = "yes" *)
    lfsr32_word rng(.clk(clk),.rst_n(!rst),.load_seed(start && phase==IDLE),.cancel(1'b0),
        .request(need_word && !source_busy && !source_valid),.seed(seed),.busy(source_busy),
        .valid(source_valid),.word(word32),.state(rng_state),.words(source_words),.steps(source_steps));
    reg [15:0] mod_value, mod_rem;
    reg [4:0] mod_bit;
    wire [16:0] rem_next={mod_rem,mod_value[mod_bit]};
    wire [23:0] scan_literals = clause_rom(scan_clause);
    wire [7:0] scan_lit0=scan_literals[7:0],
        scan_lit1=scan_literals[15:8], scan_lit2=scan_literals[23:16];
    wire [23:0] selected_literals = clause_rom(selected_clause);
    wire [1:0] initial_true =
        {1'b0,(assignment[scan_lit0[6:0]]==scan_lit0[7])} +
        {1'b0,(assignment[scan_lit1[6:0]]==scan_lit1[7])} +
        {1'b0,(assignment[scan_lit2[6:0]]==scan_lit2[7])};
    function automatic has_literal(input logic [23:0] packed_clause,
                                    input logic [7:0] literal_value);
        begin
            has_literal = packed_clause[7:0]==literal_value ||
                packed_clause[15:8]==literal_value || packed_clause[23:16]==literal_value;
        end
    endfunction
    wire breaks0 = has_literal(scan_literals, selected_lit0 ^ 8'h80);
    wire breaks1 = has_literal(scan_literals, selected_lit1 ^ 8'h80);
    wire breaks2 = has_literal(scan_literals, selected_lit2 ^ 8'h80);
    wire makes_true = has_literal(scan_literals, {assignment[best_var],best_var});
    wire makes_false = has_literal(scan_literals, {~assignment[best_var],best_var});
    wire [33:0] packed_mass = {1'b0,packed_mass_data[31:16],1'b0,packed_mass_data[15:0]};
    wire [30:0] unit_range = cache_range[46:16];
    wire [46:0] usable_range = {unit_range,16'b0};
    reg [46:0] width0, width1, width2, width01;
    logic [1:0] sampled_index;
    logic [46:0] sampled_value, sampled_range;
    always_comb begin
        if (cache_value < width0) begin
            sampled_index=0; sampled_value=cache_value; sampled_range=width0;
        end else if (cache_value < width01) begin
            sampled_index=1; sampled_value=cache_value-width0; sampled_range=width1;
        end else begin
            sampled_index=2; sampled_value=cache_value-width01; sampled_range=width2;
        end
    end
    wire [6:0] chosen_var = chosen_index==0 ? selected_lit0[6:0] :
        chosen_index==1 ? selected_lit1[6:0] : selected_lit2[6:0];
    // Clock enables retain each clause residual only on initialization or a draw.
    for (genvar c=0; c<CLAUSES; c=c+1) begin: clause_cache
        reg [46:0] value_reg, range_reg;
        reg [7:0] age_reg;
        assign retained_value[c]=value_reg;
        assign retained_range[c]=range_reg;
        assign retained_age[c]=age_reg;
        always @(posedge clk) begin
            if (phase==INIT_CLAUSES && scan_clause==c) begin
                value_reg<=0; range_reg<=0; age_reg<=255;
            end else if (phase==SAMPLE && selected_clause==c) begin
                value_reg<=sampled_value; range_reg<=sampled_range; age_reg<=cache_age;
            end
        end
    end
    assign phase_out=phase;
    assign event_out=phase==INIT_DONE ? 3'd1 : phase==STEP_DONE ? 3'd2 : 3'd0;
    assign rng_state_out=rng_state;

    always_ff @(posedge clk) begin
        if (rst) begin
            phase<=IDLE; done<=0; success<=0; busy<=0; cycles<=0; epix_active<=0; initial_assignment<=0; width0<=0; width1<=0; width2<=0; width01<=0; mod_value<=0; mod_rem<=0; mod_bit<=0; assignment<=0;
            flips<=0; raw_words<=0; reused_visits<=0; refills<=0; initial_draws<=0;
            num_unsat<=0; selected_clause<=0; chosen_index<=0;
            break0<=0; break1<=0; break2<=0; mass0<=0; mass1<=0; mass2<=0;
            cache_value<=0; cache_range<=0; cache_age<=0;
            scan_clause<=0; init_index<=0; best_var<=0; limit_reg<=0;
            selected_lit0<=0; selected_lit1<=0; selected_lit2<=0;
        end else begin
            if (busy) cycles<=cycles+1;
            case (phase)
                IDLE: if (start) begin
                    busy<=1; cycles<=0; epix_active<=epix_enable;
                    done<=0; success<=0; assignment<=0;
                    flips<=0; raw_words<=0; reused_visits<=0; refills<=0; initial_draws<=0;
                    num_unsat<=0; selected_clause<=0; chosen_index<=0;
                    break0<=0; break1<=0; break2<=0; mass0<=0; mass1<=0; mass2<=0;
                    cache_value<=0; cache_range<=0; cache_age<=0;
                    scan_clause<=0; init_index<=0; limit_reg<=flip_limit; phase<=INIT_RNG;
                end
                INIT_RNG: if (source_valid) begin
                    assignment[init_index]<=source_word[0];
                    initial_draws<=initial_draws+1;
                    if (init_index==25) begin scan_clause<=0; phase<=INIT_CLAUSES; end
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
                    initial_assignment<={6'b0,assignment};
                    if (num_unsat==0 || limit_reg==0) phase<=FINISH;
                    else phase<=SELECT_CLAUSE;
                end
                SELECT_CLAUSE: begin
                    mod_value<=flips[15:0]; mod_rem<=0; mod_bit<=15; phase<=MOD_STEP;
                end
                MOD_STEP: begin
                    mod_rem<=rem_next>=num_unsat ? rem_next-num_unsat : rem_next;
                    if (mod_bit==0) phase<=MOD_DONE; else mod_bit<=mod_bit-1;
                end
                MOD_DONE: begin
                    selected_clause<=false_clause[mod_rem[CW-1:0]]; phase<=READ_LITERALS;
                end
                READ_LITERALS: begin
                    selected_lit0<=selected_literals[7:0];
                    selected_lit1<=selected_literals[15:8];
                    selected_lit2<=selected_literals[23:16];
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
                READ_MASSES: phase<=MASS_WAIT;
                MASS_WAIT: begin
                    mass0<=packed_mass[16:0]; mass1<=packed_mass[33:17];
                    mass2<=17'd65536-packed_mass[16:0]-packed_mass[33:17];
                    phase<=LOAD_CACHE;
                end
                LOAD_CACHE: begin
                    if (refresh_cache && source_valid) begin
                        cache_value<={16'b0,source_word}; cache_range<=47'd2147483648;
                        cache_age<=0; raw_words<=raw_words+1;
                    end else if (!refresh_cache) begin
                        cache_value<=retained_value[selected_index];
                        cache_range<=retained_range[selected_index];
                        cache_age<=retained_age[selected_index]+1;
                        reused_visits<=reused_visits+1;
                    end
                    if (!refresh_cache || source_valid) phase<=CONDITION;
                end
                CONDITION: begin
                    if (cache_range<65536) phase<=REFILL;
                    else if (cache_value>=usable_range) begin
                        cache_value<=cache_value-usable_range;
                        cache_range<=cache_range-usable_range;
                    end else phase<=MUL1;
                end
                MUL1: begin width0<=unit_range*mass0; width1<=unit_range*mass1; width2<=unit_range*mass2; phase<=MUL2; end
                MUL2: begin width01<=width0+width1; phase<=SAMPLE; end
                SAMPLE: begin
                    chosen_index<=sampled_index; cache_value<=sampled_value; cache_range<=sampled_range; phase<=FLIP_ATOM;
                end
                REFILL: if (source_valid) begin
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
                FINISH: begin busy<=0; done<=1; success<=num_unsat==0; phase<=IDLE; end
                default: phase<=IDLE;
            endcase
        end
    end
endmodule
