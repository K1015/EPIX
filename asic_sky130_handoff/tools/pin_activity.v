module pin_activity(input clk, d, en, output q, y, gclk_n);
  wire and_out, gclk;
  sky130_fd_sc_hd__dfxtp_1 ff (.CLK(gclk), .D(d), .Q(q));
  sky130_fd_sc_hd__and2_1 gate (.A(q), .B(en), .X(and_out));
  sky130_fd_sc_hd__buf_1 buffer (.A(and_out), .X(y));
  sky130_fd_sc_hd__dlclkp_1 clock_gate (.CLK(clk), .GATE(en), .GCLK(gclk));
  sky130_fd_sc_hd__inv_1 inverter (.A(gclk), .Y(gclk_n));
endmodule
