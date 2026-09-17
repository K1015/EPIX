module a2_tech_icg(input wire clk,enable,test_enable,output wire gclk);
    sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),.GATE(enable || test_enable),.GCLK(gclk));
endmodule

// Reads take one cycle, including bank changes. SRAM contents are not reset.
module a2_tech_coeff_sram #(
    parameter integer WIDTH=32,DEPTH=1,AW=1,
    parameter integer BANKS=(DEPTH+127)/128,
    parameter integer BW=BANKS>1?$clog2(BANKS):1
) (
    input wire clk,test_enable,enable,write_enable,
    input wire [AW-1:0] address,
    input wire [WIDTH-1:0] write_data,
    output wire [WIDTH-1:0] read_data
);
    wire [39:0] outputs[0:BANKS-1];
    logic [BW-1:0] read_bank;
    wire read_clk;
    a2_tech_icg select_gate(.clk,.enable(enable && !write_enable),.test_enable,.gclk(read_clk));
    always @(posedge read_clk) if(enable && !write_enable) read_bank <= BW'(int'(address)>>7);
    for(genvar b=0;b<BANKS;b=b+1) begin: bank
        wire access=enable && (int'(address)>>7)==b;
        wire memory_clk;
        a2_tech_icg clock_gate(.clk,.enable(access),.test_enable,.gclk(memory_clk));
        sram22_128x40m4w20 macro_cell(.clk(memory_clk),.rstb(1'b1),.ce(access),.we(write_enable),
            .wmask(2'b11),.addr(7'(address)),.din(40'(write_data)),.dout(outputs[b]));
    end
    assign read_data=outputs[read_bank][WIDTH-1:0];
`ifndef SYNTHESIS
    initial assert(WIDTH<=40 && DEPTH>0);
`endif
endmodule
