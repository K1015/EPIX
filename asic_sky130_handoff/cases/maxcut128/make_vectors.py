"""Prepare complete reference traces using the frozen 128-node software solver.

Adapted from the original make_vectors.py: output paths and trial counts are
configurable; compact bundled outcomes replace external result directories.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import struct
import time

import numpy as np
import reference as R

K = R.K
original_init = K.initialize_bank
original_update = R.ORIGINAL_UPDATE
original_icm = K.attempt_icm
original_swap = K.exchange_replicas
events = []
bank = None
initial = None


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def reference_sources():
    names = ["reference.py", "vendor/apt_icm.py", "inputs/software_spec.json",
             "inputs/graph.json", "inputs/certificate.json",
             "inputs/golden_outcomes.json", "make_vectors.py"]
    return {name: digest(R.ROOT / name) for name in names}


def verify_inputs():
    graph = json.loads((R.ROOT / "inputs/graph.json").read_text())
    certificate = json.loads((R.ROOT / "inputs/certificate.json").read_text())
    instance = R.instance()
    generated = [[int(a), int(b), int(w)] for a, b, w in
                 zip(instance.edge_u, instance.edge_v, instance.edge_w)]
    if graph["edges"] != generated or graph["betas"] != R.SPEC["betas"]:
        raise RuntimeError("Frozen graph or temperature ladder differs from the reference")
    bits = certificate["witness_bits"]
    if len(bits) != 128 or set(bits) - {"0", "1"}:
        raise RuntimeError("Malformed exact-target witness")
    score = sum(w for a, b, w in generated if bits[a] != bits[b])
    if score != certificate["target"] or score != graph["target"] or score != R.SPEC["target"]:
        raise RuntimeError("Exact-target witness does not reach the frozen target")
    if certificate["instance_digest"] != K.instance_digest(instance):
        raise RuntimeError("Certificate is for a different graph")
    return dict(graph_digest=K.instance_digest(instance), witness_score=score,
                optimality_evidence="retained exhaustive integer DP certificate",
                exact_bound_recomputed=False)


def words(state):
    flat = np.asarray(state, dtype=np.uint32).reshape(-1, 32)
    return (flat @ (np.uint32(1) << np.arange(32, dtype=np.uint32))).tolist()


def event(kind, value):
    events.append([kind, *words(value.state)])


def init(*args, **kwargs):
    global bank, initial
    bank, count = original_init(*args, **kwargs)
    initial = words(bank.state)
    event(1, bank)
    return bank, count


def update(*args, **kwargs):
    result = original_update(*args, **kwargs)
    event(2, args[1])
    return result


def icm(*args, **kwargs):
    result = original_icm(*args, **kwargs)
    if result[0]:
        event(3, args[1])
    return result


def swap(*args, **kwargs):
    result = original_swap(*args, **kwargs)
    event(4, args[0])
    return result


K.initialize_bank = init
R.ORIGINAL_UPDATE = update
K.attempt_icm = icm
K.exchange_replicas = swap


def prepare(output, trials=2, modes=("baseline", "epix")):
    if not 1 <= trials <= 1000:
        raise ValueError("trials must be 1 through 1000, the frozen trial set")
    output = Path(output)
    output.mkdir(parents=True, exist_ok=True)
    input_verification = verify_inputs()
    golden = json.loads((R.ROOT / "inputs/golden_outcomes.json").read_text())
    sources = reference_sources()
    receipts = {}
    for method in modes:
        if method not in ("baseline", "epix"):
            raise ValueError(f"Unknown mode {method}")
        started = time.monotonic()
        path = output / (method + ".bin")
        temporary = path.with_suffix(".partial")
        rows = []
        with temporary.open("wb") as stream:
            def emit(values):
                stream.write(struct.pack("<" + "I" * len(values),
                                         *[int(value) & 0xffffffff for value in values]))
            emit([trials])
            for trial in range(trials):
                events.clear()
                row = R.run(trial, method, "lfsr32", 256)
                expected = golden[str(trial)][method]
                for key, value in expected.items():
                    if row[key] != value:
                        raise RuntimeError(f"Frozen outcome mismatch: {method}/{trial}/{key}")
                seed = row["seed"]
                seeds = [*R.seed_words(seed, 2, 128), *R.seed_words(seed, 3, 1),
                         *R.seed_words(seed, 4, 1)]
                emit([trial, *seeds, *initial, int(row["exact_hit"]), row["best_cut"],
                      row["sweeps_executed"], row["local_fresh_rng_words"],
                      row["swap_rng_words"], row["icm_rng_words"],
                      row["total_replica_node_updates"], *words(bank.state), len(events)])
                for value in events:
                    emit(value)
                initial_hash = hashlib.sha256(struct.pack("<96I", *initial)).hexdigest()
                rows.append(dict(trial=trial, events=len(events), initial_state_sha256=initial_hash, **expected))
        if sources != reference_sources():
            raise RuntimeError("Reference sources changed during vector preparation")
        temporary.replace(path)
        receipt = dict(schema_version=1, passed=True, mode=method, trials=trials,
                       sweep_limit=256, rng_variant="lfsr32", sha256=digest(path),
                       sources=sources, outcomes=rows,
                       input_verification=input_verification,
                       elapsed_seconds=time.monotonic() - started,
                       energy_measurement=False)
        (output / (method + ".json")).write_text(json.dumps(receipt, indent=2) + "\n")
        receipts[method] = receipt
        print(f"VECTORS_PASS {method} {trials}", flush=True)
    return receipts


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--trials", type=int, default=2)
    parser.add_argument("--output", type=Path, default=R.ROOT / "work/vectors")
    parser.add_argument("--mode", choices=["both", "baseline", "epix"], default="both")
    args = parser.parse_args()
    prepare(args.output, args.trials,
            ("baseline", "epix") if args.mode == "both" else (args.mode,))
