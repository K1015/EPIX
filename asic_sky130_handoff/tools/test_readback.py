#!/usr/bin/env python3
"""Exercise complete power-activity readback with ns and ps Liberty units."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "flow"))
import activity

PIN_VALUES = """
ff/CLK .008 .3  ff/D .01 .4  ff/Q .007 .3
gate/A .007 .3  gate/B .005 .6  gate/X .003 .2
buffer/A .003 .2  buffer/X .003 .2
clock_gate/CLK .02 .5  clock_gate/GATE .005 .6  clock_gate/GCLK .008 .3
inverter/A .008 .3  inverter/Y .008 .7
""".split()


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_sta(sta, script, path):
    path.write_text("\n".join(script) + "\n")
    return subprocess.run([sta, "-exit", str(path)], text=True, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, timeout=60)


def targets_and_counts():
    targets = [("clock", "clk", 0, "clk")]
    counts = {0: [20, 500000, 0] * 2}
    for kind, values in (("pin", PIN_VALUES), ("port", "d .01 .4 en .005 .6".split())):
        for name, density, duty in zip(values[::3], values[1::3], values[2::3]):
            counts[len(targets)] = [round(float(density) * 1000), round(float(duty) * 1000000), 0] * 2
            targets.append((kind, name, 0, name))
    return targets, counts


def check_unit(sta, source_lib, folder, unit, label):
    folder.mkdir()
    liberty = folder / "test.lib"
    assert source_lib.count('time_unit : "1ns";') == 1
    liberty.write_text(source_lib.replace('time_unit : "1ns";', f'time_unit : "{label}";'))
    (folder / "helper.tcl").write_text(activity.READBACK_TCL)
    targets, counts = targets_and_counts()
    expected = {window: activity.write_window(folder, window, targets, counts, index,
                                              1000000, 100, unit)
                for index, window in enumerate(("search", "with_setup"))}
    script = [f"read_liberty {{{liberty}}}", f"read_verilog {{{HERE / 'pin_activity.v'}}}",
              "link_design pin_activity", f"create_clock -name clk -period {100 / unit:g} [get_ports clk]",
              f"source {{{folder / 'helper.tcl'}}}"]
    for window in expected:
        script += ["sta::clear_power", f"source {{{folder / (window + '.activity.tcl')}}}"]
        for phase in ("total", "rng"):
            script += ["report_power", f"set epix_readback_phase {phase}",
                       f"source {{{folder / (window + '.readback.tcl')}}}"]
    script.append("exit")
    result = run_sta(sta, script, folder / "test.tcl")
    assert result.returncode == 0 and "Error:" not in result.stdout, result.stdout
    receipt = activity.validate_readback(result.stdout, expected)
    assert receipt["total_annotation_checks"] == 60

    lines = result.stdout.splitlines()
    first = next(line for line in lines if line.startswith("ACTIVITY_READBACK\t"))
    bad_frequency = first.split("\t")
    bad_frequency[7] = str(float(bad_frequency[7]) / 2)
    negatives = {
        "missing_phase": "\n".join(line for line in lines if not line.startswith("ACTIVITY_READBACK\twith_setup\trng\t")),
        "incomplete_count": result.stdout.replace("\tsearch\ttotal\t15\t13\t2\t0", "\tsearch\ttotal\t14\t12\t2\t0"),
        "root_origin": result.stdout.replace("\tclock", "\tuser"),
        "root_frequency": result.stdout.replace(first, "\t".join(bad_frequency)),
        "explicit_mismatch": result.stdout + "\nACTIVITY_READBACK_ERROR x y z\n",
        "duplicate_phase": result.stdout + "\n" + first + "\n",
    }
    for name, text in negatives.items():
        assert text != result.stdout, name + " did not alter its input"
        try:
            activity.validate_readback(text, expected)
        except ValueError:
            pass
        else:
            raise AssertionError(name + " was accepted")

    # Exercise the real Tcl check with one deliberately wrong expected duty.
    bad_script = script.copy()
    bad_script.insert(bad_script.index("report_power"),
                      "set obj [get_pins gate/X]; dict set ::epix_activity_expected $obj {3000000 0.9 pin}")
    bad = run_sta(sta, bad_script, folder / "bad.tcl")
    assert "ACTIVITY_READBACK_ERROR search total gate/X" in bad.stdout, bad.stdout
    return dict(liberty_time_unit=label, passed=True, annotation_checks=60,
                negative_cases=[*negatives, "actual_wrong_expected_duty"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sta", default=os.environ.get("OPENSTA", "sta"))
    parser.add_argument("--output", type=Path, default=HERE.parent / "build/tools/READBACK_VALIDATION.json")
    args = parser.parse_args()
    sta = shutil.which(args.sta)
    if not sta:
        raise FileNotFoundError("OpenSTA unavailable; use --sta or OPENSTA")
    liberty = ROOT / "tech/sky130_hd/sky130_fd_sc_hd__tt_025C_1v80.lib"
    source_lib = liberty.read_text()
    with tempfile.TemporaryDirectory(prefix="maxcut-readback-") as directory:
        results = [check_unit(sta, source_lib, Path(directory) / label, unit, label)
                   for unit, label in ((1.0, "1ns"), (0.001, "1ps"))]
    receipt = dict(passed=True, cases=results, sta_binary_sha256=sha(Path(sta)),
                   liberty_sha256=sha(liberty), fixture_sha256=sha(HERE / "pin_activity.v"),
                   source_sha256={str(path.relative_to(ROOT)): sha(path)
                                  for path in (ROOT / "flow/activity.py", ROOT / "flow/power.py")},
                   validation_script_sha256=sha(Path(__file__)))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(receipt, indent=2) + "\n")
    print("PASS: 120 annotation checks; all 14 negative checks rejected")


if __name__ == "__main__":
    main()
