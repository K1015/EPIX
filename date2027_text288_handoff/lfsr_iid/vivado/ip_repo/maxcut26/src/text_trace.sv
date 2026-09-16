`timescale 1ns/1ps
// Twelve observational frames, sixteen 32-bit words each. Capture never stalls the solver.
module text_trace(input wire clk,rst_n,clear,capture,input wire [511:0] frame,
    input wire [7:0] read_addr, output reg [31:0] read_data,
    output reg [4:0] count,output reg writing,overflow);
    (* ram_style="block" *) reg [31:0] memory [0:255];
    reg [511:0] shift;
    reg [3:0] lane;
    always @(posedge clk) begin
        if (writing) memory[{count[3:0],lane}]<=shift[31:0];
        read_data<=memory[read_addr];
    end
    always @(posedge clk) begin
        if (!rst_n || clear) begin count<=0; writing<=0; overflow<=0; lane<=0; shift<=0; end
        else if (capture) begin
            if (writing || count>=16) overflow<=1;
            else begin shift<=frame; lane<=0; writing<=1; end
        end else if (writing) begin
            shift<=shift>>32;
            if (lane==15) begin count<=count+1; writing<=0; end
            else lane<=lane+1;
        end
    end
endmodule
