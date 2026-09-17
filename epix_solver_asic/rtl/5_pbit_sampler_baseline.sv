`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Baseline p-bit sampler
// -----------------------------------------------------------------------------
// This module is the stochastic update datapath shared in time by every
// logical p-bit in baseline_solver. It is combinational except for the LFSR.
// For one asserted GE (global enable / valid visit), the data flow is:
//
//   neighbor states + weights + bias
//                 |
//                 v
//       local_field_unit -> signed 8-bit Iin
//                 |
//                 v
//       abs(Iin) -> threshold_lut -> probability threshold
//                                      |
//       current 32-bit LFSR word -------+--> compare --> s_out
//
// The solver commits s_out into only the currently selected logical p-bit.
// Therefore N logical p-bits do NOT mean N physical sampler instances here:
// there is one sampler and the top visits nodes round-robin, one per RUN clock.
//
// Baseline behavior is deliberately simple: every valid visit consumes the
// current LFSR word and advances the LFSR for the next visit. fresh_take is a
// measurement pulse for that consumption; reuse is permanently zero.
// -----------------------------------------------------------------------------
module pbit_sampler_baseline (/*global signals*/ clk, seed_set, LFSR_in, GE,  
    /*inputs*/ J_n,
    /**/ s_in,
    /**/ h_n,
    /*outputs*/ s_out, LFSR_final_out,
    /*update control*/ clear, fresh_take, reuse);

import PSL_pkg :: *;
parameter [RNG_bit_width-1:0] seed = 32'b10101011110011001010101111001100;

input logic clear;
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

// Iin is the signed local field. Only its magnitude addresses threshold_lut;
// the comparator below uses its sign to select the correct output polarity.
local_field_unit local_field_unit_i (.s_in(s_in), .h_n(h_n), .J_n(J_n), .Iin(Iin));

// seed_set selects the serial seed-loading operation. During normal operation,
// GE advances the generator exactly once for every accepted p-bit update.
rng_lfsr  #(.seed(seed), .RNG_bit_width(RNG_bit_width)) rng_lfsr_i(.clk(clk), .seed_set(seed_set), .pbit_enable(seed_set || GE), .LFSR_in(LFSR_in), .LFSR_out(LFSR_out));
threshold_lut threshold_lut_i (.Iin(Iin_LUT[i_bit_width-2:0]), .Out(LUT_out));

// Baseline contains no per-node random history. The word visible before the
// active edge is used by the comparator, and that edge advances the LFSR.
logic [RNG_bit_width-1:0] sample_word;
assign sample_word = LFSR_out;

// These outputs are accounting signals, not extra algorithm state.
// clear suppresses a count while reset/start/configuration is taking place.
assign fresh_take = GE && !seed_set && !clear;
assign reuse = 1'b0;



// Comparator and field-sign handling from the original CMU sampler.
//
// threshold_lut stores the response for a non-negative magnitude. For a
// positive field, a word below the threshold produces state 1. For a negative
// field, the sense of the comparison is reversed. An exact tie maps to zero in
// both branches, preserving the behavior of the verified source RTL.
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

endmodule : pbit_sampler_baseline
