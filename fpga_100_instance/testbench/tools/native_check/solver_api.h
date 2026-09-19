#ifndef NATIVE_SMALL_SOLVER_API_H
#define NATIVE_SMALL_SOLVER_API_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define NATIVE_SOLVER_ABI_VERSION 1u
#define NATIVE_SOLVER_MAX_N 32u
#define NATIVE_SOLVER_MAX_M 256u
#define NATIVE_SOLVER_DEFAULT_SEED UINT32_C(0xA5C36EFE)

/* States encode variable i+1 in bit i. Clause and chosen-slot indices in
 * traces are zero based; completed visits and first_hit are one based.
 * first_hit == 0 means the initial assignment solves the formula; -1 means
 * no solution was found. Source calls count the 31-bit projection of one
 * native 32-bit output each, including calls during initialization.
 */
typedef struct NativeResult {
    uint32_t abi_version;
    uint32_t struct_size;
    uint32_t status;
    uint32_t solved;
    uint32_t effective_seed;
    uint32_t initial_state;
    uint32_t final_state;
    uint32_t best_state;
    uint32_t initial_unsat;
    uint32_t final_unsat;
    uint32_t best_unsat;
    uint32_t trace_truncated;
    int64_t first_hit;
    uint64_t flips;
    uint64_t init_calls;
    uint64_t search_calls;
    uint64_t refill_calls;
    uint64_t refresh_events;
    uint64_t reuse_visits;
    uint64_t trace_written;
    uint32_t rng_s0;
    uint32_t rng_s1;
} NativeResult;

/* Each row describes one completed flip. Residual state and age belong to
 * the selected clause after drawing. RNG state and cumulative counters are
 * recorded after all source calls for that flip. */
typedef struct NativeTrace {
    uint64_t visit;
    uint32_t state;
    uint32_t unsat;
    uint32_t clause;
    uint32_t chosen;
    int32_t literal;
    uint32_t masses[3];
    uint32_t breaks[3];
    uint32_t refreshed;
    uint32_t age;
    uint32_t rng_s0;
    uint32_t rng_s1;
    uint64_t search_calls;
    uint64_t refill_calls;
    uint64_t refresh_events;
    uint64_t reuse_visits;
    uint64_t residual_value;
    uint64_t residual_range;
} NativeTrace;

/* mode: 0 = fresh on every visit; 1 = residual EPIX, age 254, relax 1.
 * Flat CNF stores exactly three signed literals per clause, preserving
 * input clause/literal order. Within a clause all variables must differ.
 * seed32 == 0 uses the supplied RTL's default seed, as its load_seed does.
 * Return/status: 0 success, 1 invalid arguments, 2 numerical invariant.
 * A capped unsolved trial is a successful API call with solved == 0.
 * trace may be NULL exactly when trace_capacity == 0. Short trace capacity
 * never stops search: trace_truncated records that some rows were omitted.
 */
int run_trial(uint32_t n, uint32_t m, const int32_t *cnf_flat,
              uint32_t seed32, uint32_t mode, uint64_t max_flips,
              NativeResult *result, NativeTrace *trace,
              uint64_t trace_capacity);

uint32_t native_result_sizeof(void);
uint32_t native_trace_sizeof(void);

/* Source primitive: output the scrambled successor, then store successor.
 * Caller supplies state directly; seed loading is performed by run_trial. */
uint32_t native_rng_next32(uint32_t *s0, uint32_t *s1);

/* Quantize break-only polynomial weights using the exact solver procedure.
 * Return 0 on success, -1 if any break count exceeds the supported bound. */
int native_break_masses(uint32_t b0, uint32_t b1, uint32_t b2,
                        uint32_t masses[3]);

/* Independent primitive for forced residual/refill boundary verification.
 * Positive masses must sum to 65536. Return chosen slot 0..2, or -1 on
 * invalid input/invariant. source_calls is cumulative and counts refills. */
int native_conditioned_draw(uint64_t *value, uint64_t *range,
                            const uint32_t masses[3], uint32_t *s0,
                            uint32_t *s1, uint64_t *source_calls);

#ifdef __cplusplus
}
#endif
#endif
