"""Count cell-pin transitions and check their power annotations."""

import json
import hashlib
import math
import os
from pathlib import Path
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent

READBACK_TCL = r'''
proc epix_annotate {kind name density duty density_hz} {
  if {$kind eq "pin"} {set object [get_pins $name]} else {set object [get_ports $name]}
  if {[llength $object] != 1} {error "Activity target is missing or ambiguous: $name"}
  if {[dict exists $::epix_activity_expected $object]} {error "Duplicate activity target: $name"}
  if {$kind eq "pin"} {
    set_power_activity -pins $object -density $density -duty $duty
  } else {
    set_power_activity -input_ports $object -density $density -duty $duty
  }
  dict set ::epix_activity_expected $object [list $density_hz $duty $kind]
}
proc epix_activity_matches {density duty actual origin} {
  if {[llength $actual] != 3} {return 0}
  lassign $actual actual_density actual_duty actual_origin
  if {![string is double -strict $actual_density] || ![string is double -strict $actual_duty]} {return 0}
  # The public readback rounds density to six significant digits and duty to three decimals.
  return [expr {$actual_origin eq $origin
                && abs($actual_density - $density) <= max(1e-12, abs($density) * 1e-5)
                && abs($actual_duty - $duty) <= 0.000501}]
}
proc epix_readback_check {window phase expected_pins expected_inputs root_density} {
  set checked 0; set pins 0; set inputs 0; set errors 0
  dict for {object expected} $::epix_activity_expected {
    lassign $expected density duty kind
    incr checked
    if {$kind eq "pin"} {incr pins} else {incr inputs}
    set actual [get_property $object activity]
    if {![epix_activity_matches $density $duty $actual user]} {
      incr errors
      if {$errors <= 50} {
        puts [list ACTIVITY_READBACK_ERROR $window $phase [get_full_name $object] $expected $actual]
      }
    }
  }
  set root [get_ports clk]
  if {[llength $root] != 1} {error "Root clock port missing or ambiguous"}
  set root_activity [get_property $root activity]
  if {![epix_activity_matches $root_density 0.5 $root_activity clock]} {incr errors}
  if {$pins != $expected_pins || $inputs != $expected_inputs
      || $checked != $expected_pins + $expected_inputs} {incr errors}
  puts [join [list ACTIVITY_READBACK $window $phase $checked $pins $inputs $errors {*}$root_activity] "\t"]
  flush stdout
  if {$errors} {error "Post-power activity readback failed: $errors errors"}
}
'''


def write_window(
    directory, window, targets, counts, index, duration, period, ns_per_time_unit
):
    """Write activity values for one measured interval."""
    if duration <= 0 or not math.isfinite(ns_per_time_unit) or ns_per_time_unit <= 0:
        raise ValueError("Activity duration and Liberty time unit must be positive")
    commands = ["set epix_activity_expected [dict create]"]
    pins = sum(t[0] == "pin" for t in targets)
    inputs = sum(t[0] == "port" for t in targets)
    for i, (kind, name, _, _) in enumerate(targets):
        toggles, high, unknown = counts[i][index * 3 : index * 3 + 3]
        assert unknown == 0 and toggles >= 0 and 0 <= high <= duration, (kind, name)
        if kind == "clock":
            assert toggles == round(2 * duration / (period * 1000))
            assert 2 * high == duration
            continue
        if kind not in ("pin", "port") or any(c in name for c in "{}\n\r"):
            raise ValueError("Unsupported activity target: " + name)
        density = toggles * ns_per_time_unit / (duration / 1000)
        density_hz = toggles * 1e12 / duration
        duty = high / duration
        commands.append(
            f"epix_annotate {kind} {{{name}}} {density:.16g} {duty:.16g} {density_hz:.16g}"
        )
    (directory / (window + ".activity.tcl")).write_text("\n".join(commands) + "\n")
    (directory / (window + ".readback.tcl")).write_text(
        f"epix_readback_check {window} $epix_readback_phase {pins} {inputs} {2e9 / period:.16g}\n"
    )
    return dict(
        cell_pins=pins,
        input_ports=inputs,
        annotated_targets=pins + inputs,
        root_clock=dict(density_hz=2e9 / period, duty=0.5),
    )


def validate_readback(log, expected):
    """Check every activity value after each power report."""
    rows = {}
    for line in log.splitlines():
        if line.startswith("ACTIVITY_READBACK_ERROR"):
            raise ValueError("Post-power activity mismatch: " + line)
        if not line.startswith("ACTIVITY_READBACK\t"):
            continue
        fields = line.split("\t")
        if len(fields) != 10:
            raise ValueError("Malformed activity readback summary")
        _, window, phase, checked, pins, inputs, errors, density, duty, origin = fields
        key = (window, phase)
        if key in rows or window not in expected or phase not in ("total", "rng"):
            raise ValueError("Duplicate or unexpected activity readback phase")
        checked, pins, inputs, errors = map(int, (checked, pins, inputs, errors))
        density, duty = float(density), float(duty)
        want = expected[window]
        if (checked, pins, inputs, errors) != (
            want["annotated_targets"],
            want["cell_pins"],
            want["input_ports"],
            0,
        ):
            raise ValueError("Incomplete or failed activity readback")
        root = want["root_clock"]
        if not (
            origin == "clock"
            and math.isfinite(density)
            and math.isfinite(duty)
            and math.isclose(density, root["density_hz"], rel_tol=1e-5, abs_tol=1e-12)
            and abs(duty - root["duty"]) <= 0.000501
        ):
            raise ValueError("Root clock activity mismatch")
        rows[key] = dict(
            checked=checked,
            cell_pins=pins,
            input_ports=inputs,
            errors=errors,
            root_clock=dict(density_hz=density, duty=duty, origin=origin),
        )
    if set(rows) != {
        (window, phase) for window in expected for phase in ("total", "rng")
    }:
        raise ValueError("Missing activity readback phase")
    return dict(
        passed=True,
        expected=expected,
        windows={w: {p: rows[w, p] for p in ("total", "rng")} for w in expected},
        total_annotation_checks=sum(r["checked"] for r in rows.values()),
        required_annotation_origin="user",
        root_clock_checked_separately=True,
        density_relative_tolerance=1e-5,
        density_absolute_tolerance_hz=1e-12,
        duty_absolute_tolerance=0.000501,
        tolerance_reason="OpenSTA readback rounds density to six significant digits and duty to three decimals.",
    )


