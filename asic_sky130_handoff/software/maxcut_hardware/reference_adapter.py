"""Size-aware reference wrapper around the unchanged, verified APT/ICM kernel.

Each runner owns an isolated kernel module. Its temporary RNG and observation
hooks are restored even if a trial fails. The command-line entry point runs only
one explicitly labeled diagnostic trial per requested method and size.
"""
from __future__ import annotations

import argparse
from functools import lru_cache
import hashlib
import importlib.util
import itertools
import json
import pathlib
import sys
import threading

import numpy as np

from input_adapter import SHARED_ROOT, SIZES, file_sha256, load_selected, require, seed_words

KERNEL_PATH = SHARED_ROOT / "vendor/apt_icm.py"
# Verify the bundled copy, whose introductory text has been sanitized.
KERNEL_SHA256 = "d7338a2e85cb094e9e2a61d06a44292f92fa209429781e0413b0a9e0fd1467f4"
_MODULE_IDS = itertools.count()
_HOOK_NAMES = ("stream_rng", "update_color", "initialize_bank", "attempt_icm", "exchange_replicas")


def load_private_kernel(path=KERNEL_PATH):
    path = pathlib.Path(path)
    require(file_sha256(path) == KERNEL_SHA256, "Canonical APT/ICM source hash mismatch")
    name = f"_maxcut_sized_reference_{next(_MODULE_IDS)}"
    spec = importlib.util.spec_from_file_location(name, path)
    require(spec is not None and spec.loader is not None, "Cannot load verified kernel")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module  # The kernel's dataclasses require this registration.
    try:
        spec.loader.exec_module(module)
    except BaseException:
        sys.modules.pop(name, None)
        raise
    return module


def scalar_lfsr_step(word):
    word = int(word)
    return ((word << 1) & 0xffffffff) | (1 ^ ((word >> 31 ^ word >> 21 ^ word >> 1 ^ word) & 1))


@lru_cache(maxsize=2)
def _jump_tables(stride):
    require(stride in (1, 32), "Only retained one-step and 32-step LFSR conventions are supported")

    def advance(value):
        for _ in range(stride):
            value = scalar_lfsr_step(value)
        return value

    affine = advance(0)
    columns = [advance(1 << bit) ^ affine for bit in range(32)]
    tables = np.zeros((4, 256), dtype=np.uint64)
    for byte in range(4):
        for value in range(256):
            transformed = 0
            for bit in range(8):
                if value & (1 << bit):
                    transformed ^= columns[byte * 8 + bit]
            tables[byte, value] = transformed
    tables.flags.writeable = False
    return np.uint64(affine), tables


def advance_words(words, stride=32):
    """Apply the exact affine LFSR step using four byte lookup tables."""
    affine, tables = _jump_tables(stride)
    words = np.asarray(words, dtype=np.uint64)
    require(bool(np.all(words <= 0xffffffff)), "LFSR word outside 32-bit range")
    return (affine ^ tables[0, words & np.uint64(255)]
            ^ tables[1, (words >> np.uint64(8)) & np.uint64(255)]
            ^ tables[2, (words >> np.uint64(16)) & np.uint64(255)]
            ^ tables[3, (words >> np.uint64(24)) & np.uint64(255)])


def draw_indexed(state, indices, stride=32):
    """Preserve ordered repeated-node requests while batching independent nodes."""
    indices = np.asarray(indices, dtype=np.int64)
    require(indices.ndim == 1, "RNG request indices must be one-dimensional")
    if not len(indices):
        return np.empty(0, dtype=np.uint64)
    require(int(indices.min()) >= 0 and int(indices.max()) < len(state), "RNG node index outside its state bank")
    nodes, inverse, counts = np.unique(indices, return_inverse=True, return_counts=True)
    order = np.argsort(inverse, kind="stable")
    ranks = np.empty(len(indices), dtype=np.int64)
    ranks[order] = np.arange(len(indices)) - np.repeat(np.cumsum(counts) - counts, counts)
    values = np.empty((int(counts.max()), len(nodes)), dtype=np.uint64)
    current = state[nodes]
    for draw in range(len(values)):
        current = advance_words(current, stride)
        values[draw] = current
    state[nodes] = values[counts - 1, np.arange(len(nodes))]
    return values[ranks, inverse]


