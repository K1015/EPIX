`timescale 1ns/1ps
// The two strict comparisons are intentionally asymmetric at an exact tie.
module pbit_heatbath (
    input wire negative_field,
    input wire [31:0] random_word, threshold,
    output wire sample_bit
);
    assign sample_bit = negative_field ? (random_word > threshold) : (random_word < threshold);
endmodule
