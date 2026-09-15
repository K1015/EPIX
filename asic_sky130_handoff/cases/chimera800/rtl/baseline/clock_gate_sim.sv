// Functional model of the source library ICG.
module sky130_fd_sc_hd__dlclkp_1(input CLK,GATE,output GCLK);
reg gate_latched;
always_latch if(!CLK) gate_latched=GATE;
assign GCLK=CLK & gate_latched;
endmodule
