`timescale 1ns/1ps
// One outstanding read and one write. Address and data are captured independently.
module maxcut26_axi (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK",
       X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn" *)
    input wire s_axi_aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST",
       X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input wire s_axi_aresetn,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 12, HAS_BURST 0, HAS_LOCK 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1" *)
    input wire [11:0] s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *)
    input wire [2:0] s_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input wire s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output wire s_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input wire [31:0] s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input wire [3:0] s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input wire s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output wire s_axi_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output reg [1:0] s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output reg s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input wire s_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input wire [11:0] s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *)
    input wire [2:0] s_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input wire s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output wire s_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output reg [31:0] s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output reg [1:0] s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output reg s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input wire s_axi_rready
 );
    localparam [1:0] OKAY = 2'b00, SLVERR = 2'b10;
    reg aw_pending, w_pending;
    reg [11:0] aw_address;
    reg [31:0] w_data;
    reg [3:0] w_strobes;
    reg [31:0] seed_reg;
    reg mode_reg;
    wire epix_active;
    wire [31:0] reuse_visits, fresh_updates, cause_invalid, cause_unsupported, cause_drift, cause_age;
    reg start_pulse, abort_pulse, bus_error;
    wire busy, done, aborted;
    wire running = busy | start_pulse;
    wire [25:0] spins, best_spins, initial_spins;
    wire signed [15:0] energy, best_energy;
    wire [15:0] best_cut;
    wire [31:0] updates, rng_words, rng_steps, cycles, first_hit, rng_state;
    wire [10:0] sweeps_completed;
    assign s_axi_awready = s_axi_aresetn && !aw_pending && !s_axi_bvalid;
    assign s_axi_wready = s_axi_aresetn && !w_pending && !s_axi_bvalid;
    assign s_axi_arready = s_axi_aresetn && !s_axi_rvalid;
    wire [15:0] unsatisfied;
    wire [31:0] refills, init_draws, raw_words, initial_assignment;
    wire native_success;
    categorical_solver solver(.clk(s_axi_aclk),.rst(!s_axi_aresetn || abort_pulse),
        .start(start_pulse),.seed(seed_reg),.flip_limit(32'd26624),.epix_enable(mode_reg),
        .busy(busy),.done(done),.success(native_success),.assignment(spins),
        .cycles(cycles),.initial_assignment(initial_assignment),.source_words(rng_words),.source_steps(rng_steps),
        .flips(updates),.raw_words(raw_words),.reused_visits(reuse_visits),.refills(refills),
        .initial_draws(init_draws),.num_unsat(unsatisfied),.rng_state_out(rng_state),
        .phase_out(),.event_out(),.selected_clause(),.chosen_index(),.break0(),.break1(),.break2(),
        .mass0(),.mass1(),.mass2(),.cache_value(),.cache_range(),.cache_age());
    assign aborted=0;
    assign initial_spins=initial_assignment[25:0];
    assign best_spins=spins;
    assign energy=unsatisfied;
    assign best_energy=unsatisfied;
    assign best_cut=0;
    assign fresh_updates=raw_words-refills;
    assign cause_invalid=refills;
    assign cause_unsupported=init_draws;
    assign cause_drift=0;
    assign cause_age=0;
    assign first_hit=native_success ? updates : 32'hffffffff;
    assign sweeps_completed=0;
    assign epix_active=mode_reg;
    integer lane;
    reg write_error;
    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            aw_pending <= 0; w_pending <= 0; aw_address <= 0;
            w_data <= 0; w_strobes <= 0;
            s_axi_bvalid <= 0; s_axi_bresp <= OKAY;
            s_axi_rvalid <= 0; s_axi_rresp <= OKAY; s_axi_rdata <= 0;
            seed_reg <= 32'hA5C36EFE; mode_reg <= 1; start_pulse <= 0; abort_pulse <= 0;
            bus_error <= 0;
        end else begin
            start_pulse <= 0; abort_pulse <= 0;
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 0;
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 0;
            if (s_axi_awready && s_axi_awvalid) begin
                aw_pending <= 1; aw_address <= s_axi_awaddr;
            end
            if (s_axi_wready && s_axi_wvalid) begin
                w_pending <= 1; w_data <= s_axi_wdata; w_strobes <= s_axi_wstrb;
            end
            if (aw_pending && w_pending && !s_axi_bvalid) begin
                aw_pending <= 0; w_pending <= 0;
                s_axi_bvalid <= 1; s_axi_bresp <= OKAY;
                write_error = 0;
                case (aw_address)
                    12'h008: begin // command, only low byte defined
                        if ((w_strobes[1] && |w_data[15:8]) ||
                            (w_strobes[2] && |w_data[23:16]) ||
                            (w_strobes[3] && |w_data[31:24]) ||
                            (w_strobes[0] && (|w_data[7:3] || (&w_data[1:0]))))
                            write_error = 1;
                        else if (w_strobes[0]) begin
                            if (w_data[0] && running) write_error = 1;
                            else begin
                                if (w_data[2]) bus_error <= 0;
                                if (w_data[0]) start_pulse <= 1;
                                if (w_data[1] && running) abort_pulse <= 1;
                            end
                        end
                    end
                    12'h00c: begin
                        if (running) write_error = 1;
                        else for (lane=0; lane<4; lane=lane+1)
                            if (w_strobes[lane]) seed_reg[lane*8 +: 8] <= w_data[lane*8 +: 8];
                    end
                    12'h060: begin
                        if (running ||
                            (w_strobes[0] && |w_data[7:1]) ||
                            (w_strobes[1] && |w_data[15:8]) ||
                            (w_strobes[2] && |w_data[23:16]) ||
                            (w_strobes[3] && |w_data[31:24])) write_error = 1;
                        else if (w_strobes[0]) mode_reg <= w_data[0];
                    end
                    default: write_error = 1;
                endcase
                if (write_error) begin s_axi_bresp <= SLVERR; bus_error <= 1; end
            end
            if (s_axi_arready && s_axi_arvalid) begin
                s_axi_rvalid <= 1; s_axi_rresp <= OKAY;
                case (s_axi_araddr)
                    12'h000: s_axi_rdata <= 32'h584f3236; // MC26
                    12'h004: s_axi_rdata <= 32'h00030000; // ABI 2.1: shared LFSR, 100 MHz
                    12'h008: s_axi_rdata <= 0;
                    12'h00c: s_axi_rdata <= seed_reg;
                    12'h010: s_axi_rdata <= {28'd0, bus_error, (aborted && !start_pulse),
                                            (done && !start_pulse), running};
                    12'h014: s_axi_rdata <= 32'd26;
                    12'h018: s_axi_rdata <= 32'd1024;
                    12'h01c: s_axi_rdata <= {6'd0, initial_spins};
                    12'h020: s_axi_rdata <= {6'd0, spins};
                    12'h024: s_axi_rdata <= {6'd0, best_spins};
                    12'h028: s_axi_rdata <= {{16{energy[15]}}, energy};
                    12'h02c: s_axi_rdata <= {{16{best_energy[15]}}, best_energy};
                    12'h030: s_axi_rdata <= {16'd0, best_cut};
                    12'h034: s_axi_rdata <= updates;
                    12'h038: s_axi_rdata <= rng_words;
                    12'h03c: s_axi_rdata <= rng_steps;
                    12'h040: s_axi_rdata <= cycles;
                    12'h044: s_axi_rdata <= first_hit;
                    12'h048: s_axi_rdata <= rng_state;
                    12'h04c: s_axi_rdata <= {21'd0, sweeps_completed};
                    12'h050: s_axi_rdata <= 32'd0;
                    12'h054: s_axi_rdata <= 32'd0;
                    12'h058: s_axi_rdata <= 32'd72;
                    12'h060: s_axi_rdata <= {31'd0, mode_reg};
                    12'h064: s_axi_rdata <= {31'd0, epix_active};
                    12'h068: s_axi_rdata <= reuse_visits;
                    12'h06c: s_axi_rdata <= fresh_updates;
                    12'h070: s_axi_rdata <= cause_invalid;
                    12'h074: s_axi_rdata <= cause_unsupported;
                    12'h078: s_axi_rdata <= cause_drift;
                    12'h07c: s_axi_rdata <= cause_age;
                    12'h080: s_axi_rdata <= 32'd1;
                    12'h084: s_axi_rdata <= 32'd2;
                    default: begin
                        s_axi_rdata <= 0; s_axi_rresp <= SLVERR; bus_error <= 1;
                    end
                endcase
            end
        end
    end
    // AXI PROT is intentionally accepted without access restrictions.
    wire unused_prot = ^{s_axi_awprot, s_axi_arprot};
endmodule
