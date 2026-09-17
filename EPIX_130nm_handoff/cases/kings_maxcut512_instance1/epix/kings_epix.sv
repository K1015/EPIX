// Public top name for the shared A2 solver.
module kings_epix_solver (

    input logic clk, rst, start, seed_we, init_we,
    input logic [15:0] seed_addr,
    input logic cfg_we,test_enable,
    input logic [9:0] cfg_addr,
    output wire cfg_ready,configured,
    input logic [5:0] init_bank, read_bank,
    input logic [3:0] init_word,
    input logic [31:0] data_in,
    input logic [15:0] sweep_limit,
    output logic done, success,
    output logic [15:0] sweeps,
    output logic signed [11:0] best_cut,
    output logic [511:0] state_read, witness,
    output logic [31:0] local_words, swap_words, icm_words, node_visits,
    output logic [4:0] phase_out,
    output logic [2:0] event_out
);
corrected_solver #(.EPIX_ENABLE(1)) core(.*);
endmodule
