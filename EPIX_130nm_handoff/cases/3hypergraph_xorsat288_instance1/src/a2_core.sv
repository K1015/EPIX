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
    output wire event_word_valid,
    output wire [3:0] event_beta,
    output wire coeff_read_event
`ifdef A2_VERIFY
    , output wire [32*N-1:0] debug_rng,
    output wire [FIELD_W*N-1:0] debug_saved_field,
    output wire [AGE_W*N-1:0] debug_age,
    output wire [N-1:0] debug_valid,
    output wire [N-1:0] debug_rng_clocks,
    output wire [N-1:0] debug_dirty,
    output wire [3:0] debug_phase
`endif
);
    typedef enum logic [3:0] {IDLE, SCORE_REQ, SCORE_RUN, DIR_REQ, DIR_CAP,
                              FIELD_REQ, FIELD_RUN, UPDATE, FINISHED,
                              INVALIDATE_DIR_REQ, INVALIDATE_DIR_CAP,
                              INVALIDATE_REQ, INVALIDATE_RUN} phase_t;
    phase_t phase;
    localparam bit FIELD_CACHE = FAMILY_XOR != 0 && DELTA_FIELD <= 2;
    wire [N-1:0] dirty_flat;
    logic row_cached_q;
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
    wire [N-1:0] sample_flat;
    localparam bit XOR_HOLD = FAMILY_XOR != 0 && DELTA_FIELD <= 2;
    localparam integer META_W=$clog2(MAX_REUSE+2);
    localparam logic [META_W-1:0] META_INVALID=META_W'(MAX_REUSE+1);
    wire [META_W*N-1:0] history_flat;
    wire [META_W-1:0] selected_history=history_flat[META_W*int'(site)+:META_W];
    wire selected_valid=selected_history != META_INVALID;
    // Store the saved field with fewer bits. Sign extension restores its value within FIELD_BOUND.
    localparam integer SAVED_FIELD_W=FIELD_BOUND>0 ? $clog2(FIELD_BOUND+1)+1 : 1;
    wire signed [FIELD_W-1:0] saved_field = saved_flat[FIELD_W*int'(site)+:FIELD_W];
    wire signed [FIELD_W:0] difference = {field_q[FIELD_W-1],field_q} - {saved_field[FIELD_W-1],saved_field};
    wire [FIELD_W:0] magnitude = difference < 0 ? $unsigned(-difference) : $unsigned(difference);
    // XOR fields change in steps of two. Equality detects refresh for drift thresholds of one or two.
    wire field_changed = XOR_HOLD ? field_q != saved_field :
        magnitude >= (FIELD_W+1)'(DELTA_FIELD);
    wire refresh = !mode_epix || !selected_valid ||
        spins[site] != !field_q[FIELD_W-1] || field_changed ||
        int'(selected_history) >= MAX_REUSE;
    // The same word, field, and beta give the same sample. Clear validity when beta changes.
    // Save fresh results for later SAT reuse.
    wire cached_sample = !refresh && (XOR_HOLD || (selected_valid && field_q == saved_field));
    wire sample_needed = phase == UPDATE && !cached_sample;
    logic [NODE_W-1:0] operand_site_q;
    logic signed [FIELD_W-1:0] operand_field_q;
    logic [3:0] operand_beta_q;
    wire operand_clk;
    a2_icg operand_gate(.clk,.enable(rst || (mode_epix && commit && !cached_sample)),.test_enable,.gclk(operand_clk));
    always @(posedge operand_clk) begin
        if(rst) begin
            operand_site_q <= '0; operand_field_q <= '0;
            operand_beta_q <= '0;
        end else if(mode_epix && commit && !cached_sample) begin
            operand_site_q <= site; operand_field_q <= field_q;
            operand_beta_q <= beta;
        end
    end
    // Fresh mode samples directly. EPIX retains sampler inputs and uses the committed LFSR word without advancing it again.
    wire operand_live = !mode_epix || sample_needed;
    wire [NODE_W-1:0] operand_site = operand_live ? site : operand_site_q;
    wire signed [FIELD_W-1:0] operand_field = operand_live ? field_q : operand_field_q;
    wire [3:0] operand_beta = operand_live ? beta : operand_beta_q;
    wire operand_refresh = operand_live && refresh;
    wire [31:0] current_word = rng_flat[32*int'(operand_site)+:32];
    function automatic [31:0] lfsr_next(input logic [31:0] value);
        lfsr_next = {value[30:0], value[31]^value[21]^value[1]^value[0]};
    endfunction
    `include "threshold.svh"
    wire [32:0] probability_threshold = threshold_rom(operand_beta,operand_field);
    wire [31:0] chosen_word = operand_refresh ? lfsr_next(current_word) : current_word;
    // XOR reuse keeps the word, field, and beta unchanged. Reuse the stored spin.
    wire next_spin = cached_sample ? (XOR_HOLD ? spins[site] : sample_flat[site]) :
        {1'b0,chosen_word} < probability_threshold;
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
        logic signed [SAVED_FIELD_W-1:0] saved_q;
        logic sample_q;
        wire seed_selected = load_seed && int'(seed_node) == p;
        wire fresh_selected = commit && refresh && int'(site) == p;
        wire gate_enable = rst || seed_selected || fresh_selected;
        a2_icg gate(.clk(rng_bank_clocks[p/32]), .enable(gate_enable), .test_enable, .gclk(rng_clocks[p]));
        assign rng_flat[32*p+:32] = state_q;
        assign saved_flat[FIELD_W*p+:FIELD_W] = FIELD_W'(saved_q);
        assign sample_flat[p] = sample_q;
        always @(posedge rng_clocks[p]) begin
            if (rst) begin state_q <= 32'd1; saved_q <= '0; sample_q <= 1'b0; end
            else if (seed_selected) begin state_q <= seed_data; saved_q <= '0; sample_q <= 1'b0; end
            else if (fresh_selected) begin state_q <= lfsr_next(state_q); saved_q <= SAVED_FIELD_W'(field_q); sample_q <= next_spin; end
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
            assign history_flat[(b*32+j)*META_W+:META_W] = history_q[j];
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
                DIR_REQ: if(!FIELD_CACHE || dirty_flat[site]) begin memory_enable=1; memory_address=MEM_AW'(site); end
                INVALIDATE_DIR_REQ: begin memory_enable=1; memory_address=MEM_AW'(site); end
                INVALIDATE_REQ: begin memory_enable=1; memory_address=row_base; end
                INVALIDATE_RUN: if(index_q+1'b1 < row_count) begin memory_enable=1; memory_address=row_base+index_q+1'b1; end
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
    // A dirty bit marks a field that may have changed. Reread coefficients only after a spin changes.
    for(genvar b=0;b<(N+31)/32;b=b+1) begin: field_cache_bank
        localparam integer K=N-32*b<32 ? N-32*b : 32;
        if(FIELD_CACHE) begin: enabled
            logic [K-1:0] dirty_q;
            wire clear_site=commit && int'(site)/32==b;
            wire mark_a=step && phase==INVALIDATE_RUN && int'(a)/32==b;
            wire mark_b=step && phase==INVALIDATE_RUN && int'(neighbor_b)/32==b;
            wire change=(clear_site && dirty_q[int'(site)%32]) ||
                (mark_a && !dirty_q[int'(a)%32]) ||
                (mark_b && !dirty_q[int'(neighbor_b)%32]);
            wire dirty_clk;
            a2_icg dirty_gate(.clk,.enable(rst || accept_start || change),.test_enable,.gclk(dirty_clk));
            assign dirty_flat[32*b+:K]=dirty_q;
            always @(posedge dirty_clk) begin
                if(rst || accept_start) dirty_q<='1;
                else begin
                    if(clear_site) dirty_q[int'(site)%32]<=1'b0;
                    if(mark_a) dirty_q[int'(a)%32]<=1'b1;
                    if(mark_b) dirty_q[int'(neighbor_b)%32]<=1'b1;
                end
            end
        end else begin: disabled
            assign dirty_flat[32*b+:K]='1;
        end
    end
    wire invalidation_done=step &&
        ((phase==INVALIDATE_RUN && index_q+1'b1==row_count) ||
         (phase==INVALIDATE_DIR_CAP && memory_data[MEM_AW+:MEM_AW]==0));
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
            energy<='0; row_cached_q<=1'b0;
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
                    DIR_REQ: begin
                        row_cached_q<=FIELD_CACHE && !dirty_flat[site];
                        if(FIELD_CACHE && !dirty_flat[site]) begin field_q<=saved_field; phase<=UPDATE; end
                        else phase<=DIR_CAP;
                    end
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
                    INVALIDATE_DIR_REQ: phase<=INVALIDATE_DIR_CAP;
                    INVALIDATE_DIR_CAP: begin
                        row_base<=memory_data[0+:MEM_AW]; row_count<=memory_data[MEM_AW+:MEM_AW];
                        index_q<='0;
                        if(memory_data[MEM_AW+:MEM_AW]!=0) phase<=INVALIDATE_REQ;
                    end
                    INVALIDATE_REQ: phase<=INVALIDATE_RUN;
                    INVALIDATE_RUN: if(index_q+1'b1 < row_count) index_q<=index_q+1'b1;
                    UPDATE: begin
                        energy<=post_energy[ENERGY_W-1:0];
                        if(post_energy==0 || (last_site && last_sweep && beta==15)) phase<=FINISHED;
                        else if(FIELD_CACHE && next_spin!=spins[site] && (row_cached_q || row_count!=0)) begin
                            index_q<='0;
                            phase<=row_cached_q ? INVALIDATE_DIR_REQ : INVALIDATE_REQ;
                        end
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
                if(invalidation_done) begin
                    phase<=DIR_REQ;
                    if(last_site) begin
                        site<='0;
                        if(last_sweep) begin sweep<='0; beta<=beta+1'b1; end
                        else sweep<=sweep+1'b1;
                    end else site<=site+1'b1;
                end
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
    assign event_new=next_spin; assign event_fresh=refresh; assign event_beta=beta;
    assign event_word_valid=!cached_sample;
`ifdef A2_VERIFY
    // Expose the retained word only during full-state simulation checks.
    wire [31:0] verification_word=rng_flat[32*int'(site)+:32];
    assign event_word=refresh ? lfsr_next(verification_word) : verification_word;
`else
    // A cache hit holds sampler inputs. Use event_word_valid to identify a current p-bit word.
    assign event_word=chosen_word;
`endif
`ifdef A2_VERIFY
    assign debug_dirty=dirty_flat;
    assign debug_rng=rng_flat; assign debug_saved_field=saved_flat; assign debug_age=age_flat;
    assign debug_valid=valid_flat; assign debug_rng_clocks=rng_clocks; assign debug_phase=phase;
    always @(posedge clk) if(!rst) begin
        if(commit) begin
            if(XOR_HOLD && !refresh) begin
                assert(field_q==saved_field) else $fatal(1,"XOR reuse changed field");
                assert(({1'b0,verification_word}<threshold_rom(beta,field_q))==spins[site])
                    else $fatal(1,"XOR hold differs from full sample");
            end
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
        assert(SAVED_FIELD_W<=FIELD_W);
        assert(MEM_W>=2*MEM_AW && MEM_W>=3*NODE_W+4+WEIGHT_W);
    end
`endif
endmodule
