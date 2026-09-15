#!/usr/bin/env python3
"""Independent, integer-reservoir reference for the packaged probSAT RTL.

The variable/false-list update order is the native SC13_v2 order. The only
intentional algorithm input change is a specified xorshift32 random source,
which makes a trial reproducible without depending on the host C library.
"""
from __future__ import annotations

import hashlib
import math
import struct
from pathlib import Path

MASK32 = (1 << 32) - 1
TAIL_FIELDS = (
    "flips", "raw_words",
    "reused_visits", "refills", "initial_draws", "num_unsat", "rng_state",
    "selected_clause", "chosen_index", "break0", "break1", "break2",
    "mass0", "mass1", "mass2", "value_lo", "value_hi", "range_lo",
    "range_hi", "cache_age",
)


def event_fields(n):
    return ("kind", *(f"state{k}" for k in range((n+31)//32)), *TAIL_FIELDS)


def read_cnf(path):
    clauses, pending, n, declared = [], [], None, None
    for line in Path(path).read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("c"):
            continue
        if line.startswith("p "):
            _, kind, n, declared = line.split()
            assert kind == "cnf"
            n, declared = int(n), int(declared)
            continue
        for v in map(int, line.split()):
            if v:
                pending.append(v)
            else:
                clauses.append(tuple(pending))
                pending = []
    assert n in (32,128,288,512,800) and len(clauses) == declared and not pending
    assert all(len(c) == 3 and len(set(map(abs, c))) == 3 for c in clauses)
    assert all(0 < abs(v) <= n for c in clauses for v in c)
    return n, clauses


class RandomSource:
    def __init__(self, seed):
        self.state = seed & MASK32 or 1
        self.calls = 0

    def word(self):
        x = self.state
        x ^= (x << 13) & MASK32
        x ^= x >> 17
        x ^= (x << 5) & MASK32
        self.state = x & MASK32
        self.calls += 1
        return self.state >> 1


def masses(breaks):
    probabilities = [math.pow(0.9 + b, -2.06) for b in breaks]
    total = sum(probabilities)
    scaled = [65533 * p / total for p in probabilities]
    result = [1 + math.floor(x) for x in scaled]
    fractions = [x - math.floor(x) for x in scaled]
    while sum(result) < 65536:
        index = max(range(3), key=fractions.__getitem__)
        result[index] += 1
        fractions[index] = -1
    return result


def conditioned(value, span, weight, source, stats=None):
    """Exact integer form of the untouched native conditioned.h algorithm."""
    assert all(w > 0 for w in weight) and sum(weight) == 65536
    while True:
        assert 0 <= value < span
        if span < 65536:
            value = (value << 31) | source()
            span <<= 31
        assert value < 1 << 47 and span < 1 << 47
        unit = span // 65536
        usable = unit * 65536
        if value >= usable:
            if stats is not None:
                stats["rejected_tails"] += 1
            value -= usable
            span -= usable
            continue
        offset = 0
        for i, mass in enumerate(weight):
            width = unit * mass
            if value < offset + width:
                return i, value - offset, width
            offset += width
        raise AssertionError("categorical partition must cover usable interval")


class Reference:
    def __init__(self, clauses, seed, mode, age_limit=254, *, n):
        assert mode in ("baseline", "epix") and 0 <= age_limit <= 254
        self.clauses = clauses
        self.n = n
        self.source = RandomSource(seed)
        self.bits = [self.source.word() & 1 for _ in range(n)]
        self.mode, self.age_limit = mode, age_limit
        self.flips = self.raw = self.reuse = self.refills = 0
        self.occ = {lit: [] for lit in range(-n, n+1) if lit}
        for c, literals in enumerate(clauses):
            for lit in literals:
                self.occ[lit].append(c)
        self.true = [sum(self.bits[abs(lit)-1] == (lit > 0) for lit in c)
                     for c in clauses]
        self.false = [i for i, count in enumerate(self.true) if count == 0]
        self.where = {c: i for i, c in enumerate(self.false)}
        self.values, self.ranges = [0]*len(clauses), [0]*len(clauses)
        self.ages = [255]*len(clauses)
        self.selected = self.chosen = self.age = 0
        self.breaks, self.weights = [0]*3, [0]*3
        self.value = self.span = 0
        self.stats = dict(rejected_tails=0, age_refreshes=0, first_visit_refreshes=0)

    def word(self):
        self.raw += 1
        return self.source.word()

    def event(self, kind):
        states = [sum(self.bits[32*k+j] << j for j in range(32)) for k in range((self.n+31)//32)]
        return [kind, *states, self.flips, self.raw, self.reuse, self.refills,
                self.n, len(self.false), self.source.state, self.selected,
                self.chosen, *self.breaks, *self.weights, self.value & MASK32,
                self.value >> 32, self.span & MASK32, self.span >> 32, self.age]

    def step(self):
        assert self.false
        selected = self.false[self.flips % len(self.false)]
        literals = self.clauses[selected]
        breaks = [sum(self.true[c] == 1 for c in self.occ[-lit]) for lit in literals]
        weight = masses(breaks)
        if self.mode == "baseline" or self.ages[selected] >= self.age_limit:
            if self.mode == "epix":
                key = "first_visit_refreshes" if self.ages[selected] == 255 else "age_refreshes"
                self.stats[key] += 1
            self.values[selected], self.ranges[selected] = self.word(), 1 << 31
            self.ages[selected] = 0
        else:
            self.ages[selected] += 1
            self.reuse += 1
        before = self.raw
        chosen, value, span = conditioned(self.values[selected], self.ranges[selected],
                                           weight, self.word, self.stats)
        self.refills += self.raw - before
        self.values[selected], self.ranges[selected] = value, span
        variable = abs(literals[chosen])
        newly_true = -variable if self.bits[variable-1] else variable
        self.bits[variable-1] ^= 1
        for c in self.occ[newly_true]:
            if self.true[c] == 0:
                position = self.where.pop(c)
                last = self.false.pop()
                if position < len(self.false):
                    self.false[position] = last
                    self.where[last] = position
            self.true[c] += 1
        for c in self.occ[-newly_true]:
            if self.true[c] == 1:
                self.where[c] = len(self.false)
                self.false.append(c)
            self.true[c] -= 1
        self.flips += 1
        self.selected, self.chosen = selected, chosen
        self.breaks, self.weights = breaks, weight
        self.value, self.span, self.age = value, span, self.ages[selected]
        return self.event(2)

    def verify_assignment(self):
        # Direct recomputation is independent of incremental true/false lists.
        direct = [sum(self.bits[abs(lit)-1] == (lit > 0) for lit in c)
                  for c in self.clauses]
        assert direct == self.true
        assert set(self.false) == {c for c, count in enumerate(direct) if not count}
        assert all(self.false[i] == c for c, i in self.where.items())
        return not self.false

    def run(self, limit):
        yield self.event(1)
        while self.false and self.flips < limit:
            yield self.step()
        self.verify_assignment()


def state_hash(event, n):
    words=(n+31)//32
    return hashlib.sha256(struct.pack("<"+"I"*words, *event[1:1+words])).hexdigest()
