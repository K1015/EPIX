// Single-port SRAM simulation model. Do not use for synthesis.
module sram22_128x40m4w20 (
    input wire clk, rstb, ce, we,
    input wire [1:0] wmask,
    input wire [6:0] addr,
    input wire [39:0] din,
    output logic [39:0] dout
);
    logic [39:0] memory [0:127];
    bit [1:0] written [0:127];
    initial begin
        dout = 40'hA55AC0FFEE;
        for (integer i=0; i<128; i=i+1) begin
            memory[i] = 40'hA55AC0FFEE;
            written[i] = 0;
        end
    end
    // rstb enables access; it leaves stored data and the output unchanged.
    always @(posedge clk) if (rstb && ce) begin
        if (we) begin
            if (wmask[0]) memory[addr][19:0] <= din[19:0];
            if (wmask[1]) memory[addr][39:20] <= din[39:20];
            written[addr] <= written[addr] | wmask;
        end else begin
            assert (&written[addr]) else $fatal(1, "Read before both SRAM mask groups were initialized");
            dout <= memory[addr];
        end
    end
endmodule
