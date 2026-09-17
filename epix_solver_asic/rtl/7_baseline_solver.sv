`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// Baseline programmable N-pbit solver top
// -----------------------------------------------------------------------------
// This is a serial-update architecture: N state bits and N coefficient rows
// represent the logical problem, while ONE pbit_sampler_baseline performs one
// logical p-bit update per RUN clock. active_node advances 0,1,...,N-1,0,... .
// Consequently, one complete sweep over every logical p-bit takes N clocks.
// This remains true for an all-to-all graph, King's graph, or any other graph;
// graph topology changes coefficient values, not the update parallelism.
//
// Coefficient row format for node i (least-significant field first):
//
//   cfg_row[10*0 +: 10]       weight for the lowest-index node other than i
//   cfg_row[10*1 +: 10]       weight for the next node other than i
//              ...
//   cfg_row[10*(N-2) +: 10]   final non-self weight
//   cfg_row[10*(N-1) +: 10]   local bias h_i
//
// Neighbors are ordered by ascending node index with the active node omitted.
// For sparse graphs, absent edges are represented by zero weights. With N=10,
// coefficient_memory is 10 rows x 100 bits: 90 weight fields + 10 biases.
//
// Control timeline after start is accepted:
//   start edge : latch initial_state/visit_limit; request coefficient row 0
//   PRIME      : wait for the synchronous registered row read
//   RUN        : update one node on every eligible rising clock edge
//   finish     : after visit_limit individual node visits (not full sweeps)
// -----------------------------------------------------------------------------
module baseline_solver #(
    parameter int N = 10,
    parameter int NODE_W = $clog2(N)
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
    // IDLE permits configuration/start, PRIME absorbs memory read latency, and
    // RUN accepts one logical-node visit per cycle unless stop/seed_set is high.
    localparam logic [1:0] IDLE=0, PRIME=1, RUN=2;

    // These N flip-flops are the current logical solution vector. Only
    // pbit_state_registers[active_node] changes on a RUN visit.
    logic [N-1:0] pbit_state_registers;
    assign state_out = pbit_state_registers;
    logic [1:0] phase;
    // Behavioral row memory. This form is intentionally friendly to a
    // synchronous memory implementation, but actual SRAM mapping depends on the
    // chosen PDK/compiler and flow; otherwise synthesis can realize registers.
    logic [N*10-1:0] coefficient_memory [0:N-1];
    logic [N*10-1:0] active_coefficient_row;
    logic [N-1:0] loaded;
    logic [NODE_W-1:0] fetch_node;
    logic [31:0] limit_q;
    logic start_accept, cfg_accept;
    // Configuration writes are accepted only while idle. ready additionally
    // requires every one of the N coefficient rows to have been loaded.
    assign busy = phase != IDLE;
    assign cfg_ready = !busy && !seed_set && !rst && !start;
    assign cfg_accept = cfg_we && cfg_ready && ({1'b0,cfg_node} < (NODE_W+1)'(N));
    assign ready = !busy && (&loaded) && !seed_set && !rst && !cfg_we;
    assign start_accept = start && ready;
    assign update_valid = (phase == RUN) && !stop && !seed_set && !rst;
    // Registered coefficient read: fetch_node addresses the row during this
    // cycle and active_coefficient_row receives it on the rising edge. PRIME and
    // the one-node look-ahead fetch schedule keep that row aligned to active_node.
    always_ff @(posedge clk) begin : coefficient_storage
        if (cfg_accept) coefficient_memory[cfg_node] <= cfg_row;
        active_coefficient_row <= coefficient_memory[fetch_node];
        if (rst) loaded <= '0;
        else if (cfg_accept) loaded[cfg_node] <= 1'b1;
    end
    logic [9:0] J_n [14:0];
    logic s_in [14:0];

    // The inherited local-field unit has 15 physical lanes. For lane k<N-1,
    // select the kth non-self state, skipping active_node; unused lanes are zero.
    // The generate-time condition supports N=2..16 without changing the sampler.
    for (genvar k=0;k<15;k=k+1) begin : state_selection
        if (k < N-1) begin
            assign J_n[k] = active_coefficient_row[10*k+:10];
            assign s_in[k] = (active_node > NODE_W'(k)) ? pbit_state_registers[k] : pbit_state_registers[k+1];
        end else begin
            assign J_n[k] = '0;
            assign s_in[k] = 1'b0;
        end
    end
    // Single physical stochastic sampler shared across every logical node.
    // clear only resets accounting/history-facing behavior; baseline has no
    // per-node random history and reports reuse=0.
    pbit_sampler_baseline sampler (
        .clk, .seed_set, .LFSR_in, .GE(update_valid), .J_n, .s_in,
        .h_n(active_coefficient_row[(N-1)*10+:10]), .s_out(update_bit), .LFSR_final_out(rng_msb),
        .clear(rst || start_accept || cfg_accept), .fresh_take, .reuse
    );
    // Run controller and architectural state commit.
    //
    // visits counts individual p-bit updates. fresh_words counts consumed random
    // words; in baseline these normally rise together. At a visit edge, update_bit
    // was computed combinationally from the pre-edge state vector and active row.
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
            // Row 0 is now available; prefetch row 1 for the following visit.
            phase <= RUN; active_node <= '0; fetch_node <= NODE_W'(1);
        end else if (update_valid) begin
            // Commit only the currently active logical p-bit.
            pbit_state_registers[active_node] <= update_bit;
            // Counters / readout: p-bit updates and new random words.
            visits <= visits + 32'd1;
            fresh_words <= fresh_words + {31'b0,fresh_take};
            // active_node identifies this visit. fetch_node stays one row ahead
            // to match the registered coefficient-memory output.
            active_node <= (active_node == NODE_W'(N-1)) ? '0 : active_node+1'b1;
            fetch_node <= (fetch_node == NODE_W'(N-1)) ? '0 : fetch_node+1'b1;
            if (visits+32'd1 >= limit_q) begin phase <= IDLE; done <= 1'b1; end
        end
    end
    // Parameter guardrails for simulation only; no synthesized hardware.
    // synopsys translate_off
    initial if (N < 2 || N > 16 || NODE_W < $clog2(N)) $fatal(1,"N must be 2..16");
    // synopsys translate_on
endmodule : baseline_solver
