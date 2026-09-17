// A2_PHYSICAL selects the technology clock gate.
module a2_icg(input wire clk, enable, test_enable, output wire gclk);
`ifdef A2_PHYSICAL
    a2_tech_icg impl(.clk, .enable, .test_enable, .gclk);
`else
    logic enable_latched;
    always_latch if (!clk) enable_latched = enable || test_enable;
    assign gclk = clk && enable_latched;
`endif
endmodule
