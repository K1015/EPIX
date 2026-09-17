`timescale 1ns/1ps
`ifndef EPIX_MODE
`define EPIX_MODE 1
`endif
// -----------------------------------------------------------------------------
// EPIX programmable N-pbit solver top
// -----------------------------------------------------------------------------
// The state machine, coefficient memory, local-field datapath, and serial node
// schedule match baseline_solver. The only algorithmic addition is the EPIX
// random-word history selected inside pbit_sampler_epix.
//
// There is ONE physical sampler. In RUN, active_node advances round-robin and
// one logical p-bit is updated per clock. EPIX_N_PBITS=N creates N history slots;
// it does not create N samplers. A full sweep therefore still takes N clocks.
//
// Coefficient rows contain N-1 signed 10-bit non-self weights in ascending node
// order, followed by one signed 10-bit local bias. For sparse graphs such as a
// King's graph, non-edges are zero. The hardware shape is unchanged when only
// row contents change, so graph choice alone need not change area or timing.
//
// EPIX_ENABLE is an elaboration-time switch:
//   1: enable per-node random-word reuse with DELTA_B and A_MAX thresholds
//   0: take a fresh LFSR word on every visit (baseline sampling behavior)
// -----------------------------------------------------------------------------
module epix_solver #(
    parameter int N = 10,
    parameter int NODE_W = $clog2(N),
    parameter bit EPIX_ENABLE = `EPIX_MODE,
    parameter int DELTA_B = 1,
    parameter int A_MAX = 2
)(
    input logic clk, rst,
    input logic cfg_we,
    input logic [NODE_W-1:0] cfg_node,
    input logic [N*10-1:0] cfg_row,
    output logic cfg_ready, ready,
    input logic seed_set, LFSR_in,
    input logic start, stop,
    input logic [N-1:0] initial_state,
    input logic [31:0] visit_limit,
    output logic busy, done,
    output logic [N-1:0] state_out,
    output logic [31:0] visits, fresh_words,
    output logic update_valid, update_bit, fresh_take, reuse,
    output logic [NODE_W-1:0] active_node,
    output logic rng_msb
);
    // IDLE: configuration/start; PRIME: registered memory-read warmup;
    // RUN: one accepted logical-pbit visit per eligible cycle.
    localparam logic [1:0] IDLE=0, PRIME=1, RUN=2;

    // Current N-bit candidate solution. The active node observes the pre-edge
    // value; its new value commits at the end of the visit clock.
    logic [N-1:0] pbit_state_registers;
    assign state_out = pbit_state_registers;
    logic [1:0] phase;
    // Behavioral synchronous row memory. A real SRAM macro is used only if the
    // selected PDK/memory flow recognizes or replaces this array accordingly.
    logic [N*10-1:0] coefficient_memory [0:N-1];
    logic [N*10-1:0] active_coefficient_row;
    logic [N-1:0] loaded;
    logic [NODE_W-1:0] fetch_node;
    logic [31:0] limit_q;
    logic start_accept, cfg_accept;
    // All N rows must be loaded before ready can assert and start be accepted.
    assign busy = phase != IDLE;
    assign cfg_ready = !busy && !seed_set && !rst && !start;
    assign cfg_accept = cfg_we && cfg_ready && ({1'b0,cfg_node} < (NODE_W+1)'(N));
    assign ready = !busy && (&loaded) && !seed_set && !rst && !cfg_we;
    assign start_accept = start && ready;
    assign update_valid = (phase == RUN) && !stop && !seed_set && !rst;
    // Registered coefficient read. fetch_node is maintained one node ahead of
    // active_node after PRIME so the correct row is available for each visit.
    always_ff @(posedge clk) begin : coefficient_storage
        if (cfg_accept) coefficient_memory[cfg_node] <= cfg_row;
        active_coefficient_row <= coefficient_memory[fetch_node];
        if (rst) loaded <= '0;
        else if (cfg_accept) loaded[cfg_node] <= 1'b1;
    end
    logic [9:0] J_n [14:0];
    logic s_in [14:0];

    // Convert the packed non-self row into the fixed 15-lane sampler interface.
    // The state index shifts by one after active_node to omit the self-state.
    // Lanes beyond N-1 are tied low with zero weight.
    for (genvar k=0;k<15;k=k+1) begin : state_selection
        if (k < N-1) begin
            assign J_n[k] = active_coefficient_row[10*k+:10];
            assign s_in[k] = (active_node > NODE_W'(k)) ? pbit_state_registers[k] : pbit_state_registers[k+1];
        end else begin
            assign J_n[k] = '0;
            assign s_in[k] = 1'b0;
        end
    end
    // One physical EPIX sampler serves all N logical p-bits. active_node indexes
    // both the solution bit being updated and its independent EPIX history slot.
    // The current/pre-update state is passed to the refresh policy.
    pbit_sampler_epix #(.EPIX_ENABLE(EPIX_ENABLE), .EPIX_N_PBITS(N),
        .EPIX_NODE_W(NODE_W), .EPIX_DELTA_B(DELTA_B), .EPIX_A_MAX(A_MAX)) sampler (
        .clk, .seed_set, .LFSR_in, .GE(update_valid), .J_n, .s_in,
        .h_n(active_coefficient_row[(N-1)*10+:10]), .s_out(update_bit), .LFSR_final_out(rng_msb),
        .epix_node(active_node), .epix_state(pbit_state_registers[active_node]),
        .epix_clear(rst || start_accept || cfg_accept), .fresh_take, .reuse
    );
    // Controller and architectural state commit.
    // visits counts individual node updates. fresh_words counts only visits that
    // consumed a new LFSR word; reuse counts are exposed as a per-cycle pulse and
    // can be accumulated by a testbench. With EPIX disabled, visits and
    // fresh_words normally advance together just as in baseline.
    always_ff @(posedge clk) begin : run_controller
        if (rst) begin
            phase <= IDLE; done <= 1'b0; pbit_state_registers <= '0;
            visits <= '0; fresh_words <= '0; limit_q <= '0;
            fetch_node <= '0; active_node <= '0;
        end else if (start_accept) begin
            pbit_state_registers <= initial_state; visits <= '0; fresh_words <= '0;
            limit_q <= visit_limit; fetch_node <= '0; active_node <= '0;
            phase <= (visit_limit == 0) ? IDLE : PRIME;
            done <= (visit_limit == 0);
        end else if (busy && (stop || seed_set)) begin
            phase <= IDLE; done <= 1'b1;
        end else if (phase == PRIME) begin
            // Row zero has arrived; row one is requested for the next visit.
            phase <= RUN; active_node <= '0; fetch_node <= NODE_W'(1);
        end else if (update_valid) begin
            // Exactly one logical state bit is written on this edge.
            pbit_state_registers[active_node] <= update_bit;
            // Counters / readout: p-bit updates and new random words.
            visits <= visits + 32'd1;
            fresh_words <= fresh_words + {31'b0,fresh_take};
            // Round-robin update and one-row-ahead coefficient prefetch.
            active_node <= (active_node == NODE_W'(N-1)) ? '0 : active_node+1'b1;
            fetch_node <= (fetch_node == NODE_W'(N-1)) ? '0 : fetch_node+1'b1;
            if (visits+32'd1 >= limit_q) begin phase <= IDLE; done <= 1'b1; end
        end
    end
    // Simulation-only parameter validation; this is not synthesized hardware.
    // synopsys translate_off
    initial if (N < 2 || N > 16 || NODE_W < $clog2(N)) $fatal(1,"N must be 2..16");
    // synopsys translate_on
endmodule : epix_solver
