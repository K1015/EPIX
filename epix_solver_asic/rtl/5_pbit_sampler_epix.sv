`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// EPIX-capable p-bit sampler
// -----------------------------------------------------------------------------
// The local-field computation, LUT, and final stochastic comparator are the
// same as in pbit_sampler_baseline. EPIX inserts one policy block between the
// LFSR and comparator:
//
//   fresh LFSR word ----+
//                       +--> epix_reuse word select --> stochastic comparator
//   saved word[node] ---+
//
// epix_reuse decides whether the active logical p-bit may reuse its previously
// saved random word. The LFSR advances only on fresh_take, so a reused update
// avoids both generation of a new random sample and switching in the LFSR.
//
// As in the baseline top, this is ONE physical sampler time-multiplexed over N
// logical p-bits. The EPIX history arrays have one entry per logical p-bit, but
// the local-field datapath and comparator are not replicated N times.
// -----------------------------------------------------------------------------
module pbit_sampler_epix (/*global signals*/ clk, seed_set, LFSR_in, GE,  
    /*inputs*/ J_n,
    /**/ s_in,
    /**/ h_n,
    /*outputs*/ s_out, LFSR_final_out,
    /*EPIX*/ epix_node, epix_state, epix_clear, fresh_take, reuse);

import PSL_pkg :: *;
parameter [RNG_bit_width-1:0] seed = 32'b10101011110011001010101111001100;

// EPIX_ENABLE=0 is an elaboration-time bypass. It provides baseline random-word
// behavior through the EPIX top and is useful for equivalence/debug experiments.
// EPIX_ENABLE=1 instantiates the history and reuse policy in 6_epix_reuse.sv.
parameter bit EPIX_ENABLE = 1'b0;
parameter int EPIX_N_PBITS = 3;
parameter int EPIX_NODE_W = (EPIX_N_PBITS <= 1) ? 1 : $clog2(EPIX_N_PBITS);
parameter int EPIX_DELTA_B = 1;
parameter int EPIX_A_MAX = 2;
input [EPIX_NODE_W-1:0] epix_node;
input epix_state, epix_clear;
output logic fresh_take, reuse;

input GE;
input clk;
input seed_set;
input LFSR_in;

output logic s_out;
output logic LFSR_final_out;

input s_in [14:0];
input [j_bit_width-1:0] J_n [14:0];
input [h_bit_width-1:0] h_n;

logic [i_bit_width-1:0] Iin;
logic [i_bit_width-1:0] Iin_LUT;
logic [RNG_bit_width-1:0] LUT_out;
logic [RNG_bit_width-1:0] LFSR_out;

// The field datapath is identical to baseline. EPIX changes neither weights nor
// probability thresholds; it changes only which random word is compared.
local_field_unit local_field_unit_i (.s_in(s_in), .h_n(h_n), .J_n(J_n), .Iin(Iin));

// With EPIX enabled, fresh_take gates the LFSR. Because fresh_take is computed
// combinationally from the current history entry, the selected fresh word and
// the LFSR advance occur on the same accepted visit edge.
rng_lfsr  #(.seed(seed), .RNG_bit_width(RNG_bit_width)) rng_lfsr_i(.clk(clk), .seed_set(seed_set), .pbit_enable(EPIX_ENABLE ? (seed_set || fresh_take) : (seed_set || GE)), .LFSR_in(LFSR_in), .LFSR_out(LFSR_out));
threshold_lut threshold_lut_i (.Iin(Iin_LUT[i_bit_width-2:0]), .Out(LUT_out));

// EPIX changes only the selected comparator word and the existing LFSR enable.
logic [RNG_bit_width-1:0] sample_word;
generate
    if (EPIX_ENABLE) begin : g_epix
        // epix_node identifies the logical p-bit whose history is being read.
        // epix_state is that p-bit's state BEFORE the current update commits.
        epix_reuse #(.N_PBITS(EPIX_N_PBITS), .NODE_W(EPIX_NODE_W),
            .DELTA_B(EPIX_DELTA_B), .A_MAX(EPIX_A_MAX)) reuse_unit (
            .clk, .clear(seed_set || epix_clear), .visit(GE), .node(epix_node),
            .state_in(epix_state), .field_in($signed(Iin)), .fresh_word(LFSR_out),
            .selected_word(sample_word), .fresh_take, .reuse
        );
    end else begin : g_original
        // Compile-time baseline path: consume one fresh word on every visit.
        assign sample_word = LFSR_out;
        assign fresh_take = GE && !seed_set && !epix_clear;
        assign reuse = 1'b0;
    end
endgenerate



// Comparator and field-sign handling from the original CMU sampler. EPIX does
// not alter this probability mapping; it supplies sample_word above.
// An exact threshold tie is intentionally resolved to state zero.
always_comb begin : comparator
    s_out = 1'b0;   //NEW:  added to remove latch 

    LFSR_final_out = LFSR_out[RNG_bit_width-1];
    if(Iin[i_bit_width-1]==1) Iin_LUT = -Iin; // 2's complement: exact same implementation happens (tested) Iin_LUT = ~Iin + 1'b1;
    else Iin_LUT = Iin;

    if (Iin[i_bit_width-1]==0) begin // positive input
        if (LUT_out == sample_word) s_out = 1'b0; // zeroed at tie other than all 1, irrespective of sign of input
        else s_out = (LUT_out > sample_word) ? 1'b1 : 1'b0 ;
    end

    else if (Iin[i_bit_width-1]==1) begin //negative input
        if (LUT_out == sample_word) s_out = 1'b0; // zeroed at tie other than all 1, irrespective of sign of input
        else s_out = (LUT_out > sample_word) ? 1'b0 : 1'b1 ;
    end
end

endmodule : pbit_sampler_epix
