#!/usr/bin/env python3
"""Relocatable native-oracle and RTL validation for sized SAT and XOR-SAT."""
from __future__ import annotations

import argparse
import csv
import json
import os
from pathlib import Path
import platform
import shutil
import signal
import subprocess
import sys
import time

from make_vectors import prepare
from native_oracle import sha

HERE = Path(__file__).resolve().parent


def run(command, logfile, timeout):
    with logfile.open("w") as stream:
        process = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT,
                                   start_new_session=True)
        try:
            result = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            raise
        if result:
            raise RuntimeError(f"Command failed ({result}); see {logfile}")


def validate(args, case, mode):
    vectors = args.work_dir / "vectors"
    vreceipt = json.loads((vectors / (mode + ".json")).read_text())
    if not vreceipt["passed"] or vreceipt["trials"] < args.trials:
        raise ValueError("Insufficient validated reference trials")
    assert sha(vectors / (mode+".bin")) == vreceipt["sha256"]
    for name, digest in vreceipt["sources"].items():
        assert sha(case/name) == digest, f"Reference input changed: {name}"
    tool = shutil.which(args.verilator)
    if not tool:
        raise RuntimeError("Verilator is required; use --verilator or VERILATOR")
    source = case / "rtl" / mode
    directory = args.work_dir / ("rtl_"+mode)
    directory.mkdir(parents=True, exist_ok=True)
    files = [*sorted(source.glob("*.sv*")), HERE / "sim_main.cpp"]
    hashes = {os.path.relpath(p, case): sha(p) for p in files}
    receipt_path = directory / "validation.json"
    receipt_path.write_text(json.dumps(dict(passed=False, stage="started", sources=hashes))+"\n")
    command = [tool, "--cc", "--exe", "--trace", "-Wno-fatal",
               "--top-module", "categorical_solver", "--prefix", "Vcategorical_solver",
               "--Mdir", str(directory), "-I"+str(source),
               "-DEPIX_MODE="+str(int(mode=="epix")), str(source / "solver.sv"),
               str(source / "clock_gate_sim.sv"), str(HERE / "sim_main.cpp")]
    started = time.monotonic()
    print(f"BUILD {case.name} {mode}; log {directory / 'build.log'}", flush=True)
    run(command, directory / "build.log", args.build_timeout)
    make = ["make"]
    if sys.platform == "darwin" and platform.machine() == "arm64":
        make = ["/usr/bin/arch", "-arm64", "/usr/bin/make"]
    build = [*make, "-C", str(directory), "-f", "Vcategorical_solver.mk",
             "-j", str(args.jobs)]
    run(build, directory / "compile.log", args.build_timeout)
    trials_path = directory / "trials.tsv"
    run([str(directory / "Vcategorical_solver"), str(vectors / (mode+".bin")),
         str(args.trials), str(trials_path)], directory / "simulation.log", args.run_timeout)
    with trials_path.open() as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    assert [int(r["trial"]) for r in rows] == list(range(args.trials))
    for actual, expected in zip(rows, vreceipt["outcomes"]):
        for field in ("trial", "success", "flips", "raw_words", "reused_visits",
                      "refills", "initial_draws", "events"):
            assert int(actual[field]) == int(expected[field]), (field, actual, expected)
        assert int(actual["setup_begin"]) < int(actual["search_begin"]) < int(actual["end"])
    assert hashes == {os.path.relpath(p, case): sha(p) for p in files}
    receipt = dict(schema_version=1, passed=True, case=case.name, mode=mode,
        trials=args.trials, stage="rtl", sources=hashes,
        vector_sha256=vreceipt["sha256"], receipt_sha256=sha(trials_path),
        generation_command=command, build_command=build,
        verilator_version=subprocess.check_output([tool,"--version"], text=True).strip(),
        checks=vreceipt["checks"], events_checked=sum(int(r["events"]) for r in rows),
        elapsed_seconds=time.monotonic()-started, energy_measurement=False)
    receipt_path.write_text(json.dumps(receipt, indent=2)+"\n")
    print(f"RTL_PASS {case.name} {mode} trials={args.trials} "
          f"events={receipt['events_checked']}", flush=True)


def main(case):
    case = Path(case).resolve()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vectors", action="store_true")
    parser.add_argument("--rtl", action="store_true")
    parser.add_argument("--trials", type=int, default=1)
    parser.add_argument("--mode", choices=("both","baseline","epix"), default="both")
    parser.add_argument("--flip-limit", type=int, default=None,
                        help="Override for directed tests; omitted uses the recorded complete software budget")
    parser.add_argument("--work-dir", type=Path, default=case/"work")
    parser.add_argument("--verilator", default=os.environ.get("VERILATOR","verilator"))
    parser.add_argument("--jobs", type=int, default=2)
    parser.add_argument("--build-timeout", type=int, default=1800)
    parser.add_argument("--run-timeout", type=int, default=600)
    args = parser.parse_args()
    if not (args.vectors or args.rtl):
        parser.error("select --vectors and/or --rtl")
    if not 1 <= args.trials <= 1000 or not 1 <= args.jobs <= 2:
        parser.error("trials must be 1..1000 and jobs 1..2")
    args.work_dir = args.work_dir.resolve()
    args.work_dir.mkdir(parents=True, exist_ok=True)
    modes = ("baseline","epix") if args.mode == "both" else (args.mode,)
    if args.vectors:
        prepare(case, args.work_dir/"vectors", args.trials, modes, args.flip_limit)
    if args.rtl:
        for mode in modes:
            validate(args, case, mode)
