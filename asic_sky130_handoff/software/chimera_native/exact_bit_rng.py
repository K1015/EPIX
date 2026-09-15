#!/usr/bin/env python3
"""Exact Bernoulli sampling from an IID bit reservoir.

The sampler consumes a fresh fair-bit prefix until it can decide whether a
uniform dyadic variate is below an integer threshold. Unread bits remain IID
and are used by later calls. This saves source words without reusing an
already-observed random variate.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np


def trailing_zero_count(value: int) -> int:
    if value <= 0:
        raise ValueError("trailing-zero count requires a positive integer")
    return (value & -value).bit_length() - 1


def reduced_dyadic_depth(success_count: int, word_bits: int = 32) -> int:
    scale = 1 << word_bits
    if not 0 <= success_count <= scale:
        raise ValueError("success count is outside the dyadic range")
    if success_count in (0, scale):
        return 0
    return word_bits - trailing_zero_count(success_count)


def expected_bits_per_sample(success_count: int, word_bits: int = 32) -> float:
    """Expected fair bits for the prefix sampler, exactly for a fixed count."""
    depth = reduced_dyadic_depth(success_count, word_bits)
    return 0.0 if depth == 0 else 2.0 * (1.0 - 2.0 ** (-depth))


def compare_count_from_integer(
    success_count: int, uniform_integer: int, word_bits: int
) -> tuple[bool, int]:
    """Reference finite-width comparison returning outcome and bits inspected."""
    scale = 1 << word_bits
    if not 0 <= success_count <= scale:
        raise ValueError("success count is outside the dyadic range")
    if not 0 <= uniform_integer < scale:
        raise ValueError("uniform integer is outside the word range")
    if success_count == 0:
        return False, 0
    if success_count == scale:
        return True, 0
    shift = trailing_zero_count(success_count)
    depth = word_bits - shift
    threshold = success_count >> shift
    candidate = uniform_integer >> shift
    for position in range(depth - 1, -1, -1):
        random_bit = (candidate >> position) & 1
        threshold_bit = (threshold >> position) & 1
        if random_bit < threshold_bit:
            return True, depth - position
        if random_bit > threshold_bit:
            return False, depth - position
    return False, depth


@dataclass
class ExactBitReservoir:
    rng: np.random.Generator
    word_bits: int = 32
    buffer: int = 0
    bits_remaining: int = 0
    words_drawn: int = 0
    bits_consumed: int = 0

    def _refill(self) -> None:
        self.buffer = int(self.rng.integers(
            0, 1 << self.word_bits, dtype=np.uint64
        ))
        self.bits_remaining = self.word_bits
        self.words_drawn += 1

    def take_bit(self) -> int:
        if self.bits_remaining == 0:
            self._refill()
        self.bits_remaining -= 1
        self.bits_consumed += 1
        return (self.buffer >> self.bits_remaining) & 1

    def bernoulli_count(self, success_count: int) -> bool:
        """Return Bernoulli(success_count / 2**word_bits) exactly."""
        scale = 1 << self.word_bits
        if not 0 <= success_count <= scale:
            raise ValueError("success count is outside the dyadic range")
        if success_count == 0:
            return False
        if success_count == scale:
            return True
        shift = trailing_zero_count(success_count)
        depth = self.word_bits - shift
        threshold = success_count >> shift
        for position in range(depth - 1, -1, -1):
            random_bit = self.take_bit()
            threshold_bit = (threshold >> position) & 1
            if random_bit < threshold_bit:
                return True
            if random_bit > threshold_bit:
                return False
        return False

    @property
    def unused_bits(self) -> int:
        return self.bits_remaining

