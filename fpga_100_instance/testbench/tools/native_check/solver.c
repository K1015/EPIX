/* Independent C native reference, serial LFSR variant; n<=32, m<=256. */
#include "solver_api.h"

#include <math.h>
#include <stddef.h>
#include <string.h>

typedef struct Solver {
    int32_t cnf[NATIVE_SOLVER_MAX_M][3];
    uint32_t occurrences[2 * NATIVE_SOLVER_MAX_N + 1][NATIVE_SOLVER_MAX_M];
    uint32_t occurrence_count[2 * NATIVE_SOLVER_MAX_N + 1];
    uint32_t num_true[NATIVE_SOLVER_MAX_M];
    uint32_t false_clause[NATIVE_SOLVER_MAX_M];
    int32_t where_false[NATIVE_SOLVER_MAX_M];
    uint64_t value[NATIVE_SOLVER_MAX_M];
    uint64_t range[NATIVE_SOLVER_MAX_M];
    uint8_t age[NATIVE_SOLVER_MAX_M];
    double break_weight[NATIVE_SOLVER_MAX_M + 1];
    uint32_t state;
    uint32_t num_false;
    uint32_t n;
    uint32_t s0;
    uint32_t s1;
} Solver;

static uint32_t rotr32(uint32_t x, unsigned bits) {
    return (x >> bits) | (x << (32u - bits));
}

uint32_t native_rng_next32(uint32_t *s0, uint32_t *s1) {
    uint32_t x=*s0;
    for (int j=0;j<32;j++) x=(x>>1)^((x&1)?0x80200003u:0u);
    *s0=x; *s1=0;
    return x;
}

static uint32_t source31(uint32_t *s0, uint32_t *s1, uint64_t *calls) {
    ++*calls;
    return native_rng_next32(s0, s1) >> 1;
}

int native_conditioned_draw(uint64_t *value, uint64_t *range,
                            const uint32_t masses[3], uint32_t *s0,
                            uint32_t *s1, uint64_t *source_calls) {
    if (!value || !range || !masses || !s0 || !s1 || !source_calls ||
        !masses[0] || !masses[1] || !masses[2] ||
        (uint64_t)masses[0] + masses[1] + masses[2] != 65536 ||
        !*range || *value >= *range) {
        return -1;
    }
    for (;;) {
        if (*range < 65536) {
            uint32_t word = source31(s0, s1, source_calls);
            *value = (*value << 31) | word;
            *range <<= 31;
        }
        uint64_t unit = *range / 65536;
        uint64_t usable = unit * 65536;
        if (*value >= usable) {
            *value -= usable;
            *range -= usable;
            continue;
        }
        uint64_t offset = 0;
        for (unsigned i = 0; i < 3; ++i) {
            uint64_t width = unit * masses[i];
            if (*value < offset + width) {
                *value -= offset;
                *range = width;
                return (int)i;
            }
            offset += width;
        }
        return -1;
    }
}

/* Same operation order and lowest-index tie rule as conditioned.h. */
static int quantize(const double probabilities[3], uint32_t masses[3]) {
    double sum = probabilities[0] + probabilities[1] + probabilities[2];
    double fraction[3];
    uint32_t total = 0;
    if (!(sum > 0) || !isfinite(sum)) return -1;
    for (unsigned i = 0; i < 3; ++i) {
        double x = 65533 * probabilities[i] / sum;
        uint32_t k = (uint32_t)floor(x);
        masses[i] = 1 + k;
        fraction[i] = x - k;
        total += masses[i];
    }
    if (total > 65536 || total < 65534) return -1;
    while (total < 65536) {
        unsigned best = 0;
        for (unsigned j = 1; j < 3; ++j)
            if (fraction[j] > fraction[best]) best = j;
        ++masses[best];
        fraction[best] = -1;
        ++total;
    }
    return 0;
}

