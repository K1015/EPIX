`timescale 1ns/1ps

// Gate-level activity testbench for post-route power annotation.
//
// Compile the mapped netlist with:
//   -DDUT_MODULE=kings_baseline_pnr_top (or kings_epix_pnr_top)
//   -DN_PBITS=<ROWS*COLS>
//   -DNODE_W=<ceil(log2(N_PBITS))>
//   -DUPDATE_LIMIT=<number of logical p-bit updates>
//   -DVCD_FILE=\"path/to/activity.vcd\"
//
// Reset and indexed state loading happen before $dumpvars, so the VCD covers
// only the same solve interval for both designs: start assertion through done.

`ifndef DUT_MODULE
  `define DUT_MODULE kings_baseline_pnr_top
`endif
`ifndef N_PBITS
  `define N_PBITS 16
`endif
`ifndef NODE_W
  `define NODE_W 4
`endif
`ifndef UPDATE_LIMIT
  `define UPDATE_LIMIT (`N_PBITS * 32)
`endif
`ifndef VCD_FILE
  `define VCD_FILE "postroute_activity.vcd"
`endif

module postroute_activity_tb;
    localparam integer N = `N_PBITS;
    localparam integer ADDR_W = `NODE_W;
    localparam integer MAX_CYCLES = (`UPDATE_LIMIT * 10) + N + 100;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic start = 1'b0;
    logic stop = 1'b0;
    logic [ADDR_W-1:0] state_addr = '0;
    logic state_write_en = 1'b0;
    logic state_write_data = 1'b0;
    wire state_read_data;
    logic [31:0] seed = 32'h9712_8127;
    logic [31:0] update_limit = `UPDATE_LIMIT;
    wire ready;
    wire busy;
    wire done;
    wire [31:0] visits;
    wire [31:0] fresh_words;
    wire [31:0] reuse_events;
    wire [63:0] cycle_count;
    wire [ADDR_W-1:0] active_node;
    wire [7:0] sampled_field;

    integer index;
    integer measured_clocks;

    // 500 MHz clock: 2 ns period.
    always #1 clk = ~clk;

    `DUT_MODULE dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stop(stop),
        .state_addr(state_addr),
        .state_write_en(state_write_en),
        .state_write_data(state_write_data),
        .state_read_data(state_read_data),
        .seed(seed),
        .update_limit(update_limit),
        .ready(ready),
        .busy(busy),
        .done(done),
        .visits(visits),
        .fresh_words(fresh_words),
        .reuse_events(reuse_events),
        .cycle_count(cycle_count),
        .active_node(active_node),
        .sampled_field(sampled_field)
    );

    initial begin
        // Establish a clean synchronous reset before loading state.
        repeat (4) @(negedge clk);
        rst = 1'b0;
        @(negedge clk);

        // Deterministic, nonuniform initial state shared by both variants.
        state_write_en = 1'b1;
        for (index = 0; index < N; index = index + 1) begin
            state_addr = ADDR_W'(index);
            state_write_data = ((index * 13 + 7) ^ (index >> 1)) & 1;
            @(negedge clk);
        end
        state_write_en = 1'b0;
        state_addr = '0;

        // Begin recording immediately before the common solve interval.
        $dumpfile(`VCD_FILE);
        $dumpvars(0, dut);
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        measured_clocks = 0;
        while (!done && measured_clocks < MAX_CYCLES) begin
            @(negedge clk);
            measured_clocks = measured_clocks + 1;
        end
        if (!done) begin
            $display("FAIL timeout N=%0d clocks=%0d", N, measured_clocks);
            $finish_and_return(2);
        end

        $display(
            "PASS N=%0d visits=%0d fresh=%0d reuse=%0d cycles=%0d measured_clocks=%0d",
            N, visits, fresh_words, reuse_events, cycle_count, measured_clocks
        );
        $dumpoff;
        $finish;
    end
endmodule
