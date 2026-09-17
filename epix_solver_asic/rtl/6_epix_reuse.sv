`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// EPIX per-logical-p-bit random-word history and refresh policy
// -----------------------------------------------------------------------------
// The solver visits one logical p-bit per clock. This block remembers enough
// information about the last fresh sample for each p-bit to decide whether the
// same random word is still safe to reuse on the current visit.
//
// Storage per logical p-bit is:
//   32 bits              stored random word
//    8 bits              local field when that word was last refreshed
//    AGE_W bits          number of consecutive reuses
//    1 bit               valid flag
//   -----------
//   41 + AGE_W bits      (43 bits/p-bit with the default A_MAX=2, AGE_W=2)
//
// Thus a 10-pbit default instance holds 430 history bits. This is distinct from
// the wider 100-pbit MaxCut RTL discussed elsewhere, whose 16-bit stored field
// makes its history 51 bits/p-bit. These arrays infer registers in the current
// small design unless the synthesis/memory flow explicitly maps them to SRAM.
//
// A fresh word is required if ANY condition below is true:
//   1. no valid word has yet been stored for this p-bit;
//   2. the current state disagrees with the sign-predicted state of the field;
//   3. |current field - stored field| >= DELTA_B; or
//   4. the word has already been reused A_MAX times.
// Otherwise the stored word is returned and its age increments.
// -----------------------------------------------------------------------------
module epix_reuse #(
    parameter int N_PBITS = 3,
    parameter int NODE_W = (N_PBITS <= 1) ? 1 : $clog2(N_PBITS),
    parameter int DELTA_B = 1,
    parameter int A_MAX = 2,
    parameter int AGE_W = (A_MAX < 1) ? 1 : $clog2(A_MAX+1)
)(
    input logic clk, clear, visit,
    input logic [NODE_W-1:0] node,
    input logic state_in,
    input logic signed [7:0] field_in,
    input logic [31:0] fresh_word,
    output logic [31:0] selected_word,
    output logic fresh_take, reuse
);
    // EPIX reuse memory: one independently indexed entry per logical p-bit.
    // All arrays use the same slot computed from node.
    logic [31:0] stored_words [0:N_PBITS-1];
    logic signed [7:0] stored_fields [0:N_PBITS-1];
    logic [AGE_W-1:0] reuse_ages [0:N_PBITS-1];
    logic word_valid [0:N_PBITS-1];
    logic node_ok, refresh;
    logic [NODE_W-1:0] slot;
    logic signed [8:0] difference;
    logic [8:0] magnitude;

    // This logic is combinational so selected_word is available to the sampler
    // during the current update cycle. node_ok prevents an invalid array index;
    // slot zero is only a safe combinational fallback and is never written when
    // node_ok is false.
    always_comb begin : epix_refresh_logic
        node_ok = {1'b0,node} < (NODE_W+1)'(N_PBITS);
        slot = node_ok ? node : '0;

        // Extend both signed 8-bit fields to 9 bits before subtraction so the
        // full -255..255 difference is representable, then form |difference|.
        difference = $signed({field_in[7],field_in}) -
                     $signed({stored_fields[slot][7],stored_fields[slot]});
        magnitude = difference[8] ? $unsigned(-difference) : $unsigned(difference);

        // !field_in[7] is the state favored by the current field sign: state 1
        // for non-negative fields, state 0 for negative fields.
        refresh = !word_valid[slot] || (state_in != !field_in[7]) ||
                  magnitude >= 9'(DELTA_B) || reuse_ages[slot] >= AGE_W'(A_MAX);

        // Word-selection MUX.
        selected_word = refresh ? fresh_word : stored_words[slot];

        // Pulses are valid only on a real visit, never during a clear cycle.
        // Exactly one of fresh_take/reuse is high for each legal accepted visit.
        fresh_take = !clear && visit && node_ok && refresh;
        reuse = !clear && visit && node_ok && !refresh;
    end
    integer k;

    // The array update occurs on the same clock edge on which the solver commits
    // its new p-bit state. A refresh replaces all history for this node and
    // resets age to zero; a reuse keeps the word/field and increments only age.
    // clear is synchronous and invalidates every entry at reset, new start,
    // serial reseed, or coefficient rewrite so histories cannot cross runs.
    always_ff @(posedge clk) begin : epix_reuse_memory
        if (clear) begin
            for (k=0; k<N_PBITS; k=k+1) begin
                stored_words[k] <= '0; stored_fields[k] <= '0; reuse_ages[k] <= '0; word_valid[k] <= 1'b0;
            end
        end else if (visit && node_ok) begin
            if (refresh) begin
                stored_words[slot] <= fresh_word; stored_fields[slot] <= field_in;
                reuse_ages[slot] <= '0; word_valid[slot] <= 1'b1;
            end else if (reuse_ages[slot] != {AGE_W{1'b1}}) begin
                reuse_ages[slot] <= reuse_ages[slot] + 1'b1;
            end
        end
    end
    // Simulation/elaboration guardrails. These assertions are excluded from
    // synthesis and therefore do not contribute to PPA.
    // synopsys translate_off
    initial begin
        if (N_PBITS < 1 || DELTA_B < 0 || DELTA_B > 511 ||
            A_MAX < 0 || AGE_W < 1 || AGE_W > 30 || 64'(A_MAX) >= (64'd1 << AGE_W))
            $fatal(1,"Invalid EPIX parameters");
    end
    // synopsys translate_on
endmodule : epix_reuse
