#!/usr/bin/env python3
"""Check that OpenSTA preserves the supplied pin activity."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sta", required=True, type=Path)
    parser.add_argument(
        "--liberty", type=Path, default=HERE.parents[1] / "tech/sky130_hd.lib"
    )
    parser.add_argument("--output", type=Path, default=Path("PIN_ACTIVITY.json"))
    args = parser.parse_args()
    files = [
        args.sta.resolve(),
        args.liberty.resolve(),
        HERE / "pin_activity.v",
        HERE / "pin_activity.tcl",
    ]
    before = {str(path): sha(path) for path in files}
    environment = dict(
        os.environ, TEST_LIBERTY=str(files[1]), TEST_NETLIST=str(files[2])
    )
    command = [str(files[0]), "-exit", str(files[3])]
    result = subprocess.run(
        command,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=60,
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.with_suffix(".log").write_text(result.stdout)
    # A zero exit code may hide Tcl errors. Check both pass markers.
    assert result.returncode == 0 and "Error:" not in result.stdout, result.stdout
    assert [
        line
        for line in result.stdout.splitlines()
        if line.startswith("PIN_ACTIVITY_PASS")
    ] == ["PIN_ACTIVITY_PASS first 15", "PIN_ACTIVITY_PASS repeated 15"], result.stdout
    assert before == {
        str(path): sha(path) for path in files
    }, "Input changed during validation"
    receipt = dict(
        passed=True,
        command=command,
        hashes=before,
        explicit_annotations=15,
        power_reports=2,
        total_annotation_checks=30,
        root_clock_preserved=True,
        test_power_is_not_an_experiment_result=True,
    )
    args.output.write_text(json.dumps(receipt, indent=2) + "\n")
    print("PASS: 15 explicit activities preserved after both power reports")


if __name__ == "__main__":
    main()
