module a2_core #(
    parameter integer N=128, M=550, FAMILY_XOR=0,
    parameter integer NODE_W=$clog2(N), MEM_WORDS=N+4*M,
    parameter integer MEM_AW=$clog2(MEM_WORDS), MEM_W=32, WEIGHT_W=1,
    parameter integer FIELD_W=8, TOTAL_WEIGHT=M, FIELD_BOUND=27,
    parameter integer MAX_REUSE=2, DELTA_FIELD=2, MAX_SWEEPS=128,
    parameter integer AGE_W=$clog2(MAX_REUSE+1),
    parameter integer ENERGY_W=$clog2(TOTAL_WEIGHT+1)+1,
    parameter integer VISIT_W=$clog2(N*16*MAX_SWEEPS+1)
) (
    input wire clk, rst, test_enable, start, stop, step_allow,
    input wire epix_enable,
    input wire [15:0] sweeps_per_beta,
    input wire coeff_we,
    input wire [MEM_AW-1:0] coeff_address,
    input wire [MEM_W-1:0] coeff_data,
    input wire seed_we,
    input wire [NODE_W-1:0] seed_node,
    input wire [31:0] seed_data,
    input wire seed_spin,
    output wire cfg_ready, ready, busy, done,
    output logic [2:0] error_code,
    output wire [N-1:0] spins,
    output logic [N-1:0] best_spins,
    output logic signed [ENERGY_W-1:0] energy, best_energy,
    output logic [VISIT_W-1:0] visits, fresh_words, reuse_events,
    output wire commit_valid,
    output wire [NODE_W-1:0] event_site,
    output wire signed [FIELD_W-1:0] event_field,
    output wire event_old, event_new, event_fresh,
    output wire [31:0] event_word,
    output wire [3:0] event_beta,
    output wire coeff_read_event
`ifdef A2_VERIFY
    , output wire [32*N-1:0] debug_rng,
    output wire [FIELD_W*N-1:0] debug_saved_field,
    output wire [AGE_W*N-1:0] debug_age,
    output wire [N-1:0] debug_valid,
    output wire [N-1:0] debug_rng_clocks,
    output wire [3:0] debug_phase
`endif
);
    typedef enum logic [3:0] {IDLE, SCORE_REQ, SCORE_RUN, DIR_REQ, DIR_CAP,
                              FIELD_REQ, FIELD_RUN, UPDATE, FINISHED} phase_t;
    phase_t phase;
    localparam integer FACTOR_BASE=N+3*M;
    logic [MEM_AW:0] loaded_coefficients;
    logic [NODE_W:0] loaded_seeds;
    logic mode_epix;
    logic [15:0] sweep_limit;
    logic [$clog2(MAX_SWEEPS+1)-1:0] sweep;
    logic [3:0] beta;
    logic [NODE_W-1:0] site;
    logic [MEM_AW-1:0] index_q, row_base, row_count;
    logic signed [FIELD_W-1:0] field_acc, field_q;
    wire running = phase != IDLE && phase != FINISHED;
    wire step = running && step_allow && !stop && !rst;
    assign busy = running;
    assign done = phase == FINISHED;
    assign cfg_ready = !running && !start && !rst;
    assign ready = !running && !rst && int'(loaded_coefficients) == MEM_WORDS && int'(loaded_seeds) == N;
    wire accept_start = start && ready && sweeps_per_beta != 0 && int'(sweeps_per_beta) <= MAX_SWEEPS;
    wire load_coeff = cfg_ready && coeff_we && !seed_we && {1'b0,coeff_address} == loaded_coefficients && int'(loaded_coefficients) < MEM_WORDS;
    wire load_seed = cfg_ready && seed_we && !coeff_we && {1'b0,seed_node} == loaded_seeds && int'(loaded_seeds) < N && seed_data != 0;
    wire commit = step && phase == UPDATE;
    wire last_site = int'(site) == N-1;
    wire last_sweep = 16'(sweep)+16'd1 == sweep_limit;
    wire new_beta = commit && last_site && last_sweep && beta != 15 && post_energy != 0;
    wire clear_history = rst || accept_start || new_beta;

    wire [32*N-1:0] rng_flat;
    wire [FIELD_W*N-1:0] saved_flat;
    wire [AGE_W*N-1:0] age_flat;
    wire [N-1:0] valid_flat, rng_clocks;
    localparam integer META_W=$clog2(MAX_REUSE+2);
    localparam logic [META_W-1:0] META_INVALID=META_W'(MAX_REUSE+1);
    wire [31:0] current_word = rng_flat[32*int'(site)+:32];
    wire signed [FIELD_W-1:0] saved_field = saved_flat[FIELD_W*int'(site)+:FIELD_W];
    wire signed [FIELD_W:0] difference = {field_q[FIELD_W-1],field_q} - {saved_field[FIELD_W-1],saved_field};
    wire [FIELD_W:0] magnitude = difference < 0 ? $unsigned(-difference) : $unsigned(difference);
    wire refresh = !mode_epix || !valid_flat[site] ||
        spins[site] != !field_q[FIELD_W-1] || magnitude >= (FIELD_W+1)'(DELTA_FIELD) ||
        int'(age_flat[AGE_W*int'(site)+:AGE_W]) >= MAX_REUSE;
    function automatic [31:0] lfsr_next(input logic [31:0] value);
        lfsr_next = {value[30:0], value[31]^value[21]^value[1]^value[0]};
    endfunction
    `include "threshold.svh"
    wire [32:0] probability_threshold = threshold_rom(beta,field_q);
    wire [31:0] chosen_word = refresh ? lfsr_next(current_word) : current_word;
    wire next_spin = {1'b0,chosen_word} < probability_threshold;
    wire signed [ENERGY_W:0] energy_change = (next_spin == spins[site]) ? '0 :
        (spins[site] ? (ENERGY_W+1)'(field_q) : -(ENERGY_W+1)'(field_q));
    wire signed [ENERGY_W:0] post_energy = (ENERGY_W+1)'(energy) + energy_change;

    // Stop clocks upstream of inactive groups. Each p-bit keeps its own gate and 32-bit LFSR.
    wire [(N+31)/32-1:0] rng_bank_clocks;
    for(genvar b=0;b<(N+31)/32;b=b+1) begin: rng_clock_bank
        wire bank_event = rst || (load_seed && int'(seed_node)/32 == b) ||
            (commit && refresh && int'(site)/32 == b);
        a2_icg bank_gate(.clk,.enable(bank_event),.test_enable,.gclk(rng_bank_clocks[b]));
    end

    // Each p-bit owns its LFSR. Its saved field uses the same refresh clock.
    for (genvar p=0; p<N; p=p+1) begin: private_rng
        logic [31:0] state_q;
        logic signed [FIELD_W-1:0] saved_q;
        wire seed_selected = load_seed && int'(seed_node) == p;
        wire fresh_selected = commit && refresh && int'(site) == p;
        wire gate_enable = rst || seed_selected || fresh_selected;
        a2_icg gate(.clk(rng_bank_clocks[p/32]), .enable(gate_enable), .test_enable, .gclk(rng_clocks[p]));
        assign rng_flat[32*p+:32] = state_q;
        assign saved_flat[FIELD_W*p+:FIELD_W] = saved_q;
        always @(posedge rng_clocks[p]) begin
            if (rst) begin state_q <= 32'd1; saved_q <= '0; end
            else if (seed_selected) begin state_q <= seed_data; saved_q <= '0; end
            else if (fresh_selected) begin state_q <= lfsr_next(state_q); saved_q <= field_q; end
        end
    end

    // Groups of 32 sites share gates for small state and history registers.
    for (genvar b=0; b<(N+31)/32; b=b+1) begin: state_bank
        localparam integer K = N-32*b < 32 ? N-32*b : 32;
        logic [K-1:0] bits_q;
        logic [META_W-1:0] history_q[0:K-1];
        wire selected = int'(site)/32 == b;
        wire seed_selected = load_seed && int'(seed_node)/32 == b;
        wire bit_write = commit && selected && next_spin != spins[site];
        wire meta_write = commit && selected &&
            (!refresh || history_q[int'(site)%32] != META_W'(0));
        wire spin_clk, meta_clk;
        a2_icg spin_gate(.clk, .enable(rst || seed_selected || bit_write), .test_enable, .gclk(spin_clk));
        a2_icg meta_gate(.clk, .enable(clear_history || meta_write), .test_enable, .gclk(meta_clk));
        assign spins[b*32+:K] = bits_q;
        for(genvar j=0;j<K;j=j+1) begin: age_output
            assign valid_flat[b*32+j] = history_q[j] != META_INVALID;
            assign age_flat[(b*32+j)*AGE_W+:AGE_W] =
                history_q[j] == META_INVALID ? AGE_W'(0) : AGE_W'(history_q[j]);
        end
        always @(posedge spin_clk) begin
            if(rst) bits_q <= '0;
            else if(seed_selected) bits_q[int'(seed_node)%32] <= seed_spin;
            else if(bit_write) bits_q[int'(site)%32] <= next_spin;
        end
        always @(posedge meta_clk) begin
            if(clear_history) begin
                for(integer j=0;j<K;j=j+1) history_q[j] <= META_INVALID;
            end else if(meta_write) begin
                if(refresh) begin
                    history_q[int'(site)%32] <= '0;
                end else if(int'(history_q[int'(site)%32]) < MAX_REUSE)
                    history_q[int'(site)%32] <= history_q[int'(site)%32]+1'b1;
            end
        end
    end

    logic memory_enable;
    logic [MEM_AW-1:0] memory_address;
    wire [MEM_W-1:0] memory_data;
    always_comb begin
        memory_enable = load_coeff;
        memory_address = coeff_address;
        if(step) begin
            case(phase)
                SCORE_REQ: begin memory_enable=1; memory_address=MEM_AW'(FACTOR_BASE); end
                SCORE_RUN: if(int'(index_q)+1 < M) begin memory_enable=1; memory_address=MEM_AW'(FACTOR_BASE)+index_q+1'b1; end
                DIR_REQ: begin memory_enable=1; memory_address=MEM_AW'(site); end
                FIELD_REQ: begin memory_enable=1; memory_address=row_base; end
                FIELD_RUN: if(index_q+1'b1 < row_count) begin memory_enable=1; memory_address=row_base+index_q+1'b1; end
                default: begin end
            endcase
        end
    end
    a2_coeff_sram #(.WIDTH(MEM_W),.DEPTH(MEM_WORDS),.AW(MEM_AW)) coefficient_memory (
        .clk, .test_enable, .enable(memory_enable), .write_enable(load_coeff),
        .address(memory_address), .write_data(coeff_data), .read_data(memory_data)
    );
    assign coeff_read_event = memory_enable && !load_coeff;
    wire [NODE_W-1:0] a=memory_data[0+:NODE_W], c=memory_data[2*NODE_W+:NODE_W];
    wire [NODE_W-1:0] neighbor_b=memory_data[NODE_W+:NODE_W];
    wire [WEIGHT_W-1:0] occurrence_weight=memory_data[2*NODE_W+4+:WEIGHT_W];
    wire [WEIGHT_W-1:0] factor_weight=memory_data[3*NODE_W+4+:WEIGHT_W];
    logic signed [FIELD_W:0] contribution;
    logic violated;
    always_comb begin
        contribution = '0;
        if(FAMILY_XOR != 0) begin
            contribution = (memory_data[2*NODE_W+3]^spins[a]^spins[neighbor_b]) ?
                $signed({1'b0,FIELD_W'(occurrence_weight)}) : -$signed({1'b0,FIELD_W'(occurrence_weight)});
            violated = (spins[a]^spins[neighbor_b]^spins[c]) != memory_data[3*NODE_W+3];
        end else begin
            if(spins[a] != memory_data[2*NODE_W] && spins[neighbor_b] != memory_data[2*NODE_W+1])
                contribution = memory_data[2*NODE_W+2] ? $signed({1'b0,FIELD_W'(occurrence_weight)}) : -$signed({1'b0,FIELD_W'(occurrence_weight)});
            violated = spins[a] != memory_data[3*NODE_W] &&
                       spins[neighbor_b] != memory_data[3*NODE_W+1] && spins[c] != memory_data[3*NODE_W+2];
        end
    end
    wire signed [FIELD_W:0] sum_after_record = (FIELD_W+1)'(field_acc)+contribution;
    wire signed [ENERGY_W:0] score_after_record = (ENERGY_W+1)'(energy)+(violated ? (ENERGY_W+1)'({1'b0,factor_weight}) : '0);

    // Clock each counter only for reset, start, or its own increment.
    wire visit_clk, fresh_clk, reuse_clk;
    a2_icg visit_gate(.clk,.enable(rst || accept_start || commit),.test_enable,.gclk(visit_clk));
    a2_icg fresh_gate(.clk,.enable(rst || accept_start || (commit && refresh)),.test_enable,.gclk(fresh_clk));
    a2_icg reuse_gate(.clk,.enable(rst || accept_start || (commit && !refresh)),.test_enable,.gclk(reuse_clk));
    always @(posedge visit_clk) begin
        if(rst || accept_start) visits <= '0;
        else if(commit) visits <= visits+1'b1;
    end
    always @(posedge fresh_clk) begin
        if(rst || accept_start) fresh_words <= '0;
        else if(commit && refresh) fresh_words <= fresh_words+1'b1;
    end
    always @(posedge reuse_clk) begin
        if(rst || accept_start) reuse_events <= '0;
        else if(commit && !refresh) reuse_events <= reuse_events+1'b1;
    end

    wire control_clk;
    a2_icg control_gate(.clk, .enable(rst || load_coeff || load_seed || start || (cfg_ready && (coeff_we || seed_we)) || (running && (step_allow || stop))), .test_enable, .gclk(control_clk));
    // Size score and visit registers for the configured run limits.
    always @(posedge control_clk) begin
        if(rst) begin
            phase<=IDLE; loaded_coefficients<='0; loaded_seeds<='0; error_code<='0;
            mode_epix<=0; sweep_limit<=0; sweep<='0; beta<='0; site<='0;
            index_q<='0; row_base<='0; row_count<='0; field_acc<='0; field_q<='0;
            energy<='0;
        end else begin
            if(load_coeff) loaded_coefficients<=loaded_coefficients+1'b1;
            if(load_seed) loaded_seeds<=loaded_seeds+1'b1;
            if(cfg_ready && coeff_we && !load_coeff) error_code<=1;
            if(cfg_ready && seed_we && !load_seed) error_code<=2;
            if(start && !accept_start) error_code<=3;
            if(accept_start) begin
                phase<=SCORE_REQ; mode_epix<=epix_enable; sweep_limit<=sweeps_per_beta;
                sweep<='0; beta<='0; site<='0; index_q<='0; field_acc<='0; field_q<='0;
                energy<='0; error_code<='0;
            end else if(running && stop) phase<=FINISHED;
            else if(step) begin
                case(phase)
                    SCORE_REQ: begin index_q<='0; phase<=SCORE_RUN; end
                    SCORE_RUN: begin
                        energy<=score_after_record[ENERGY_W-1:0];
                        if(int'(index_q)==M-1) begin site<='0; phase<=score_after_record==0 ? FINISHED : DIR_REQ; end
                        else index_q<=index_q+1'b1;
                    end
                    DIR_REQ: phase<=DIR_CAP;
                    DIR_CAP: begin
                        row_base<=memory_data[0+:MEM_AW]; row_count<=memory_data[MEM_AW+:MEM_AW];
                        field_acc<='0; index_q<='0;
                        if(memory_data[MEM_AW+:MEM_AW]==0) begin field_q<='0; phase<=UPDATE; end
                        else phase<=FIELD_REQ;
                    end
                    FIELD_REQ: phase<=FIELD_RUN;
                    FIELD_RUN: begin
                        field_acc<=sum_after_record[FIELD_W-1:0];
                        if(index_q+1'b1==row_count) begin field_q<=sum_after_record[FIELD_W-1:0]; phase<=UPDATE; end
                        else index_q<=index_q+1'b1;
                    end
                    UPDATE: begin
                        energy<=post_energy[ENERGY_W-1:0];
                        if(post_energy==0 || (last_site && last_sweep && beta==15)) phase<=FINISHED;
                        else begin
                            phase<=DIR_REQ;
                            if(last_site) begin
                                site<='0;
                                if(last_sweep) begin sweep<='0; beta<=beta+1'b1; end
                                else sweep<=sweep+1'b1;
                            end else site<=site+1'b1;
                        end
                    end
                    default: begin end
                endcase
            end
        end
    end
    wire score_commit = step && phase==SCORE_RUN && int'(index_q)==M-1;
    wire better = commit && post_energy < (ENERGY_W+1)'(best_energy);
    wire best_clk;
    a2_icg best_gate(.clk, .enable(rst || score_commit || better), .test_enable, .gclk(best_clk));
    always @(posedge best_clk) begin
        if(rst) begin best_energy<='0; best_spins<='0; end
        else if(score_commit) begin best_energy<=score_after_record[ENERGY_W-1:0]; best_spins<=spins; end
        else if(better) begin
            best_energy<=post_energy[ENERGY_W-1:0];
            best_spins<=(spins & ~(N'(1)<<site)) | (N'(next_spin)<<site);
        end
    end
    assign commit_valid=commit;
    assign event_site=site; assign event_field=field_q; assign event_old=spins[site];
    assign event_new=next_spin; assign event_fresh=refresh; assign event_word=chosen_word; assign event_beta=beta;
`ifdef A2_VERIFY
    assign debug_rng=rng_flat; assign debug_saved_field=saved_flat; assign debug_age=age_flat;
    assign debug_valid=valid_flat; assign debug_rng_clocks=rng_clocks; assign debug_phase=phase;
    always @(posedge clk) if(!rst) begin
        if(commit) begin
            assert(current_word!=0 && chosen_word!=0) else $fatal(1,"Forbidden XOR LFSR state");
            assert(int'(field_q)>=-FIELD_BOUND && int'(field_q)<=FIELD_BOUND) else $fatal(1,"Field outside proved bound");
            assert(post_energy>=0 && int'(post_energy)<=TOTAL_WEIGHT) else $fatal(1,"Objective outside bound");
        end
        if(step && phase==FIELD_RUN)
            assert(int'(sum_after_record)>=-(1<<(FIELD_W-1)) && int'(sum_after_record)<(1<<(FIELD_W-1))) else $fatal(1,"Field overflow");
    end
    initial begin
        assert(N>1 && M>0 && DELTA_FIELD>=1 && MAX_REUSE>=1);
        assert(FIELD_BOUND<(1<<(FIELD_W-1)));
        assert(MEM_W>=2*MEM_AW && MEM_W>=3*NODE_W+4+WEIGHT_W);
    end
`endif
endmodule
