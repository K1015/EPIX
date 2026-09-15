// Functional simulation model; synthesis uses the configured technology cell.
module sky130_fd_sc_hd__dlclkp_1(input CLK,GATE,output GCLK);
reg gate_latched;
always_latch if (!CLK) gate_latched=GATE;
assign GCLK=CLK & gate_latched;
endmodule
