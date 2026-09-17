`timescale 1ns / 1ps
// Shared combinational local-field datapath. The 15 input lanes form a fixed
// adder tree; unused lanes are tied to zero by the solver top. The result is
// saturated to the signed 8-bit range expected by the probability LUT.
module local_field_unit (s_in, h_n, J_n, Iin);
import PSL_pkg :: *;

output logic [i_bit_width-1:0] Iin;
input [j_bit_width-1:0] J_n [14:0];
input [h_bit_width-1:0] h_n;
input logic s_in [14:0];

// Temporary ports for sign extension
logic [j_bit_width-1+4:0] J_n_temp [14:0];
wire [h_bit_width-1+4:0] h_temp;

assign h_temp = {{4{h_n[h_bit_width-1]}}, h_n};

logic [h_bit_width-1+4:0] Iin_temp1 [7:0];
logic [h_bit_width-1+4:0] Iin_temp2 [3:0];
logic [h_bit_width-1+4:0] Iin_temp3 [1:0];
logic [h_bit_width-1+4:0] Iin_temp;

// Signed range limits
wire  [h_bit_width-1+4:0] nmin = 14'b11111110000001; // -15.875
wire  [h_bit_width-1+4:0] pmax = 14'b00000001111111; // 15.875

always_comb begin
    // Sign extension for J_n
    for (int i = 0; i < 15; i++) begin
        J_n_temp[i] = {{4{J_n[i][j_bit_width-1]}}, J_n[i]};
    end

    // Tree adder
    for (int i = 0; i < 7; i++) begin
        Iin_temp1[i] = (s_in[2*i] ? J_n_temp[2*i] : 14'b0) + 
                       (s_in[2*i+1] ? J_n_temp[2*i+1] : 14'b0);
    end
    Iin_temp1[7] = (s_in[14] ? J_n_temp[14] : 14'b0) + h_temp;

    for (int i = 0; i < 4; i++) begin
        Iin_temp2[i] = Iin_temp1[2*i] + Iin_temp1[2*i+1];
    end

    for (int i = 0; i < 2; i++) begin
        Iin_temp3[i] = Iin_temp2[2*i] + Iin_temp2[2*i+1];
    end
    Iin_temp = Iin_temp3[0] + Iin_temp3[1];
end

// tanh saturation beyond limits
always_comb begin
    if ($signed(Iin_temp) > $signed(pmax))
        Iin = 8'b01111111; // 15.875
    else if ($signed(Iin_temp) < $signed(nmin))
        Iin = 8'b10000001; // -15.875
    else
        Iin = Iin_temp[i_bit_width-1:0];
end

endmodule
