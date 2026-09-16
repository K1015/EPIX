`timescale 1ns/1ps
// Fixed 288-variable instance. Arithmetic, annealing, source requests and scoring
// run in PL. One p-bit is updated at a time, in node order 0..287.
module maxcut26_core #(
    parameter WEIGHTS_FILE = "weights.hex",
    parameter QUANT_FILE = "quantization_rom.hex",
    parameter THRESH_FILE = "threshold_rom.hex"
) (
    input wire clk, rst_n, start, abort_run,
    input wire [31:0] seed,
    input wire epix_enable,
    output reg epix_active,
    output reg [31:0] fresh_updates, reuse_visits,
    output reg [31:0] cause_invalid, cause_unsupported, cause_drift, cause_age,
    output reg busy, done, aborted,
    output reg [287:0] spins, best_spins, initial_spins,
    output reg signed [15:0] energy, best_energy,
    output wire [15:0] best_cut,
    output reg [31:0] updates, cycles, first_hit,
    output wire [31:0] rng_words, rng_steps, rng_state,
    output reg [10:0] sweeps_completed,
    // Observation ports for simulation; left open in the AXI wrapper.
    output reg trace_valid, trace_initial, trace_take_fresh,
    output reg [1:0] trace_age_after,
    output reg [31:0] trace_visit, trace_word, trace_best_visit,
    output reg [8:0] trace_node,
    output reg [9:0] trace_sweep,
    output reg signed [15:0] trace_field,
    output reg signed [7:0] trace_q
);
    localparam [3:0] IDLE=0, INIT_REQ=1, INIT_WAIT=2, INIT_END=3,
        E_REQ=4, E_ACC=5, E_DONE=6, F_REQ=7, F_ACC=8,
        Q_REQ=9, Q_WAIT=10, T_REQ=11, T_WAIT=12, R_REQ=13, R_WAIT=14, REUSE_UPDATE=15;
    localparam signed [15:0] TARGET_ENERGY = -16'sd540;
    reg [3:0] phase;
    reg [8:0] node_index, column_index, energy_row;
    reg [9:0] sweep_index;
    reg signed [15:0] accumulator, field;
    reg signed [7:0] q;
    reg [31:0] threshold;
    reg [31:0] best_visit;
    // Each p-bit has one EPIX cache and access to one shared serial LFSR.
    reg [31:0] cached_word [0:287];
    reg signed [7:0] cached_q [0:287];
    reg [1:0] cache_age [0:287];
    reg [287:0] cache_valid;
    integer cache_index;
    wire invalid_word = !cache_valid[node_index];
    wire unsupported = spins[node_index] != !q[7];
    // Frozen delta_q=1: an integer change of any magnitude requires refresh.
    wire field_drift = q != cached_q[node_index];
    wire expired_age = cache_age[node_index] >= 2'd2;
    wire take_fresh = !epix_active || invalid_word || unsupported || field_drift || expired_age;
    wire reuse_update = phase == REUSE_UPDATE;
    reg [31:0] selected_cached_word;
    reg [31:0] source_state_pipeline;
    reg fresh_sample_bit, reused_sample_bit;
    reg signed [15:0] energy_if_zero, energy_if_one;
    reg better_if_zero, better_if_one, first_hit_if_zero, first_hit_if_one;
    wire [31:0] consumed_word = reuse_update ? selected_cached_word : source_word;

    (* rom_style = "block" *) reg signed [3:0] weights [0:82943];
    (* rom_style = "block" *) reg signed [7:0] quantization [0:131071];
    (* rom_style = "block" *) reg [31:0] thresholds [0:255];
    reg signed [3:0] weight_data;
    reg signed [7:0] quant_data;
    reg [31:0] threshold_data;
    wire [8:0] weight_row = (phase == E_REQ || phase == E_ACC) ? energy_row : node_index;
    wire [16:0] weight_addr = 17'(weight_row) * 17'd288 + 17'(column_index);
    wire [16:0] quant_addr = {sweep_index, field[6:0]};
    initial begin
        $readmemh(WEIGHTS_FILE, weights);
        $readmemh(QUANT_FILE, quantization);
        $readmemh(THRESH_FILE, thresholds);
    end
    // Explicit synchronous reads: a request phase precedes each consume phase.
    always @(posedge clk) begin
        if (phase == E_REQ || phase == F_REQ) weight_data <= weights[weight_addr];
        if (phase == Q_REQ) quant_data <= quantization[quant_addr];
        if (phase == T_REQ) threshold_data <= thresholds[q[7:0]];
    end

    wire source_busy, source_valid;
    wire [31:0] source_word;
    wire source_finishing = source_busy && rng_steps[4:0] == 5'd31;
    wire accept_start = phase == IDLE && start && !abort_run;
    (* DONT_TOUCH = "yes", KEEP_HIERARCHY = "yes" *)
    lfsr32_word rng (
        .clk(clk), .rst_n(rst_n), .load_seed(accept_start), .cancel(abort_run),
        .request(phase == INIT_REQ || phase == R_REQ), .seed(seed),
        .busy(source_busy), .valid(source_valid), .word(source_word),
        .state(rng_state), .words(rng_words), .steps(rng_steps)
    );
    wire signed [15:0] weight_extended = {{12{weight_data[3]}}, weight_data};
    wire signed [15:0] field_term = spins[column_index] ? weight_extended : -weight_extended;
    wire signed [15:0] energy_term = (spins[energy_row] == spins[column_index]) ? weight_extended : -weight_extended;
    wire signed [15:0] field_sum = accumulator + field_term;
    // Pipeline the selected source state during its existing serial advance.
    // On the final source step this register contains T^30(old_word), so two
    // exact Galois transitions predict the T^32 word registered on that edge.
    // The following original R_WAIT consume edge therefore needs no extra cycle.
    wire [31:0] selected_source_state = rng_state;
    wire [31:0] predicted_step1 = (source_state_pipeline >> 1) ^
                                  (source_state_pipeline[0] ? 32'h80200003 : 32'd0);
    wire [31:0] predicted_word = (predicted_step1 >> 1) ^
                                 (predicted_step1[0] ? 32'h80200003 : 32'd0);
    wire fresh_sample_result, reused_sample_result;
    // Both use the unchanged strict > comparator for negative q, including ties.
    pbit_heatbath fresh_sampler (.negative_field(q[7]), .random_word(predicted_word),
                                 .threshold(threshold), .sample_bit(fresh_sample_result));
    pbit_heatbath reused_sampler (.negative_field(q[7]), .random_word(selected_cached_word),
                                  .threshold(threshold_data), .sample_bit(reused_sample_result));
    wire next_bit = reuse_update ? reused_sample_bit : fresh_sample_bit;
    wire signed [15:0] next_energy = next_bit ? energy_if_one : energy_if_zero;
    wire next_is_better = next_bit ? better_if_one : better_if_zero;
    wire next_is_first_hit = next_bit ? first_hit_if_one : first_hit_if_zero;
    reg [287:0] next_spins;
    always @* begin
        next_spins = spins;
        next_spins[node_index] = next_bit;
    end
    wire signed [15:0] cut_numerator = -16'sd206 - best_energy;
    assign best_cut = $unsigned(cut_numerator) / 16'd2;

    always @(posedge clk) begin
        if (!rst_n) begin
            phase <= IDLE; busy <= 0; done <= 0; aborted <= 0;
            epix_active <= 0; fresh_updates <= 0; reuse_visits <= 0;
            cause_invalid <= 0; cause_unsupported <= 0; cause_drift <= 0; cause_age <= 0;
            cache_valid <= 0;
            selected_cached_word <= 0; source_state_pipeline <= 0;
            fresh_sample_bit <= 0; reused_sample_bit <= 0;
            energy_if_zero <= 0; energy_if_one <= 0;
            better_if_zero <= 0; better_if_one <= 0;
            first_hit_if_zero <= 0; first_hit_if_one <= 0;
            for (cache_index=0; cache_index<288; cache_index=cache_index+1) begin
                cached_word[cache_index] <= 0; cached_q[cache_index] <= 0; cache_age[cache_index] <= 0;
            end
            spins <= 0; best_spins <= 0; initial_spins <= 0;
            energy <= 0; best_energy <= 0; updates <= 0; cycles <= 0;
            first_hit <= 32'hffffffff; sweeps_completed <= 0;
            node_index <= 0; column_index <= 0; energy_row <= 0; sweep_index <= 0;
            accumulator <= 0; field <= 0; q <= 0; threshold <= 0; best_visit <= 0;
            trace_valid <= 0; trace_initial <= 0; trace_take_fresh <= 0; trace_age_after <= 0; trace_visit <= 0; trace_word <= 0; trace_best_visit <= 0;
            trace_node <= 0; trace_sweep <= 0; trace_field <= 0; trace_q <= 0;
        end else begin
            trace_valid <= 0; trace_initial <= 0;
            if (busy) cycles <= cycles + 1;
            if (abort_run && busy) begin
                phase <= IDLE; busy <= 0; done <= 1; aborted <= 1;
            end else case (phase)
                IDLE: if (accept_start) begin
                    phase <= INIT_REQ; busy <= 1; done <= 0; aborted <= 0;
                    epix_active <= epix_enable; fresh_updates <= 0; reuse_visits <= 0;
                    cause_invalid <= 0; cause_unsupported <= 0; cause_drift <= 0; cause_age <= 0;
                    cache_valid <= 0;
                    selected_cached_word <= 0; source_state_pipeline <= 0;
                    fresh_sample_bit <= 0; reused_sample_bit <= 0;
                    energy_if_zero <= 0; energy_if_one <= 0;
                    better_if_zero <= 0; better_if_one <= 0;
                    first_hit_if_zero <= 0; first_hit_if_one <= 0;
                    for (cache_index=0; cache_index<288; cache_index=cache_index+1) begin
                        cached_word[cache_index] <= 0; cached_q[cache_index] <= 0; cache_age[cache_index] <= 0;
                    end
                    spins <= 0; best_spins <= 0; initial_spins <= 0;
                    energy <= 0; best_energy <= 0; updates <= 0; cycles <= 0;
                    first_hit <= 32'hffffffff; sweeps_completed <= 0;
                    node_index <= 0; column_index <= 0; energy_row <= 0; sweep_index <= 0;
                    accumulator <= 0; field <= 0; q <= 0; threshold <= 0; best_visit <= 0;
                end
                INIT_REQ: if (!source_busy) phase <= INIT_WAIT;
                INIT_WAIT: if (source_valid) begin
                    spins[node_index] <= source_word[0];
                    if (node_index == 287) phase <= INIT_END;
                    else begin node_index <= node_index + 1; phase <= INIT_REQ; end
                end
                INIT_END: begin
                    initial_spins <= spins; accumulator <= 0;
                    energy_row <= 0; column_index <= 0; phase <= E_REQ;
                end
                E_REQ: phase <= E_ACC;
                E_ACC: begin
                    if (column_index > energy_row) accumulator <= accumulator + energy_term;
                    if (column_index == 287) begin
                        column_index <= 0;
                        if (energy_row == 287) phase <= E_DONE;
                        else begin energy_row <= energy_row + 1; phase <= E_REQ; end
                    end else begin column_index <= column_index + 1; phase <= E_REQ; end
                end
                E_DONE: begin
                    trace_initial <= 1;
                    energy <= -accumulator; best_energy <= -accumulator; best_spins <= spins;
                    if (-accumulator == TARGET_ENERGY) first_hit <= 0;
                    accumulator <= 0; column_index <= 0; node_index <= 0; phase <= F_REQ;
                end
                F_REQ: phase <= F_ACC;
                F_ACC: begin
                    if (column_index == 287) begin field <= field_sum; phase <= Q_REQ; end
                    else begin accumulator <= field_sum; column_index <= column_index + 1; phase <= F_REQ; end
                end
                Q_REQ: begin
                    // The current state/field remain fixed until the update edge.
                    // Read the cache and prepare both energy outcomes before RNG use.
                    selected_cached_word <= cached_word[node_index];
                    source_state_pipeline <= selected_source_state;
                    energy_if_zero <= spins[node_index] ? energy + (field <<< 1) : energy;
                    energy_if_one <= spins[node_index] ? energy : energy - (field <<< 1);
                    phase <= Q_WAIT;
                end
                Q_WAIT: begin
                    q <= quant_data;
                    better_if_zero <= energy_if_zero < best_energy;
                    better_if_one <= energy_if_one < best_energy;
                    first_hit_if_zero <= energy_if_zero == TARGET_ENERGY && first_hit == 32'hffffffff;
                    first_hit_if_one <= energy_if_one == TARGET_ENERGY && first_hit == 32'hffffffff;
                    phase <= T_REQ;
                end
                T_REQ: phase <= T_WAIT;
                T_WAIT: begin
                    threshold <= threshold_data;
                    reused_sample_bit <= reused_sample_result;
                    phase <= take_fresh ? R_REQ : REUSE_UPDATE;
                end
                R_REQ: if (!source_busy) phase <= R_WAIT;
                R_WAIT, REUSE_UPDATE: begin
                    if (!reuse_update) begin
                        source_state_pipeline <= selected_source_state;
                        if (source_finishing) fresh_sample_bit <= fresh_sample_result;
                    end
                    if (reuse_update || source_valid) begin
                        if (reuse_update) begin
                            reuse_visits <= reuse_visits + 1;
                            cache_age[node_index] <= cache_age[node_index] + 1'b1;
                        end else begin
                            fresh_updates <= fresh_updates + 1;
                            cached_word[node_index] <= source_word;
                            cached_q[node_index] <= q;
                            cache_age[node_index] <= 0;
                            cache_valid[node_index] <= 1;
                            // Causes overlap, including in Fresh mode; these are not a partition.
                            if (invalid_word) cause_invalid <= cause_invalid + 1;
                            if (unsupported) cause_unsupported <= cause_unsupported + 1;
                            if (field_drift) cause_drift <= cause_drift + 1;
                            if (expired_age) cause_age <= cause_age + 1;
                        end
                        trace_take_fresh <= !reuse_update;
                        trace_age_after <= reuse_update ? cache_age[node_index] + 1'b1 : 2'd0;
                        spins <= next_spins; energy <= next_energy; updates <= updates + 1;
                        if (next_is_better) begin
                            best_energy <= next_energy; best_spins <= next_spins; best_visit <= updates + 1;
                        end
                        if (next_is_first_hit) first_hit <= updates + 1;
                        trace_valid <= 1; trace_visit <= updates + 1; trace_node <= node_index;
                        trace_sweep <= sweep_index; trace_field <= field; trace_q <= q; trace_word <= consumed_word;
                        trace_best_visit <= next_is_better ? updates + 1 : best_visit;
                        accumulator <= 0; column_index <= 0;
                        if (node_index == 287) begin
                            sweeps_completed <= sweeps_completed + 1; node_index <= 0;
                            if (sweep_index == 1023) begin phase <= IDLE; busy <= 0; done <= 1; end
                            else begin sweep_index <= sweep_index + 1; phase <= F_REQ; end
                        end else begin node_index <= node_index + 1; phase <= F_REQ; end
                    end
                end
                default: begin phase <= IDLE; busy <= 0; done <= 1; aborted <= 1; end
            endcase
        end
    end
endmodule
