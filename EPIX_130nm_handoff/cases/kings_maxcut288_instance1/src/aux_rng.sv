// Separate RNG stream for solver operations.
module a2_aux_rng(input wire clk,rst,test_enable,seeded,consume,
 input wire [31:0] seed_data,output wire [31:0] word_out);
 reg [31:0] state;
 wire rng_clock;
 function automatic [31:0] advance(input [31:0] x0);
   reg [31:0] x;begin x=x0;
     for(integer k=0;k<32;k=k+1)x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
     advance=x;
   end
 endfunction
 assign word_out=advance(consume ? state : 32'b0);
 sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),.GATE(rst||test_enable||seeded||consume),.GCLK(rng_clock));
 always @(posedge rng_clock) begin
   if(rst)state<=0;
   else if(seeded)state<=(seed_data==32'hffffffff)?32'b0:seed_data;
   else if(consume)state<=word_out;
 end
endmodule