int native_break_masses(uint32_t b0, uint32_t b1, uint32_t b2,
                        uint32_t masses[3]) {
    if (!masses || b0 > NATIVE_SOLVER_MAX_M || b1 > NATIVE_SOLVER_MAX_M ||
        b2 > NATIVE_SOLVER_MAX_M) return -1;
    const double probabilities[3] = {
        pow(0.9 + b0, -2.06), pow(0.9 + b1, -2.06), pow(0.9 + b2, -2.06)
    };
    return quantize(probabilities, masses);
}

static uint32_t variable(int32_t literal) {
    return (uint32_t)(literal < 0 ? -literal : literal) - 1;
}

static uint32_t occurrence_index(const Solver *s, int32_t literal) {
    return (uint32_t)((int32_t)s->n + literal);
}

static int literal_true(uint32_t state, int32_t literal) {
    return ((state >> variable(literal)) & 1u) == (uint32_t)(literal > 0);
}

static void flip_variable(Solver *s, int32_t selected_literal) {
    uint32_t v = variable(selected_literal);
    int32_t makes_sat = (s->state >> v) & 1u ? -(int32_t)(v + 1) : (int32_t)(v + 1);
    s->state ^= UINT32_C(1) << v;

    /* Preserve v20's pass order and ascending occurrence-list order.
     * The first pass removes newly satisfied clauses by last-entry swap. */
    uint32_t ix = occurrence_index(s, makes_sat);
    for (uint32_t k = 0; k < s->occurrence_count[ix]; ++k) {
        uint32_t c = s->occurrences[ix][k];
        if (s->num_true[c] == 0) {
            uint32_t pos = (uint32_t)s->where_false[c];
            uint32_t moved = s->false_clause[--s->num_false];
            s->false_clause[pos] = moved;
            s->where_false[moved] = (int32_t)pos;
            s->where_false[c] = -1;
        }
        ++s->num_true[c];
    }
    /* Append newly unsatisfied clauses only after all removals. */
    ix = occurrence_index(s, -makes_sat);
    for (uint32_t k = 0; k < s->occurrence_count[ix]; ++k) {
        uint32_t c = s->occurrences[ix][k];
        if (s->num_true[c] == 1) {
            s->false_clause[s->num_false] = c;
            s->where_false[c] = (int32_t)s->num_false;
            ++s->num_false;
        }
        --s->num_true[c];
    }
}

uint32_t native_result_sizeof(void) { return (uint32_t)sizeof(NativeResult); }
uint32_t native_trace_sizeof(void) { return (uint32_t)sizeof(NativeTrace); }

