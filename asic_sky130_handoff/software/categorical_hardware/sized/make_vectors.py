#!/usr/bin/env python3
"""Create complete trial traces only after independent native-oracle agreement."""
from __future__ import annotations

import itertools
import json
import os
from pathlib import Path
import re
import struct
import time

from native_oracle import build, native_mass_table, run, sha
from reference import event_fields, Reference, masses, read_cnf, state_hash

HERE = Path(__file__).resolve().parent
MAGIC = 0x43534154


def source_hashes(case):
    files = [*HERE.glob("*.py"), HERE / "sim_main.cpp",
             HERE.parent.parent / "probsat_native/probsat_v20.c",
             HERE.parent.parent / "probsat_native/conditioned.h",
             case / "input.cnf", case / "metadata.json"]
    files.extend((case / "rtl").glob("**/*.*"))
    if (case / "input_xor.json").exists():
        files.append(case / "input_xor.json")
    return {os.path.relpath(p, case): sha(p) for p in sorted(files) if p.is_file()}


def prepare(case, directory, trials, modes, flip_limit=None):
    case, directory = Path(case).resolve(), Path(directory).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    metadata = json.loads((case / "metadata.json").read_text())
    n, clauses = read_cnf(case / "input.cnf")
    fields=event_fields(n)
    if sha(case / "input.cnf") != metadata["input_files"]["input.cnf"]:
        raise ValueError("The packaged selected input does not match its recorded hash")
    max_break = max(sum(lit in c for c in clauses) for lit in range(-n, n+1) if lit)
    table = native_mass_table(directory / "native_build", max_break)
    for breaks, native in zip(itertools.product(range(max_break+1), repeat=3), table):
        assert masses(breaks) == native, (breaks, masses(breaks), native)
    hardware_table = json.loads((case / "rtl/weights.json").read_text())
    assert hardware_table["break_max"] == max_break
    assert hardware_table["masses"] == table, "Hardware masses differ from native quantize"
    for mode in ("baseline", "epix"):
        rom = (case / "rtl" / mode / "instance.svh").read_text()
        entries = re.findall(r"\d+'d(\d+): mass_rom=34'h([0-9a-f]+);", rom)
        assert len(entries) == len(table)
        for index, packed in entries:
            native = table[int(index)]
            assert int(packed,16) == (native[0] | (native[1] << 17))
    binary, build_receipt = build(directory / "native_build")
    limit = metadata["max_flips"] if flip_limit is None else flip_limit
    if not 0 <= limit <= 0xffffffff:
        raise ValueError("flip limit must fit an unsigned 32-bit input")
    for mode in modes:
        started = time.monotonic()
        records, outcomes = [], []
        receipt_path = directory / (mode + ".json")
        receipt_path.write_text(json.dumps(dict(passed=False, stage="started")) + "\n")
        sources = source_hashes(case)
        for trial in range(trials):
            seed = metadata["replay_seed_base"] + trial
            prefix = directory / f"oracle_{mode}_{trial:04d}"
            native_events, native_receipt = run(binary, case / "input.cnf", seed,
                                                mode, limit, prefix)
            model = Reference(clauses, seed, mode, n=n)
            events = list(model.run(limit))
            if len(events) != len(native_events):
                raise ValueError(f"Native event count differs at {mode} trial {trial}")
            for event_index, (actual, expected) in enumerate(zip(events, native_events)):
                if actual != expected:
                    details = [(fields[j], a, b) for j, (a, b)
                               in enumerate(zip(actual, expected)) if a != b]
                    raise ValueError(f"Native mismatch at {mode} trial {trial}, "
                                     f"event {event_index}: {details}")
            solved = model.verify_assignment()
            assert solved == native_receipt["success"]
            if mode == "epix":
                assert model.stats["age_refreshes"] == native_receipt["refresh_reasons"][3]
                assert model.stats["first_visit_refreshes"] == native_receipt["refresh_reasons"][2]
            if solved and (case / "input_xor.json").exists():
                xor = json.loads((case / "input_xor.json").read_text())
                assert all(sum(model.bits[v] for v in c) % 2 == p
                           for c, p in zip(xor["clauses"], xor["parity"]))
            records.append((trial, seed, limit, int(solved), events))
            outcomes.append(dict(trial=trial, seed=seed, success=solved,
                flip_limit=limit, full_software_flip_budget=limit == metadata["max_flips"],
                initial_state_sha256=state_hash(events[0],n),
                final_state_sha256=state_hash(events[-1],n), flips=model.flips,
                raw_words=model.raw, reused_visits=model.reuse, refills=model.refills,
                initial_draws=n, events=len(events), num_unsat=len(model.false),
                directed_coverage=model.stats, native_oracle=native_receipt))
        path = directory / (mode + ".bin")
        with path.open("wb") as out:
            out.write(struct.pack("<4I", MAGIC, 2, trials, n))
            for trial, seed, budget, success, events in records:
                out.write(struct.pack("<5I", trial, seed, budget, success, len(events)))
                for event in events:
                    assert len(event) == len(fields)
                    out.write(struct.pack("<"+"I"*len(fields), *event))
        assert sources == source_hashes(case), "Source changed during vector generation"
        receipt = dict(schema_version=2, passed=True, case=case.name, mode=mode,
            trials=trials, sha256=sha(path), sources=sources, outcomes=outcomes,
            event_fields=fields, native_oracle=build_receipt,
            mass_table_tuples_checked=len(table), max_break=max_break,
            checks="Every initialization and completed flip: complete assignment, selected clause, "
                "break counts, masses, choice, reservoir, age, RNG and counters; final CNF and XOR satisfaction",
            portable_rng="xorshift32(13,17,5), seed zero maps to one, advance then return state >> 1",
            historical_libc_rng_equivalence=False, energy_measurement=False,
            elapsed_seconds=time.monotonic()-started)
        receipt_path.write_text(json.dumps(receipt, indent=2)+"\n")
        print(f"VECTORS_PASS {case.name} {mode} trials={trials} "
              f"events={sum(x['events'] for x in outcomes)}", flush=True)
