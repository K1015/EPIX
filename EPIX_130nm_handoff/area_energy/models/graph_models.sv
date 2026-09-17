`timescale 1ns/1ps
module sky130_fd_sc_hd__dlclkp_1(input wire CLK,GATE,output wire GCLK);
 reg en;
 always_latch if(!CLK) en=GATE;
 assign GCLK=CLK & en;
endmodule
// rstb enables access; it does not erase SRAM data.
module sram22_128x40m4w20(input wire clk,rstb,ce,we,
 input wire [1:0] wmask,input wire [6:0] addr,
 input wire [39:0] din,output reg [39:0] dout);
 reg [39:0] mem [0:127];
 always @(posedge clk) if(rstb && ce) begin
   if(we) begin
     if(wmask[0]) mem[addr][19:0] <= din[19:0];
     if(wmask[1]) mem[addr][39:20] <= din[39:20];
   end else dout <= mem[addr];
 end
endmodule
