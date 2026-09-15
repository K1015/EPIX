#!/usr/bin/env python3
"""Run offline reference generation and RTL agreement with installed tools."""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import platform
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def run(command, log, timeout):
    with log.open("w") as stream:
        process = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT,
                                   start_new_session=True)
        try:
            return_code = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            raise
        if return_code:
            raise subprocess.CalledProcessError(return_code, command)


def validate_vectors(directory, mode, trials):
    receipt = json.loads((directory / (mode + ".json")).read_text())
    if not receipt["passed"] or receipt["trials"] < trials:
        raise RuntimeError(f"Prepare at least {trials} {mode} vectors first")
    if sha(directory / (mode + ".bin")) != receipt["sha256"]:
        raise RuntimeError("Vector binary does not match its receipt")
    for name, value in receipt["sources"].items():
        if sha(ROOT / name) != value:
            raise RuntimeError(f"Regenerate vectors after source changes: {name}")
    return receipt


def validate_rtl(args, mode):
    vectors = args.work_dir / "vectors"
    vector_receipt = validate_vectors(vectors, mode, args.trials)
    tool = shutil.which(args.verilator)
    if not tool:
        raise RuntimeError("Verilator unavailable; use --verilator or VERILATOR")
    directory = args.work_dir / ("rtl_" + mode)
    directory.mkdir(parents=True, exist_ok=True)
    source = ROOT / "rtl" / mode
    files = [*sorted(source.glob("*.sv*")), ROOT / "sim_main.cpp"]
    hashes = {str(path.relative_to(ROOT)): sha(path) for path in files}
    validation_path = directory / "validation.json"
    validation_path.write_text(json.dumps(dict(schema_version=1, passed=False,
                                stage="started", mode=mode, trials=args.trials,
                                sources=hashes), indent=2) + "\n")
    command = [tool, "--cc", "--exe",
               "--trace", "-Wno-fatal", "--top-module", "corrected_solver",
               "--prefix", "Vcorrected_solver", "--Mdir", str(directory),
               "-I" + str(source), "-DEPIX_MODE=" + str(int(mode == "epix")),
               str(source / "solver.sv"), str(source / "clock_gate_sim.sv"),
               str(ROOT / "sim_main.cpp")]
    started = time.monotonic()
    print(f"BUILD {mode}; log {directory / 'build.log'}", flush=True)
    run(command, directory / "build.log", args.build_timeout)
    make = ["make"]
    if sys.platform == "darwin" and platform.machine() == "arm64":
        # The installed Verilator frontend may run through Intel translation.
        # Invoke native Make separately so the compiler uses the native SDK.
        make = ["/usr/bin/arch", "-arm64", "/usr/bin/make"]
    build_command = [*make, "-C", str(directory), "-f", "Vcorrected_solver.mk",
                     "-j", str(args.jobs)]
    run(build_command, directory / "compile.log", args.build_timeout)
    receipt_path = directory / "trials.tsv"
    run([str(directory / "Vcorrected_solver"), str(vectors / (mode + ".bin")),
         str(args.trials), str(receipt_path)], directory / "simulation.log", args.run_timeout)
    with receipt_path.open() as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    if [int(row["trial"]) for row in rows] != list(range(args.trials)):
        raise RuntimeError("Simulator did not complete the requested trial set")
    if hashes != {str(path.relative_to(ROOT)): sha(path) for path in files}:
        raise RuntimeError("RTL source changed during validation")
    receipt = dict(schema_version=1, passed=True, stage="rtl", mode=mode,
                   trials=args.trials, sources=hashes,
                   vector_sha256=vector_receipt["sha256"],
                   verilator_version=subprocess.check_output([tool, "--version"], text=True).strip(),
                   generation_command=command, build_command=build_command,
                   receipt_sha256=sha(receipt_path),
                   elapsed_seconds=time.monotonic() - started,
                   checks="Every recorded intermediate replica state, final state, success, sweeps and RNG/update counters",
                   energy_measurement=False)
    validation_path.write_text(json.dumps(receipt, indent=2) + "\n")
    print(f"RTL_PASS {mode} {args.trials}", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vectors", action="store_true", help="Regenerate reference vectors")
    parser.add_argument("--rtl", action="store_true", help="Build and compare complete RTL")
    parser.add_argument("--trials", type=int, default=2)
    parser.add_argument("--mode", choices=["both", "baseline", "epix"], default="both")
    parser.add_argument("--work-dir", type=Path, default=ROOT / "work")
    parser.add_argument("--verilator", default=os.environ.get("VERILATOR", "verilator"))
    parser.add_argument("--jobs", type=int, default=2)
    parser.add_argument("--build-timeout", type=int, default=1800)
    parser.add_argument("--run-timeout", type=int, default=600)
    args = parser.parse_args()
    if not (args.vectors or args.rtl):
        parser.error("select --vectors and/or --rtl")
    if not 1 <= args.trials <= 1000 or not 1 <= args.jobs <= 64:
        parser.error("trials must be 1..1000 and jobs must be 1..64")
    args.work_dir = args.work_dir.resolve()
    args.work_dir.mkdir(parents=True, exist_ok=True)
    modes = ("baseline", "epix") if args.mode == "both" else (args.mode,)
    if args.vectors:
        from make_vectors import prepare
        prepare(args.work_dir / "vectors", args.trials, modes)
    if args.rtl:
        for mode in modes:
            validate_rtl(args, mode)


if __name__ == "__main__":
    main()
