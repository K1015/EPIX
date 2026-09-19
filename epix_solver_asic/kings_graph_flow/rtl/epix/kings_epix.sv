`timescale 1ns/1ps
`ifndef KINGS_ROWS
`define KINGS_ROWS 10
`endif
`ifndef KINGS_COLS
`define KINGS_COLS 10
`endif
`ifndef KINGS_EPIX_DELTA_FIELD
`define KINGS_EPIX_DELTA_FIELD 0
`endif
`ifndef KINGS_EPIX_MAX_REUSE
`define KINGS_EPIX_MAX_REUSE 2
`endif

// EPIX solver specialized for an open-boundary rectangular King's graph.
// It has the same eight-direction local-field engine and one 32-bit LFSR per
// p-bit as the baseline.  All eight King-neighbor contributions are reduced
// in parallel in one CALCULATE clock.  A reuse completes on that clock; only
// a fresh random sample enters the following UPDATE clock.  The per-p-bit
// history is compact: a 5-bit King's field and a sweep tag share the selected
// LFSR bank's clock enable.  A single global bit validates all history after
// the mandatory-fresh first sweep.
module kings_epix_solver #(
    parameter integer ROWS = 10,
    parameter integer COLS = 10,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer ROW_W = (ROWS <= 2) ? 1 : $clog2(ROWS),
    parameter integer COL_W = (COLS <= 2) ? 1 : $clog2(COLS),
    parameter integer FIELD_W = 8,
    parameter integer PROB_GAIN = 1024,
    // Maximum allowed absolute field change.  DELTA_FIELD=0 means exact
    // equality; larger values deliberately enable approximate reuse.
    parameter integer DELTA_FIELD = 0,
    parameter integer MAX_REUSE = 2,
    // The physical wrapper serializes state initialization directly into
    // state_q.  No second N-bit initialization register is instantiated.
    parameter integer INDEXED_STATE_IO = 0
) (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic stop,
    input  logic [N-1:0] initial_state,
    input  logic state_load_en,
    input  logic [NODE_W-1:0] state_load_addr,
    input  logic state_load_data,
    input  logic [31:0] seed,
    input  logic [31:0] update_limit,
    output logic ready,
    output logic busy,
    output logic done,
    output logic [N-1:0] state_out,
    output logic [31:0] visits,
    output logic [31:0] fresh_words,
    output logic [31:0] reuse_events,
    output logic [63:0] cycle_count,
    output logic [NODE_W-1:0] active_node,
    output logic signed [FIELD_W-1:0] sampled_field
);
    localparam logic [1:0] IDLE = 2'd0;
    localparam logic [1:0] CALCULATE = 2'd1;
    localparam logic [1:0] UPDATE = 2'd2;
    localparam integer HISTORY_FIELD_W = 5;
    // The modulus must be able to represent MAX_REUSE+1 so age can force a
    // refresh before the tag wraps.
    localparam integer TAG_W = (MAX_REUSE < 1) ? 1 : $clog2(MAX_REUSE + 2);

    logic [1:0] phase;
    logic [N-1:0] state_q;
    logic [ROW_W-1:0] active_row;
    logic [COL_W-1:0] active_col;
    logic signed [FIELD_W-1:0] field_comb;
    logic signed [FIELD_W-1:0] field_latched;

    // The LFSR state is also the saved random word. On reuse it is read but
    // neither shifted nor clocked. This avoids a separate 32-bit saved-word
    // array while giving baseline and EPIX identical RNG storage.
    logic [31:0] pbit_lfsr_q [0:N-1];
    // Compact EPIX history: 5 field bits + a 2-bit timestamp at the default
    // MAX_REUSE=2.  There is deliberately no per-node age counter and no
    // per-node valid bit; age is reconstructed below from sweep_tag, while
    // the single shared history_ready bit validates the first complete sweep.
    logic signed [HISTORY_FIELD_W-1:0] stored_fields [0:N-1];
    logic [TAG_W-1:0] stored_tags [0:N-1];
    logic [TAG_W-1:0] sweep_tag;
    logic history_ready;

    logic expected_state;
    logic refresh_word;
    logic [31:0] selected_word;
    logic signed [FIELD_W-1:0] decision_field;
    logic signed [FIELD_W-1:0] stored_field_extended;
    logic signed [FIELD_W:0] field_difference;
    logic [FIELD_W:0] field_magnitude;
    // Combinational modulo age reconstructed from two timestamps.  This is a
    // TAG_W-bit wire, not a per-node age register.
    logic [TAG_W-1:0] reuse_age;
    logic signed [31:0] threshold_calculation;
    logic [15:0] probability_threshold;
    logic sampled_state;

    assign ready = (phase == IDLE) && !rst;
    assign busy = phase != IDLE;
    assign state_out = state_q;
    assign sampled_field = field_latched;

    function automatic logic [31:0] lfsr_next(input logic [31:0] value);
        logic feedback;
        logic [31:0] candidate;
        begin
            feedback = value[31] ^ value[21] ^ value[1] ^ value[0];
            candidate = {value[30:0], feedback};
            lfsr_next = (candidate == 32'd0) ? 32'd1 : candidate;
        end
    endfunction

    function automatic logic [31:0] pbit_seed(
        input logic [31:0] base_seed,
        input integer node
    );
        logic [31:0] mixed;
        begin
            mixed = base_seed ^ (32'h9e3779b9 * (node + 1));
            pbit_seed = mixed | 32'd1;
        end
    endfunction

    // Unit antiferromagnetic coupling J=-1.  The eight fixed directions are
    // evaluated together; boundary terms contribute zero.
    always_comb begin
        field_comb = '0;
        if ((active_row != 0) && (active_col != 0))
            field_comb = field_comb + (state_q[active_node-COLS-1] ? -1 : 1);
        if (active_row != 0)
            field_comb = field_comb + (state_q[active_node-COLS] ? -1 : 1);
        if ((active_row != 0) && (active_col != COLS-1))
            field_comb = field_comb + (state_q[active_node-COLS+1] ? -1 : 1);
        if (active_col != 0)
            field_comb = field_comb + (state_q[active_node-1'b1] ? -1 : 1);
        if (active_col != COLS-1)
            field_comb = field_comb + (state_q[active_node+1'b1] ? -1 : 1);
        if ((active_row != ROWS-1) && (active_col != 0))
            field_comb = field_comb + (state_q[active_node+COLS-1] ? -1 : 1);
        if (active_row != ROWS-1)
            field_comb = field_comb + (state_q[active_node+COLS] ? -1 : 1);
        if ((active_row != ROWS-1) && (active_col != COLS-1))
            field_comb = field_comb + (state_q[active_node+COLS+1] ? -1 : 1);
    end

    // Decide from field_comb during CALCULATE.  That lets an accepted reuse
    // bypass UPDATE entirely.  During UPDATE the same
    // logic sees field_latched and selects the fresh word to consume.
    //
    // DELTA_FIELD is inclusive: zero permits only an exact field match.
    // A fresh word is mandatory during the first sweep, after an unexpected
    // state, when the field change exceeds DELTA_FIELD, or when age exceeds
    // MAX_REUSE.  Reuse holds both the p-bit and its next random word.
    always_comb begin
        if (phase == CALCULATE)
            decision_field = field_comb;
        else
            decision_field = field_latched;
        stored_field_extended =
            {{(FIELD_W-HISTORY_FIELD_W){stored_fields[active_node][HISTORY_FIELD_W-1]}},
             stored_fields[active_node]};
        expected_state = !decision_field[FIELD_W-1];
        field_difference =
            $signed({decision_field[FIELD_W-1], decision_field}) -
            $signed({stored_field_extended[FIELD_W-1],
                     stored_field_extended});
        field_magnitude = field_difference[FIELD_W] ?
                          $unsigned(-field_difference) :
                          $unsigned(field_difference);
        reuse_age = sweep_tag - stored_tags[active_node];
        refresh_word = !history_ready ||
                       (state_q[active_node] != expected_state) ||
                       (field_magnitude > DELTA_FIELD) ||
                       (reuse_age > MAX_REUSE);
        if (refresh_word && history_ready)
            selected_word = lfsr_next(pbit_lfsr_q[active_node]);
        else
            selected_word = pbit_lfsr_q[active_node];
    end

    always_comb begin
        threshold_calculation = 32'sd32768 + $signed(field_latched) * PROB_GAIN;
        if (threshold_calculation <= 0)
            probability_threshold = 16'd0;
        else if (threshold_calculation >= 65535)
            probability_threshold = 16'hffff;
        else
            probability_threshold = threshold_calculation[15:0];
        sampled_state = selected_word[15:0] < probability_threshold;
    end

    // The selected LFSR, saved field and saved tag use one common enable so
    // clock-gating insertion can place one ICG above the whole bank.  No
    // per-node register is written on reuse.
    generate
        for (genvar pbit = 0; pbit < N; pbit = pbit + 1) begin : lfsr_banks
            wire selected_refresh = (phase == UPDATE) &&
                                    (active_node == NODE_W'(pbit));
            wire bank_enable = rst || (start && ready) || selected_refresh;
            always_ff @(posedge clk) begin
                if (bank_enable) begin
                    if (rst) begin
                        pbit_lfsr_q[pbit] <= pbit_seed(32'd1, pbit);
                        stored_fields[pbit] <= '0;
                        stored_tags[pbit] <= '0;
                    end else if (start && ready) begin
                        pbit_lfsr_q[pbit] <= pbit_seed(seed, pbit);
                        stored_fields[pbit] <= '0;
                        stored_tags[pbit] <= '0;
                    end else begin
                        pbit_lfsr_q[pbit] <= selected_word;
                        stored_fields[pbit] <= field_latched[HISTORY_FIELD_W-1:0];
                        stored_tags[pbit] <= sweep_tag;
                    end
                end
            end
        end
    endgenerate

    // Complete one logical visit.  Reuse calls this task on the CALCULATE
    // edge; a fresh sample calls it one clock later from UPDATE.
    task automatic complete_visit(input logic reused);
        begin
            visits <= visits + 32'd1;
            if (reused)
                reuse_events <= reuse_events + 32'd1;

            if ((active_row == ROWS-1) && (active_col == COLS-1)) begin
                sweep_tag <= sweep_tag + 1'b1;
                history_ready <= 1'b1;
            end

            if (visits + 32'd1 >= update_limit) begin
                phase <= IDLE;
                done <= 1'b1;
            end else begin
                if (active_col == COLS-1) begin
                    active_col <= '0;
                    if (active_row == ROWS-1) begin
                        active_row <= '0;
                        active_node <= '0;
                    end else begin
                        active_row <= active_row + 1'b1;
                        active_node <= active_node + 1'b1;
                    end
                end else begin
                    active_col <= active_col + 1'b1;
                    active_node <= active_node + 1'b1;
                end
                phase <= CALCULATE;
            end
        end
    endtask

    always_ff @(posedge clk) begin
        if (rst) begin
            phase <= IDLE;
            state_q <= '0;
            active_node <= '0;
            active_row <= '0;
            active_col <= '0;
            field_latched <= '0;
            visits <= '0;
            fresh_words <= '0;
            reuse_events <= '0;
            cycle_count <= '0;
            sweep_tag <= '0;
            history_ready <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && ready) begin
                if (!INDEXED_STATE_IO)
                    state_q <= initial_state;
                active_node <= '0;
                active_row <= '0;
                active_col <= '0;
                field_latched <= '0;
                visits <= '0;
                fresh_words <= '0;
                reuse_events <= '0;
                cycle_count <= '0;
                sweep_tag <= '0;
                history_ready <= 1'b0;
                if (update_limit == 0) begin
                    phase <= IDLE;
                    done <= 1'b1;
                end else begin
                    phase <= CALCULATE;
                end
            end else if ((phase == IDLE) && INDEXED_STATE_IO &&
                         state_load_en && ($unsigned(state_load_addr) < N)) begin
                state_q[state_load_addr] <= state_load_data;
            end else if (busy && stop) begin
                phase <= IDLE;
                done <= 1'b1;
            end else if (phase == CALCULATE) begin
                cycle_count <= cycle_count + 64'd1;
                field_latched <= field_comb;
                if (refresh_word)
                    phase <= UPDATE;
                else
                    complete_visit(1'b1);
            end else if (phase == UPDATE) begin
                cycle_count <= cycle_count + 64'd1;
                state_q[active_node] <= sampled_state;
                fresh_words <= fresh_words + 32'd1;
                complete_visit(1'b0);
            end
        end
    end

    // synopsys translate_off
    initial begin
        if ((ROWS < 2) || (COLS < 2) || (N != ROWS*COLS))
            $fatal(1, "invalid King's-graph dimensions");
        if (FIELD_W < 5 || FIELD_W > 31)
            $fatal(1, "FIELD_W must represent the King's field range -8..+8");
        if ((DELTA_FIELD < 0) || (MAX_REUSE < 0))
            $fatal(1, "invalid EPIX reuse parameters");
    end
    // synopsys translate_on
endmodule

module kings_epix_top #(
    parameter integer ROWS = `KINGS_ROWS,
    parameter integer COLS = `KINGS_COLS,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer DELTA_FIELD = `KINGS_EPIX_DELTA_FIELD,
    parameter integer MAX_REUSE = `KINGS_EPIX_MAX_REUSE
) (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic stop,
    input  logic [N-1:0] initial_state,
    input  logic [31:0] seed,
    input  logic [31:0] update_limit,
    output logic ready,
    output logic busy,
    output logic done,
    output logic [N-1:0] state_out,
    output logic [31:0] visits,
    output logic [31:0] fresh_words,
    output logic [31:0] reuse_events,
    output logic [63:0] cycle_count,
    output logic [NODE_W-1:0] active_node,
    output logic signed [7:0] sampled_field
);
    kings_epix_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(8), .PROB_GAIN(1024),
        .DELTA_FIELD(DELTA_FIELD), .MAX_REUSE(MAX_REUSE),
        .INDEXED_STATE_IO(0)
    ) solver (
        .clk(clk), .rst(rst), .start(start), .stop(stop),
        .initial_state(initial_state),
        .state_load_en(1'b0), .state_load_addr('0),
        .state_load_data(1'b0),
        .seed(seed), .update_limit(update_limit),
        .ready(ready), .busy(busy), .done(done), .state_out(state_out),
        .visits(visits), .fresh_words(fresh_words),
        .reuse_events(reuse_events), .cycle_count(cycle_count),
        .active_node(active_node), .sampled_field(sampled_field)
    );
endmodule

// Pin-scalable physical top. State is written and read one indexed bit at a
// time, reducing state-related package pins from 2*N to NODE_W+3.
module kings_epix_pnr_top #(
    parameter integer ROWS = `KINGS_ROWS,
    parameter integer COLS = `KINGS_COLS,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer DELTA_FIELD = `KINGS_EPIX_DELTA_FIELD,
    parameter integer MAX_REUSE = `KINGS_EPIX_MAX_REUSE
) (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic stop,
    input  logic [NODE_W-1:0] state_addr,
    input  logic state_write_en,
    input  logic state_write_data,
    output logic state_read_data,
    input  logic [31:0] seed,
    input  logic [31:0] update_limit,
    output logic ready,
    output logic busy,
    output logic done,
    output logic [31:0] visits,
    output logic [31:0] fresh_words,
    output logic [31:0] reuse_events,
    output logic [63:0] cycle_count,
    output logic [NODE_W-1:0] active_node,
    output logic signed [7:0] sampled_field
);
    wire [N-1:0] internal_state;

    assign state_read_data = ($unsigned(state_addr) < N) ?
                             internal_state[state_addr] : 1'b0;

    kings_epix_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(8), .PROB_GAIN(1024),
        .DELTA_FIELD(DELTA_FIELD), .MAX_REUSE(MAX_REUSE),
        .INDEXED_STATE_IO(1)
    ) solver (
        .clk(clk), .rst(rst), .start(start), .stop(stop),
        .initial_state('0),
        .state_load_en(state_write_en), .state_load_addr(state_addr),
        .state_load_data(state_write_data),
        .seed(seed), .update_limit(update_limit),
        .ready(ready), .busy(busy), .done(done),
        .state_out(internal_state),
        .visits(visits), .fresh_words(fresh_words),
        .reuse_events(reuse_events), .cycle_count(cycle_count),
        .active_node(active_node), .sampled_field(sampled_field)
    );
endmodule
