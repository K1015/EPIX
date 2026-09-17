// Public top name for the shared A2 solver.
module chimera_baseline_solver (

    input logic clk,rst,start,seed_we,init_we,
    input logic [15:0] seed_addr,
    input logic cfg_we,test_enable,
    input logic [9:0] cfg_addr,
    output wire cfg_ready,configured,
    input logic [3:0] init_word,
    input logic [31:0] data_in,
    output logic done,success,final_success,
    output logic [15:0] sweeps,
    output logic signed [15:0] best_cut,final_cut,
    output logic [31:0] first_exact_sweep,
    output wire [287:0] state_read,
    output logic [287:0] witness,
    output logic [31:0] local_words,node_visits,fired_cycles,
    output wire [2:0] phase_out,event_out
);
chimera_solver #(.EPIX_ENABLE(0)) core(.*);
endmodule
