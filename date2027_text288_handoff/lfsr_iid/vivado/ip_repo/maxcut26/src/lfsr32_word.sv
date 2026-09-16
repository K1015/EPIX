`timescale 1ns/1ps
// One serial Galois source. Each accepted request advances exactly 32 bit steps.
// word is the successor state after those steps; no source activity while idle.
module lfsr32_word (
    input wire clk, rst_n, load_seed, cancel, request,
    input wire [31:0] seed,
    output reg busy, valid,
    output reg [31:0] word, state, words, steps
);
    reg [4:0] bit_index;
    wire [31:0] successor = (state >> 1) ^ (state[0] ? 32'h80200003 : 32'b0);
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 32'hA5C36EFE; word <= 0; bit_index <= 0;
            busy <= 0; valid <= 0; words <= 0; steps <= 0;
        end else begin
            valid <= 0;
            if (load_seed) begin
                state <= seed == 0 ? 32'hA5C36EFE : seed;
                word <= 0; bit_index <= 0; busy <= 0; words <= 0; steps <= 0;
            end else if (cancel) begin
                busy <= 0;
            end else if (busy) begin
                state <= successor; steps <= steps + 1;
                if (bit_index == 31) begin
                    busy <= 0; valid <= 1; word <= successor; words <= words + 1;
                end else bit_index <= bit_index + 1;
            end else if (request) begin
                busy <= 1; bit_index <= 0;
            end
        end
    end
endmodule
