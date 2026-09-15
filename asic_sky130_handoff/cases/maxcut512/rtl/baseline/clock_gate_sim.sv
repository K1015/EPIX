// Functional model for the exact SKY130 cell instantiated in solver.sv.
module sky130_fd_sc_hd__dlclkp_1(input CLK,GATE,output GCLK);
reg gate_latched;
always @ (CLK or GATE) if(!CLK) gate_latched=GATE;
assign GCLK=CLK & gate_latched;
endmodule