class IndexedLFSR:
    def __init__(self, size, seed, stream, stride=32):
        require(stream in (2, 3, 4), "Invalid physical stream")
        require(stride in (1, 32), "Invalid LFSR stride")
        self.state = seed_words(size, seed, stream)
        self.stream = stream
        self.stride = stride
        self.indices = None
        self.draw_count = 0

    def integers(self, low, high, size=None, dtype=None):
        require(low == 0 and high == 2 ** 32, "Expected a full 32-bit word request")
        count = 1 if size is None else int(size)
        require(count >= 0, "Negative word request")
        if self.stream == 2:
            require(self.indices is not None, "Local RNG request lacks physical node indices")
            indices = np.asarray(self.indices, dtype=np.int64)
            require(len(indices) == count, "Local fresh-word count disagrees with request indices")
        else:
            require(self.indices is None, "Auxiliary RNG cannot use node indices")
            indices = np.zeros(count, dtype=np.int64)
        words = draw_indexed(self.state, indices, self.stride)
        self.draw_count += count
        if size is None:
            return np.uint64(words[0])
        if dtype is not None:
            require(np.dtype(dtype) in (np.dtype(np.uint32), np.dtype(np.uint64)), "Unexpected RNG output dtype")
            words = words.astype(dtype, copy=False)
        return words


def new_reuse_audit():
    return dict(color_updates=0, node_visits=0, fresh_words=0, reused_words=0,
                reuse_field_checks=0, reuse_state_checks=0, maximum_reused_age=None)


def checked_update(kernel, original_update, audit, inst, bank, betas, color,
                   rng, method, epic_enabled, delta, age_max):
    """Route refresh requests and verify the exact cached-word-elision condition."""
    group = np.flatnonzero(inst.colors == color)
    chains = bank.state.shape[0] * bank.state.shape[1]
    state = bank.state.reshape(chains, inst.n)
    spins = 2 * state.astype(np.int16) - 1
    padded = np.concatenate((spins, np.zeros((chains, 1), dtype=np.int16)), axis=1)
    local = -np.sum(inst.neigh_w[group][None, :, :] * padded[:, inst.neigh_idx[group]], axis=2, dtype=np.int32)
    bfield = np.tile(np.asarray(betas, dtype=np.float64), bank.state.shape[0])[:, None] * local
    field = np.clip(np.rint(kernel.FIELD_SCALE * bfield), -kernel.FIELD_LIMIT, kernel.FIELD_LIMIT)
    age = bank.age.reshape(chains, inst.n)[:, group]
    stored = bank.stored_bfield.reshape(chains, inst.n)[:, group]
    refresh = (~bank.valid.reshape(chains, inst.n)[:, group]) | ((field >= 0) != (state[:, group] == 1))
    refresh |= np.abs(bfield - stored) >= delta
    refresh |= age >= age_max
    if method != "epic_apt_icm" or not epic_enabled:
        refresh[:] = True
    reuse = ~refresh
    before = state[:, group].copy()
    require(bool(np.array_equal(bfield[reuse], stored[reuse])), "Reused field is not exactly unchanged")
    if isinstance(rng, IndexedLFSR):
        require(rng.stream == 2 and len(rng.state) == inst.n, "Incorrect physical local RNG bank")
        rng.indices = np.broadcast_to(group, refresh.shape)[refresh]
    try:
        result = original_update(inst, bank, betas, color, rng, method, epic_enabled, delta, age_max)
    finally:
        if isinstance(rng, IndexedLFSR):
            rng.indices = None
    require(result[0] == int(refresh.size), "Canonical update visit count mismatch")
    require(result[2] == int(refresh.sum()), "Canonical refresh mask disagrees with physical routing")
    require(bool(np.array_equal(state[:, group][reuse], before[reuse])), "Reuse changed a p-bit state")
    require(bool(np.array_equal(bank.stored_bfield.reshape(chains, inst.n)[:, group][reuse], stored[reuse])),
            "Reuse changed a stored field")
    reused = int(reuse.sum())
    audit["color_updates"] += 1
    audit["node_visits"] += int(result[0])
    audit["fresh_words"] += int(result[2])
    audit["reused_words"] += reused
    audit["reuse_field_checks"] += reused
    audit["reuse_state_checks"] += reused
    if reused:
        previous = audit["maximum_reused_age"]
        audit["maximum_reused_age"] = max(-1 if previous is None else previous, int(age[reuse].max()))
        require(int(age[reuse].max()) < age_max, "Expired entry was reused")
    return result


