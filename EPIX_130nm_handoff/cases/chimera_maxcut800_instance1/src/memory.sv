// Single-port SRAM22 stores problem coefficients.
module a2_coefficient_memory #(parameter WORDS=128, parameter AW=$clog2(WORDS+1)) (
 input wire clk, access, write_enable,
 input wire [AW-1:0] address,
 input wire [39:0] write_data,
 input wire [1:0] mask,
 output wire [39:0] read_data
);
 localparam BANKS=(WORDS+127)/128;
 localparam BW=(BANKS>1)?$clog2(BANKS):1;
 wire [39:0] outputs [0:BANKS-1];
 reg [BW-1:0] read_bank;
 // Save the bank selected by the accepted read.
 always @(posedge clk) if(access && !write_enable) read_bank <= BW'(address/128);
 assign read_data=outputs[read_bank];
 for(genvar b=0;b<BANKS;b=b+1) begin: bank
   wire enabled=access && (address/128==b);
   wire memory_clock;
   sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),.GATE(enabled),.GCLK(memory_clock));
   sram22_128x40m4w20 macro(.clk(memory_clock),.rstb(1'b1),.ce(enabled),
     .we(write_enable),.wmask(mask),.addr(7'(address)),.din(write_data),.dout(outputs[b]));
 end
endmodule
