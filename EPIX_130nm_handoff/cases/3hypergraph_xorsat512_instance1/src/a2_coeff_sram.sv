// Store problem coefficients here. Keep seeds and RNG history in registers.
// One synchronous port. Read data holds during writes and idle cycles.
module a2_coeff_sram #(
    parameter integer WIDTH=32, DEPTH=1, AW=1
) (
    input wire clk, test_enable, enable, write_enable,
    input wire [AW-1:0] address,
    input wire [WIDTH-1:0] write_data,
    output wire [WIDTH-1:0] read_data
);
`ifdef A2_PHYSICAL
    a2_tech_coeff_sram #(.WIDTH(WIDTH), .DEPTH(DEPTH), .AW(AW)) impl (
        .clk, .test_enable, .enable, .write_enable, .address, .write_data, .read_data
    );
`else
    wire mem_clk;
    a2_icg clock_gate(.clk, .enable, .test_enable, .gclk(mem_clk));
    logic [WIDTH-1:0] storage [0:DEPTH-1];
    logic [WIDTH-1:0] output_q;
    assign read_data = output_q;
    always @(posedge mem_clk) begin
        if (enable) begin
            assert (int'(address) < DEPTH) else $fatal(1,"SRAM address out of range");
            if (write_enable) storage[address] <= write_data;
            else output_q <= storage[address];
        end
    end
`endif
endmodule