def prepare(work, mode, period, top, ns_per_time_unit=1.0):
    if ns_per_time_unit <= 0:
        raise ValueError("Liberty time unit must be positive")
    directory = work / (mode + "_power")
    directory.mkdir(exist_ok=True)
    mapped = json.loads((work / mode / "mapped.json").read_text())["modules"][top]
    trials = json.loads((work / (mode + "_gate/receipt.json")).read_text())[
        "workloads"
    ][0]["trials"]
    targets = [("clock", "clk", 0, "clk")]
    for cell, definition in mapped["cells"].items():
        for pin in definition["port_directions"]:
            name = cell + "/" + pin
            targets.append(("pin", name, 0, name))
    for name, port in mapped["ports"].items():
        if port["direction"] == "input" and name != "clk":
            width = len(port["bits"])
            for bit in range(width):
                targets.append(
                    ("port", name if width == 1 else f"{name}[{bit}]", bit, name)
                )
    target_file = directory / "targets.tsv"
    target_file.write_text(
        "".join(
            f"{i}\t{bit}\t{top}/{path}\n" for i, (_, _, bit, path) in enumerate(targets)
        )
    )
    ranges = []
    durations = []
    for k, begin in enumerate(["search_begin_cycle", "trial_begin_cycle"]):
        duration = 0
        for trial in trials:
            a, b = [round(trial[key] * period * 1000) for key in [begin, "end_cycle"]]
            ranges.append(f"{k}\t{a}\t{b}\n")
            duration += b - a
        durations.append(duration)
    range_file = directory / "windows.tsv"
    range_file.write_text("".join(ranges))
    executable = work / "activity_counter_fast"
    source = HERE / "activity_fast.cpp"
    if not executable.exists() or executable.stat().st_mtime < source.stat().st_mtime:
        compiler = os.environ.get("CXX", "c++")
        flags = []
        if sys.platform == "darwin":
            compiler = subprocess.check_output(
                ["xcrun", "--find", "clang++"], text=True
            ).strip()
            sdk = subprocess.check_output(
                ["xcrun", "--sdk", "macosx", "--show-sdk-path"], text=True
            ).strip()
            flags = ["-isysroot", sdk]
        subprocess.run(
            [compiler, *flags, "-std=c++17", "-O3", str(source), "-o", str(executable)],
            check=True,
        )
    reader = dict(
        source=source.name,
        source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
        executable_sha256=hashlib.sha256(executable.read_bytes()).hexdigest(),
    )
    counts_file = directory / "counts.tsv"
    command = [str(executable), str(target_file), str(range_file), str(counts_file)]
    trace = work / (mode + "_gate/activity.fst")
    if trace.exists():
        converter = shutil.which(os.environ.get("FST2VCD", "fst2vcd"))
        if converter is None:
            raise FileNotFoundError("FST decoder unavailable; set FST2VCD")
        converter_sha = hashlib.sha256(Path(converter).read_bytes()).hexdigest()
        reader["fst2vcd"] = dict(path=converter, sha256=converter_sha)
        producer = subprocess.Popen([converter, str(trace)], stdout=subprocess.PIPE)
        try:
            subprocess.run(command, stdin=producer.stdout, check=True)
            producer.stdout.close()
            assert producer.wait() == 0
        finally:
            if producer.poll() is None:
                producer.terminate()
                producer.wait()
        assert hashlib.sha256(Path(converter).read_bytes()).hexdigest() == converter_sha
    else:
        with (work / (mode + "_gate/activity.vcd")).open("rb") as stream:
            subprocess.run(command, stdin=stream, check=True)
    (directory / "reader.json").write_text(json.dumps(reader, indent=2) + "\n")
    counts = {}
    for line in counts_file.read_text().splitlines():
        row = [int(v) for v in line.split()]
        assert row[0] not in counts
        counts[row[0]] = row[1:]
    assert set(counts) == set(range(len(targets)))
    (directory / "activity_readback.tcl").write_text(READBACK_TCL)
    for k, window in enumerate(["search", "with_setup"]):
        coverage = write_window(
            directory,
            window,
            targets,
            counts,
            k,
            durations[k],
            period,
            ns_per_time_unit,
        )
        summary = dict(
            duration_ps=durations[k],
            clock_edges=counts[0][k * 3],
            **coverage,
            trial_count=len(trials),
            window=window,
            ns_per_library_time_unit=ns_per_time_unit,
        )
        (directory / (window + ".counts.json")).write_text(
            json.dumps(summary, indent=2) + "\n"
        )
    print("ACTIVITY_PASS", mode, flush=True)


def precomputed(work, mode, window, period):
    return work / (mode + "_power") / (window + ".activity.tcl")
