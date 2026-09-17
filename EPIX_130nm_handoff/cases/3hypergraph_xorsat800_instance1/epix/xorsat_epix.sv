module xorsat_epix_solver #(
    parameter integer N=800, M=534, FAMILY_XOR=1,
    parameter integer NODE_W=10, MEM_WORDS=2936,
    parameter integer MEM_AW=12, MEM_W=40, WEIGHT_W=1,
    parameter integer FIELD_W=8, TOTAL_WEIGHT=534, FIELD_BOUND=3,
    parameter integer MAX_REUSE=2, DELTA_FIELD=2, MAX_SWEEPS=128,
    parameter integer AGE_W=$clog2(MAX_REUSE+1),
    parameter integer ENERGY_W=$clog2(TOTAL_WEIGHT+1)+1,
    parameter integer VISIT_W=$clog2(N*16*MAX_SWEEPS+1)
) (
    input wire clk, rst, test_enable, start, stop, step_allow,
    input wire epix_enable,
    input wire [15:0] sweeps_per_beta,
    input wire coeff_we,
    input wire [MEM_AW-1:0] coeff_address,
    input wire [MEM_W-1:0] coeff_data,
    input wire seed_we,
    input wire [NODE_W-1:0] seed_node,
    input wire [31:0] seed_data,
    input wire seed_spin,
    output wire cfg_ready, ready, busy, done,
    output logic [2:0] error_code,
    output wire [N-1:0] spins,
    output logic [N-1:0] best_spins,
    output logic signed [ENERGY_W-1:0] energy, best_energy,
    output logic [VISIT_W-1:0] visits, fresh_words, reuse_events,
    output wire commit_valid,
    output wire [NODE_W-1:0] event_site,
    output wire signed [FIELD_W-1:0] event_field,
    output wire event_old, event_new, event_fresh,
    output wire [31:0] event_word,
    output wire event_word_valid,
    output wire [3:0] event_beta,
    output wire coeff_read_event
`ifdef A2_VERIFY
    , output wire [32*N-1:0] debug_rng,
    output wire [FIELD_W*N-1:0] debug_saved_field,
    output wire [AGE_W*N-1:0] debug_age,
    output wire [N-1:0] debug_valid,
    output wire [N-1:0] debug_rng_clocks,
    output wire [N-1:0] debug_dirty,
    output wire [3:0] debug_phase
`endif
);
    a2_core #(
        .N(N),
        .M(M),
        .FAMILY_XOR(FAMILY_XOR),
        .NODE_W(NODE_W),
        .MEM_WORDS(MEM_WORDS),
        .MEM_AW(MEM_AW),
        .MEM_W(MEM_W),
        .WEIGHT_W(WEIGHT_W),
        .FIELD_W(FIELD_W),
        .TOTAL_WEIGHT(TOTAL_WEIGHT),
        .FIELD_BOUND(FIELD_BOUND),
        .MAX_REUSE(MAX_REUSE),
        .DELTA_FIELD(DELTA_FIELD),
        .MAX_SWEEPS(MAX_SWEEPS)
    ) core(.*);
endmodule
