`timescale 1ns/1ps
`ifndef KINGS_ROWS
`define KINGS_ROWS 10
`endif
`ifndef KINGS_COLS
`define KINGS_COLS 10
`endif

// Baseline solver specialized for an open-boundary rectangular King's graph.
//
// The graph is fixed by the compile-time ROWS and COLS parameters.  There is
// no N x N coefficient memory: each node has only the eight possible King
// directions.  All eight contributions are reduced in parallel during one
// CALCULATE clock, followed by one SAMPLE/UPDATE clock.  This mirrors the
// 130-nm handoff's parallel eight-edge arithmetic without adding coefficient
// SRAM to the implicit unit-weight King's graph.
module kings_baseline_solver #(
    parameter integer ROWS = 10,
    parameter integer COLS = 10,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer ROW_W = (ROWS <= 2) ? 1 : $clog2(ROWS),
    parameter integer COL_W = (COLS <= 2) ? 1 : $clog2(COLS),
    parameter integer FIELD_W = 8,
    parameter integer PROB_GAIN = 1024,
    // The compatibility top loads all N state bits in parallel.  The physical
    // top sets this parameter and writes state_q through the indexed port,
    // avoiding N input pins and an additional N-bit initialization register.
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

    logic [1:0] phase;
    logic [N-1:0] state_q;
    logic [ROW_W-1:0] active_row;
    logic [COL_W-1:0] active_col;
    logic signed [FIELD_W-1:0] field_comb;
    logic signed [FIELD_W-1:0] field_latched;
    logic [31:0] pbit_lfsr_q [0:N-1];
    logic [31:0] selected_word;
    logic signed [31:0] threshold_calculation;
    logic [15:0] probability_threshold;
    logic sampled_state;

    assign ready = (phase == IDLE) && !rst;
    assign busy = phase != IDLE;
    assign state_out = state_q;
    assign sampled_field = field_latched;
    assign selected_word = pbit_lfsr_q[active_node];

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

    // Unit antiferromagnetic coupling J=-1: a one-valued neighbor contributes
    // -1 and a zero-valued neighbor contributes +1.  The eight fixed King
    // directions form a shallow parallel reduction; boundary terms are zero.
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

    // One 32-bit LFSR bank per logical p-bit. Only the selected bank advances
    // in UPDATE. Genus can map this explicit enable to a library ICG cell.
    generate
        for (genvar pbit = 0; pbit < N; pbit = pbit + 1) begin : lfsr_banks
            wire selected_update = (phase == UPDATE) &&
                                   (active_node == NODE_W'(pbit));
            wire lfsr_enable = rst || (start && ready) || selected_update;
            always_ff @(posedge clk) begin
                if (lfsr_enable) begin
                    if (rst)
                        pbit_lfsr_q[pbit] <= pbit_seed(32'd1, pbit);
                    else if (start && ready)
                        pbit_lfsr_q[pbit] <= pbit_seed(seed, pbit);
                    else
                        pbit_lfsr_q[pbit] <= lfsr_next(pbit_lfsr_q[pbit]);
                end
            end
        end
    endgenerate

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
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && ready) begin
                // An indexed-I/O run starts from the values written directly
                // into state_q while idle.  The legacy top keeps its original
                // single-cycle parallel initialization behavior.
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
                phase <= UPDATE;
            end else if (phase == UPDATE) begin
                cycle_count <= cycle_count + 64'd1;
                state_q[active_node] <= sampled_state;
                visits <= visits + 32'd1;
                fresh_words <= fresh_words + 32'd1;
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
        end
    end

    // synopsys translate_off
    initial begin
        if ((ROWS < 2) || (COLS < 2) || (N != ROWS*COLS))
            $fatal(1, "invalid King's-graph dimensions");
        if (FIELD_W < 5 || FIELD_W > 31)
            $fatal(1, "FIELD_W must represent the King's field range -8..+8");
    end
    // synopsys translate_on
endmodule

// Default physical-design top is 10x10, but ROWS and COLS remain overridable
// at elaboration for a different rectangular King's graph.
module kings_baseline_top #(
    parameter integer ROWS = `KINGS_ROWS,
    parameter integer COLS = `KINGS_COLS,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N)
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
    kings_baseline_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(8), .PROB_GAIN(1024), .INDEXED_STATE_IO(0)
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

// Physical-design wrapper with O(log N) state I/O.
//
// Drive state_write_en for one idle clock per p-bit to initialize state_q,
// then pulse start.  state_read_data is an asynchronous indexed view of the
// same state_q storage and may also be used to serialize the final solution.
// The wrapper adds no N-bit shadow register; internal_state is only a wire.
module kings_baseline_pnr_top #(
    parameter integer ROWS = `KINGS_ROWS,
    parameter integer COLS = `KINGS_COLS,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N)
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

    kings_baseline_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(8), .PROB_GAIN(1024), .INDEXED_STATE_IO(1)
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
