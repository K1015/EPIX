// Clock-gate simulation model. Do not use for synthesis.
module sky130_fd_sc_hd__dlclkp_1(input wire CLK, GATE, output wire GCLK);
    logic gate_latched;
    always_latch if (!CLK) gate_latched = GATE;
    assign GCLK = CLK & gate_latched;
endmodule
