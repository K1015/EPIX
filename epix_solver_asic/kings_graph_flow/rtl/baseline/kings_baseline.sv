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
// directions.  The local field engine visits those eight direction slots and
// then updates one p-bit, so every logical update takes exactly nine clocks.
module kings_baseline_solver #(
    parameter integer ROWS = 10,
    parameter integer COLS = 10,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer ROW_W = (ROWS <= 2) ? 1 : $clog2(ROWS),
    parameter integer COL_W = (COLS <= 2) ? 1 : $clog2(COLS),
    parameter integer FIELD_W = 8,
    parameter integer PROB_GAIN = 1024
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
    output logic signed [FIELD_W-1:0] sampled_field
);
    localparam logic [1:0] IDLE = 2'd0;
    localparam logic [1:0] SCAN = 2'd1;
    localparam logic [1:0] UPDATE = 2'd2;

    logic [1:0] phase;
    logic [N-1:0] state_q;
    logic [ROW_W-1:0] active_row;
    logic [COL_W-1:0] active_col;
    logic [2:0] direction;
    logic neighbor_valid;
    logic [NODE_W-1:0] neighbor_node;
    logic signed [FIELD_W-1:0] neighbor_contribution;
    logic signed [FIELD_W-1:0] field_accumulator;
    logic signed [FIELD_W-1:0] field_after_direction;
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

    // Direction order: NW, N, NE, W, E, SW, S, SE. Invalid directions at
    // the open boundary contribute zero but still consume their scan clock,
    // keeping the update latency independent of the node's degree.
    always_comb begin
        neighbor_valid = 1'b0;
        neighbor_node = '0;
        case (direction)
            3'd0: if ((active_row != 0) && (active_col != 0)) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node - COLS - 1;
            end
            3'd1: if (active_row != 0) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node - COLS;
            end
            3'd2: if ((active_row != 0) && (active_col != COLS-1)) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node - COLS + 1;
            end
            3'd3: if (active_col != 0) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node - 1'b1;
            end
            3'd4: if (active_col != COLS-1) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node + 1'b1;
            end
            3'd5: if ((active_row != ROWS-1) && (active_col != 0)) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node + COLS - 1;
            end
            3'd6: if (active_row != ROWS-1) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node + COLS;
            end
            3'd7: if ((active_row != ROWS-1) && (active_col != COLS-1)) begin
                neighbor_valid = 1'b1;
                neighbor_node = active_node + COLS + 1;
            end
            default: begin
                neighbor_valid = 1'b0;
                neighbor_node = '0;
            end
        endcase
    end

    // Unit antiferromagnetic coupling J=-1: a +1 neighbor contributes -1 to
    // the local field and a -1 neighbor contributes +1.
    always_comb begin
        neighbor_contribution = '0;
        if (neighbor_valid)
            neighbor_contribution = state_q[neighbor_node] ? -1 : 1;
        field_after_direction = field_accumulator + neighbor_contribution;
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
            direction <= '0;
            field_accumulator <= '0;
            field_latched <= '0;
            visits <= '0;
            fresh_words <= '0;
            reuse_events <= '0;
            cycle_count <= '0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && ready) begin
                state_q <= initial_state;
                active_node <= '0;
                active_row <= '0;
                active_col <= '0;
                direction <= '0;
                field_accumulator <= '0;
                field_latched <= '0;
                visits <= '0;
                fresh_words <= '0;
                reuse_events <= '0;
                cycle_count <= '0;
                if (update_limit == 0) begin
                    phase <= IDLE;
                    done <= 1'b1;
                end else begin
                    phase <= SCAN;
                end
            end else if (busy && stop) begin
                phase <= IDLE;
                done <= 1'b1;
            end else if (phase == SCAN) begin
                cycle_count <= cycle_count + 64'd1;
                if (direction == 3'd7) begin
                    field_latched <= field_after_direction;
                    field_accumulator <= '0;
                    direction <= '0;
                    phase <= UPDATE;
                end else begin
                    field_accumulator <= field_after_direction;
                    direction <= direction + 1'b1;
                end
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
                    phase <= SCAN;
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
        .FIELD_W(8), .PROB_GAIN(1024)
    ) solver (.*);
endmodule