class ReferenceRunner:
    """One non-reentrant runner per worker, with its own unchanged kernel copy."""
    def __init__(self, size, campaign_root=None, kernel_path=KERNEL_PATH):
        self.prepared = load_selected(size) if campaign_root is None else load_selected(size, campaign_root)
        self.config = self.prepared.configuration
        self.kernel = load_private_kernel(kernel_path)
        self.instance = self.prepared.graph.kernel_instance(self.kernel)
        self.originals = {name: getattr(self.kernel, name) for name in _HOOK_NAMES}
        self._lock = threading.Lock()
        require(self.kernel.instance_digest(self.instance) == self.prepared.graph.digest, "Kernel graph digest mismatch")

    def trial_seed(self, trial):
        require(isinstance(trial, int) and 0 <= trial < 1000, "Trial must be within the frozen 0-999 range")
        seed = self.config["trial_seeds"]
        return seed["namespace"] + seed["instance_code"] * seed["stride"] + trial

    def run(self, trial, method, variant="lfsr32", *, diagnostic_budget=None, observer=None):
        require(method in ("baseline", "epix"), "Method must be baseline or epix")
        require(variant in ("native", "lfsr1", "lfsr32"), "Unknown RNG variant")
        canonical_budget = self.config["maximum_sweeps"]
        budget = canonical_budget if diagnostic_budget is None else diagnostic_budget
        require(isinstance(budget, int) and 0 < budget <= canonical_budget, "Invalid diagnostic sweep budget")
        require(variant == "lfsr32" or diagnostic_budget is not None,
                "Native and one-step variants are diagnostics in this larger-size wrapper")
        seed = self.trial_seed(trial)
        require(self._lock.acquire(blocking=False), "Use a separate ReferenceRunner for each concurrent worker")
        kernel, cfg = self.kernel, self.config
        for name, function in self.originals.items():
            if getattr(kernel, name) is not function:
                self._lock.release()
                raise ValueError(f"Private kernel hook was changed outside its run: {name}")
        audit, streams, captured = new_reuse_audit(), {}, {}
        canonical_method = cfg["policies"][method]

        def emit(event, bank):
            if observer is not None:
                observer(event, bank)

        def factory(request_seed, stream):
            require(request_seed == seed, "Kernel requested a different trial seed")
            if stream == 1 or variant == "native":
                return self.originals["stream_rng"](request_seed, stream)
            require(stream not in streams, "Physical RNG stream initialized twice")
            rng = IndexedLFSR(cfg["n"], seed, stream, 32 if variant == "lfsr32" else 1)
            streams[stream] = rng
            return rng

        def initialize(*args, **kwargs):
            bank, words = self.originals["initialize_bank"](*args, **kwargs)
            captured["bank"] = bank
            captured["initial_hash"] = hashlib.sha256(bank.state.tobytes()).hexdigest()
            captured["initial_words"] = words
            emit(dict(kind="initialization", sweep=0), bank)
            return bank, words

        def update(inst, bank, betas, color, rng, kernel_method, enabled, delta, age_max):
            result = checked_update(kernel, self.originals["update_color"], audit,
                inst, bank, betas, color, rng, kernel_method, enabled, delta, age_max)
            emit(dict(kind="color", sweep=(audit["color_updates"] - 1) // 4 + 1,
                      color=int(color), visits=int(result[0]), fresh_words=int(result[2])), bank)
            return result

        def icm(inst, bank, temperature, rng, max_disagreement, max_cluster):
            result = self.originals["attempt_icm"](inst, bank, temperature, rng, max_disagreement, max_cluster)
            if result[0]:
                emit(dict(kind="icm", sweep=audit["color_updates"] // 4,
                          temperature=int(temperature), cluster_size=int(result[1])), bank)
            return result

        def exchange(bank, copy, left, right):
            result = self.originals["exchange_replicas"](bank, copy, left, right)
            emit(dict(kind="exchange", sweep=audit["color_updates"] // 4,
                      copy=int(copy), left=int(left), right=int(right)), bank)
            return result

        try:
            kernel.stream_rng = factory
            kernel.initialize_bank = initialize
            kernel.update_color = update
            kernel.attempt_icm = icm
            kernel.exchange_replicas = exchange
            row = kernel.run_apt_icm(self.instance, cfg["exact_target"], "exact_dp",
                canonical_method, trial, seed, cfg["betas"], budget, [budget],
                copies=cfg["replicas"]["copies_per_temperature"], icm_interval=cfg["icm"]["interval_sweeps"],
                icm_beta_min=cfg["icm"]["beta_min"], max_disagreement_fraction=0.5, max_cluster_fraction=0.5,
                epic_enabled=True, field_refresh_delta=cfg["policies"]["field_refresh_delta"],
                max_hold_age=cfg["policies"]["max_hold_age"], stop_on_exact=True)
            require(row["initialization_rng_words"] == captured["initial_words"] == cfg["loading"]["native_initialization_rng_words"],
                    "Initialization word accounting mismatch")
            require(row["local_fresh_rng_words"] == audit["fresh_words"], "Local word audit mismatch")
            require(row["total_replica_node_updates"] == audit["node_visits"], "Node-visit audit mismatch")
            require(row["total_rng_words"] == sum(row[name] for name in
                    ("initialization_rng_words", "local_fresh_rng_words", "swap_rng_words", "icm_rng_words")),
                    "Total RNG accounting mismatch")
            require(row["final_state_sha256"] == hashlib.sha256(captured["bank"].state.tobytes()).hexdigest(),
                    "Final bank digest mismatch")
            require(row["beta_ladder_id"] == cfg["beta_ladder_id"], "Solver ladder differs from frozen calibration")
            if streams:
                require(set(streams) == {2, 3, 4}, "Incomplete physical RNG stream set")
                for stream, name in ((2, "local_fresh_rng_words"), (3, "swap_rng_words"), (4, "icm_rng_words")):
                    require(streams[stream].draw_count == row[name], f"Physical stream {stream} count mismatch")
            audit["passed"] = True
            row.update(hardware_method=method, variant=variant,
                run_scope="diagnostic_smoke" if diagnostic_budget is not None else "canonical_full_budget",
                diagnostic_budget=diagnostic_budget, canonical_maximum_sweeps=canonical_budget,
                initial_state_sha256=captured["initial_hash"], reuse_audit=audit,
                physical_seed_namespace=cfg["rng"]["seed_namespace"] if streams else None,
                physical_rng_final_sha256={str(stream): hashlib.sha256(rng.state.astype("<u4").tobytes()).hexdigest()
                                           for stream, rng in streams.items()},
                canonical_kernel_sha256=KERNEL_SHA256,
                input_specification_sha256=self.prepared.verification["specification_file_sha256"],
                final_state_digest_verified=True)
            return row
        finally:
            for name, function in self.originals.items():
                setattr(kernel, name, function)
            self._lock.release()