int run_trial(uint32_t n, uint32_t m, const int32_t *cnf_flat,
              uint32_t seed32, uint32_t mode, uint64_t max_flips,
              NativeResult *result, NativeTrace *trace,
              uint64_t trace_capacity) {
    if (!result) return 1;
    memset(result, 0, sizeof(*result));
    result->abi_version = NATIVE_SOLVER_ABI_VERSION;
    result->struct_size = (uint32_t)sizeof(*result);
    result->first_hit = -1;
    if (!cnf_flat || n < 3 || n > NATIVE_SOLVER_MAX_N ||
        m < 1 || m > NATIVE_SOLVER_MAX_M || mode > 1 ||
        (trace_capacity && !trace) || max_flips > INT64_MAX) {
        result->status = 1;
        return 1;
    }

    Solver s;
    memset(&s, 0, sizeof(s));
    s.n = n;
    s.s0 = seed32 ? seed32 : NATIVE_SOLVER_DEFAULT_SEED;
    s.s1 = s.s0 ^ UINT32_C(0x9E3779B9);
    result->effective_seed = s.s0;
    for (uint32_t c = 0; c < m; ++c) {
        s.age[c] = 255;
        s.where_false[c] = -1;
        for (uint32_t j = 0; j < 3; ++j) {
            int32_t literal = cnf_flat[3 * c + j];
            if (!literal || literal < -(int32_t)n || literal > (int32_t)n) {
                result->status = 1;
                return 1;
            }
            for (uint32_t previous = 0; previous < j; ++previous) {
                if (variable(literal) == variable(s.cnf[c][previous])) {
                    result->status = 1;
                    return 1;
                }
            }
            s.cnf[c][j] = literal;
            uint32_t ix = occurrence_index(&s, literal);
            s.occurrences[ix][s.occurrence_count[ix]++] = c;
        }
    }
    for (uint32_t k = 0; k <= m; ++k)
        s.break_weight[k] = pow(0.9 + k, -2.06);
    for (uint32_t v = 0; v < n; ++v)
        s.state |= (source31(&s.s0, &s.s1, &result->init_calls) & 1u) << v;
    for (uint32_t c = 0; c < m; ++c) {
        for (uint32_t j = 0; j < 3; ++j)
            s.num_true[c] += (uint32_t)literal_true(s.state, s.cnf[c][j]);
        if (s.num_true[c] == 0) {
            s.false_clause[s.num_false] = c;
            s.where_false[c] = (int32_t)s.num_false++;
        }
    }
    result->initial_state = result->best_state = s.state;
    result->initial_unsat = result->best_unsat = s.num_false;
    if (!s.num_false) result->first_hit = 0;

    for (uint64_t flip = 0; flip < max_flips && s.num_false; ++flip) {
        uint32_t c = s.false_clause[flip % s.num_false];
        uint32_t breaks[3] = {0, 0, 0};
        double probabilities[3];
        for (unsigned j = 0; j < 3; ++j) {
            uint32_t ix = occurrence_index(&s, -s.cnf[c][j]);
            for (uint32_t k = 0; k < s.occurrence_count[ix]; ++k)
                breaks[j] += s.num_true[s.occurrences[ix][k]] == 1;
            probabilities[j] = s.break_weight[breaks[j]];
        }
        uint32_t masses[3];
        if (quantize(probabilities, masses)) {
            result->status = 2;
            break;
        }
        uint32_t refreshed = mode == 0 || s.age[c] >= 254;
        if (refreshed) {
            s.value[c] = source31(&s.s0, &s.s1, &result->search_calls);
            s.range[c] = UINT64_C(1) << 31;
            s.age[c] = 0;
            ++result->refresh_events;
        } else {
            ++s.age[c];
            ++result->reuse_visits;
        }
        uint64_t before = result->search_calls;
        int chosen = native_conditioned_draw(&s.value[c], &s.range[c], masses,
                                              &s.s0, &s.s1, &result->search_calls);
        result->refill_calls += result->search_calls - before;
        if (chosen < 0) {
            result->status = 2;
            break;
        }
        int32_t literal = s.cnf[c][chosen];
        flip_variable(&s, literal);
        result->flips = flip + 1;
        if (s.num_false < result->best_unsat) {
            result->best_unsat = s.num_false;
            result->best_state = s.state;
        }
        if (!s.num_false) result->first_hit = (int64_t)result->flips;
        if (result->trace_written < trace_capacity) {
            NativeTrace *t = &trace[result->trace_written++];
            memset(t, 0, sizeof(*t));
            t->visit = result->flips;
            t->state = s.state;
            t->unsat = s.num_false;
            t->clause = c;
            t->chosen = (uint32_t)chosen;
            t->literal = literal;
            memcpy(t->masses, masses, sizeof(masses));
            memcpy(t->breaks, breaks, sizeof(breaks));
            t->refreshed = refreshed;
            t->age = s.age[c];
            t->rng_s0 = s.s0;
            t->rng_s1 = s.s1;
            t->search_calls = result->search_calls;
            t->refill_calls = result->refill_calls;
            t->refresh_events = result->refresh_events;
            t->reuse_visits = result->reuse_visits;
            t->residual_value = s.value[c];
            t->residual_range = s.range[c];
        }
    }
    result->trace_truncated = result->trace_written < result->flips;
    result->final_state = s.state;
    result->final_unsat = s.num_false;
    result->solved = s.num_false == 0;
    result->rng_s0 = s.s0;
    result->rng_s1 = s.s1;
    return (int)result->status;
}
