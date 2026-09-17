`timescale 1ns / 1ps
// Shared numeric and structural constants used by both solver variants.
// Keeping this package in the common rtl/ directory guarantees that baseline
// and EPIX are synthesized with exactly the same fixed-point definitions.
package PSL_pkg;
    localparam j_bit_width = 10; //single weight bit width
    localparam h_bit_width = 10; //single h bit width
    localparam i_bit_width = 8; //single input bit width

    // localparam j_bram_addr_bit_width = 16; // address bit width of J BRAM
    // localparam h_bram_addr_bit_width = 14; // address bit width of h BRAM
    // localparam s_bram_addr_bit_width = 14; // address bit width of s BRAM

    localparam num_jumps_x = 4;
    localparam num_jumps_x_log = $clog2(num_jumps_x);
    localparam num_jumps_y = 8;
    localparam num_jumps_y_log = $clog2(num_jumps_y);
    localparam num_jumps = num_jumps_x * num_jumps_y;
    localparam num_jumps_log = $clog2(num_jumps);
    localparam address_width = num_jumps_log+2;
    localparam RNG_bit_width = 32; //LUT_out and RNG bit width
    // localparam num_pbits = 1024; //total number of p-bits (assume grid of x=32, y=32)
    // localparam length_J_array = 3906; // J array length (4xy - 3x - 3y +2)
    // localparam W_R_clk_ratio = 3; // ratio between axi write clk and BRAM read clk frequency

    localparam num_rows = 3;
    localparam num_cols = 3;
    // #physical_pbits = #rows * #cols
    // #virtual_pbits  = #jumps * #physical_pbits

    localparam output_top = 14; 
    localparam output_bot = 18; 
    localparam transmit_bit_top = 7;  //input top
    localparam transmit_bit_bot = 6; //input bottom 

    localparam SHIFT_OUT_BIT = 2;   //temporarily set to 3, should be 2 for state shiftout and 1 for scan_out 

    
endpackage : PSL_pkg
