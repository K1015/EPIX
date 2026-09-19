"""Typed interface to the portable native-clause software reference."""

import ctypes as C


class Result(C.Structure):
    _fields_ = [
        (name, C.c_uint32)
        for name in (
            'abi_version',
            'struct_size',
            'status',
            'solved',
            'effective_seed',
            'initial_state',
            'final_state',
            'best_state',
            'initial_unsat',
            'final_unsat',
            'best_unsat',
            'trace_truncated',
        )
    ]
    _fields_ += [('first_hit', C.c_int64)]
    _fields_ += [
        (name, C.c_uint64)
        for name in (
            'flips',
            'init_calls',
            'search_calls',
            'refill_calls',
            'refresh_events',
            'reuse_visits',
            'trace_written',
        )
    ]
    _fields_ += [('rng_s0', C.c_uint32), ('rng_s1', C.c_uint32)]


class Trace(C.Structure):
    _fields_ = [('visit', C.c_uint64)]
    _fields_ += [(name, C.c_uint32) for name in ('state', 'unsat', 'clause', 'chosen')]
    _fields_ += [
        ('literal', C.c_int32),
        ('masses', C.c_uint32 * 3),
        ('breaks', C.c_uint32 * 3),
    ]
    _fields_ += [
        (name, C.c_uint32) for name in ('refreshed', 'age', 'rng_s0', 'rng_s1')
    ]
    _fields_ += [
        (name, C.c_uint64)
        for name in (
            'search_calls',
            'refill_calls',
            'refresh_events',
            'reuse_visits',
            'residual_value',
            'residual_range',
        )
    ]


def load_library(path):
    lib = C.CDLL(str(path))
    lib.native_result_sizeof.restype = C.c_uint32
    lib.native_trace_sizeof.restype = C.c_uint32
    assert lib.native_result_sizeof() == C.sizeof(Result)
    assert lib.native_trace_sizeof() == C.sizeof(Trace)
    lib.run_trial.argtypes = [
        C.c_uint32,
        C.c_uint32,
        C.POINTER(C.c_int32),
        C.c_uint32,
        C.c_uint32,
        C.c_uint64,
        C.POINTER(Result),
        C.POINTER(Trace),
        C.c_uint64,
    ]
    lib.run_trial.restype = C.c_int
    lib.native_break_masses.argtypes = [
        C.c_uint32,
        C.c_uint32,
        C.c_uint32,
        C.POINTER(C.c_uint32),
    ]
    lib.native_break_masses.restype = C.c_int
    return lib


def clause_array(clauses):
    return (C.c_int32 * (3 * len(clauses)))(*(v for clause in clauses for v in clause))


def run(lib, n, flat, seed, mode, max_flips, trace_capacity=0):
    result = Result()
    trace = (Trace * trace_capacity)() if trace_capacity else None
    rc = lib.run_trial(
        n,
        len(flat) // 3,
        flat,
        seed,
        mode,
        max_flips,
        C.byref(result),
        trace,
        trace_capacity,
    )
    assert rc == result.status == 0, f'native solver API error {rc}/{result.status}'
    assert result.abi_version == 1
    return result, trace
