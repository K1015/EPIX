#!/usr/bin/env python3
"""Prepare or run a portable, guarded Liberty mapping and timing flow."""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time

try:
    from .netlist_repair import PinLibrary, _body, _outer, repair_clock_design, repair_electrical_design
except ImportError:
    from netlist_repair import PinLibrary, _body, _outer, repair_clock_design, repair_electrical_design

ROOT = Path(__file__).resolve().parents[1]
IDENTIFIER = re.compile(r"[A-Za-z_][A-Za-z0-9_$]*\Z")
DEFAULT_SOURCE_ICG = dict(cell="sky130_fd_sc_hd__dlclkp_1", clock_pin="CLK", enable_pin="GATE", output_pin="GCLK")


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def package_path(path):
    path = Path(path).expanduser()
    return path.resolve() if path.is_absolute() else (ROOT / path).resolve()


def inside(path, base):
    path = (base / path).resolve()
    if not path.is_relative_to(base.resolve()):
        raise ValueError(f"Case input escapes its directory: {path}")
    if not path.exists():
        raise FileNotFoundError(path)
    return path


def identifier(value):
    if not isinstance(value, str) or not IDENTIFIER.fullmatch(value):
        raise ValueError(f"Unsupported Verilog identifier: {value!r}")
    return value


def number(value, label, *, positive=False):
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value):
        raise ValueError(f"{label} must be finite")
    if value < 0 or (positive and value == 0):
        raise ValueError(f"{label} must be {'positive' if positive else 'nonnegative'}")
    return value


def yquote(value):
    return json.dumps(str(value))


def tquote(value):
    value = str(value)
    if any(x in value for x in "{}\n\r"):
        raise ValueError("Tcl paths and identifiers cannot contain braces or newlines")
    return "{" + value + "}"


def liberty_units(text):
    time_match = re.search(r'\btime_unit\s*:\s*"([\d.eE+-]+)([a-z]+)"\s*;', text)
    cap_match = re.search(r'\bcapacitive_load_unit\s*\(\s*([\d.eE+-]+)\s*,\s*"([a-z]+)"\s*\)', text)
    if not time_match or not cap_match:
        raise ValueError("Liberty must declare time_unit and capacitive_load_unit")
    time_scale = {"s": 1e9, "ms": 1e6, "us": 1e3, "ns": 1, "ps": 1e-3, "fs": 1e-6}
    cap_scale = {"f": 1e12, "nf": 1e3, "pf": 1, "ff": 1e-3, "af": 1e-6}
    ns = float(time_match[1]) * time_scale[time_match[2]]
    pf = float(cap_match[1]) * cap_scale[cap_match[2]]
    number(ns, "Liberty time scale", positive=True)
    number(pf, "Liberty capacitance scale", positive=True)
    return dict(ns_per_time_unit=ns, pf_per_capacitance_unit=pf)


def cell_body(text, name):
    found = re.search(r'\bcell\s*\(\s*"?' + re.escape(name) + r'"?\s*\)\s*\{', text)
    if not found:
        raise ValueError(f"Missing Liberty cell: {name}")
    return _body(text, found.end() - 1)


def signal_pins(body):
    result = {}
    for match in re.finditer(r'\bpin\s*\(\s*"?([^"\s)]+)"?\s*\)\s*\{', body):
        attrs = _outer(_body(body, match.end() - 1))
        direction = re.search(r'\bdirection\s*:\s*"?(input|output|inout)"?\s*;', attrs)
        if direction:
            result[match[1]] = direction[1]
    return result


def load_technology(path):
    path = package_path(path)
    config = json.loads(path.read_text())
    if config.get("schema_version") != 1:
        raise ValueError("Technology schema_version must be 1")
    identifier(config["id"])
    lib = (path.parent / config["liberty"]).resolve()
    license_file = (path.parent / config["license"]).resolve()
    for file, key in [(lib, "liberty_sha256"), (license_file, "license_sha256")]:
        if not file.is_file() or not file.stat().st_size:
            raise FileNotFoundError(f"Missing nonempty technology file: {file}")
        if not re.fullmatch(r"[a-f0-9]{64}", config[key]) or sha(file) != config[key]:
            raise ValueError(f"Technology hash mismatch: {file}; record the new bytes explicitly")
    text = lib.read_text()
    units = liberty_units(text)
    gate, buffer = config["icg"], config["buffer"]
    if gate.get("semantics") != "latch_low_enable_high":
        raise ValueError("This adapter supports a low-transparent, active-high clock enable with noninverted output")
    for group in (gate, buffer):
        for key, value in group.items():
            if key.endswith("pin") or key == "cell":
                identifier(value)
    gp = signal_pins(cell_body(text, gate["cell"]))
    expected = {gate["clock_pin"]: "input", gate["enable_pin"]: "input", gate["output_pin"]: "output"}
    if gate.get("test_enable_pin"):
        expected[gate["test_enable_pin"]] = "input"
    if gp != expected:
        raise ValueError(f"ICG signal-pin contract differs: expected {expected}; Liberty has {gp}")
    buffer_body = cell_body(text, buffer["cell"])
    bp = signal_pins(buffer_body)
    if bp != {buffer["input_pin"]: "input", buffer["output_pin"]: "output"}:
        raise ValueError("Buffer must have one input and one noninverting output; verify its Liberty function")
    output_match = re.search(r'\bpin\s*\(\s*"?' + re.escape(buffer["output_pin"]) + r'"?\s*\)\s*\{', buffer_body)
    output_body = _outer(_body(buffer_body, output_match.end() - 1))
    function = re.search(r'\bfunction\s*:\s*"([^"]+)"\s*;', output_body)
    if not function or re.sub(r"[\s()]", "", function[1]) != buffer["input_pin"]:
        raise ValueError("Selected buffer Liberty function must directly pass its input to its output")
    cell_body(text, identifier(config["driving_cell"]))
    for key in ("period_ns", "transition_ns", "uncertainty_ns"):
        number(config["clock"][key], f"clock.{key}", positive=(key == "period_ns"))
    for key in ("input_transition_ns", "input_delay_ns", "output_delay_ns", "output_load_pf"):
        number(config["io"][key], f"io.{key}")
    if not isinstance(config["clock"]["propagated"], bool):
        raise ValueError("clock.propagated must be boolean")
    max_fanout = config["mapping"]["max_clock_fanout"]
    if isinstance(max_fanout, bool) or not isinstance(max_fanout, int) or not 2 <= max_fanout <= 16:
        raise ValueError("mapping.max_clock_fanout must be an integer from 2 through 16")
    abc = (path.parent / config["mapping"]["abc_script"]).resolve()
    if not abc.is_file():
        raise FileNotFoundError(abc)
    return dict(config=config, path=path, liberty=lib, license=license_file, units=units, abc=abc)


def gate_model(gate):
    cell, clk, en, out = [gate[k] for k in ("cell", "clock_pin", "enable_pin", "output_pin")]
    test = gate.get("test_enable_pin")
    test_decl = f", input {test}" if test else ""
    enable = f"({en} | {test})" if test else en
    return ("// Functional model only. Cell timing and power come from the hashed Liberty.\n"
            f"module {cell}(input {clk}, input {en}{test_decl}, output {out});\n"
            "reg gate_latched;\n"
            f"always @* if (!{clk}) gate_latched = {enable};\n"
            f"assign {out} = {clk} & gate_latched;\nendmodule\n")


def remap_gates(text, source, target):
    pattern = re.compile(r"\b" + re.escape(source["cell"]) + r"\s+([A-Za-z_][A-Za-z0-9_$]*)\s*\((.*?)\);", re.S)
    def replace(match):
        ports = match[2]
        # Replace port names simultaneously, including libraries whose pins swap names.
        pin_map = {source[key]: target[key] for key in ("clock_pin", "enable_pin", "output_pin")}
        ports = re.sub(r"\.([A-Za-z_][A-Za-z0-9_$]*)(?=\s*\()", lambda m: "." + pin_map.get(m[1], m[1]), ports)
        if target.get("test_enable_pin"):
            ports += f", .{target['test_enable_pin']}(1'b0)"
        return f"{target['cell']} {match[1]}({ports});"
    return pattern.sub(replace, text)


def prepare(case="cases/maxcut128", tech="tech/sky130_hd/config_200ns.json", mode="baseline", work="work"):
    case = package_path(case)
    case_file = case / "asic.json"
    if not case_file.is_file():
        raise FileNotFoundError(f"No ASIC adapter at {case_file}. A native software instance is not synthesizable RTL.")
    design = json.loads(case_file.read_text())
    if design.get("schema_version") != 1:
        raise ValueError("Case schema_version must be 1")
    if mode not in design["modes"]:
        raise ValueError(f"Mode {mode!r} absent from {case_file}")
    selected = design["modes"][mode]
    if not selected.get("rtl"):
        raise ValueError(f"Mode {mode} has no RTL sources")
    top, clock_port = identifier(design["top"]), identifier(design.get("clock_port", "clk"))
    technology = load_technology(tech)
    config, lib, units = technology["config"], technology["liberty"], technology["units"]
    directory = package_path(work) / case.name / config["id"] / identifier(mode)
    directory.mkdir(parents=True, exist_ok=True)
    source_icg = design.get("source_icg", DEFAULT_SOURCE_ICG)
    for key in DEFAULT_SOURCE_ICG:
        identifier(source_icg[key])
    files = set()
    for name in selected["rtl"]:
        files.add(inside(name, case))
    include_dirs = [inside(x, case) for x in selected.get("include_dirs", [])]
    for include in include_dirs:
        if not include.is_dir():
            raise ValueError(f"Include directory is not a directory: {include}")
        files.update(p for p in include.rglob("*") if p.is_file())
    source_hashes = {str(p.relative_to(case)): sha(p) for p in sorted(files)}
    for p in sorted(files):
        output = directory / "staged" / p.relative_to(case)
        output.parent.mkdir(parents=True, exist_ok=True)
        if p.suffix in (".sv", ".v", ".svh", ".vh"):
            output.write_text(remap_gates(p.read_text(), source_icg, config["icg"]))
        else:
            shutil.copyfile(p, output)
    (directory / "clock_gate_sim.sv").write_text(gate_model(config["icg"]))
    defines = []
    for key, value in selected.get("defines", {}).items():
        identifier(key)
        if not isinstance(value, int) or isinstance(value, bool):
            raise ValueError("This case adapter requires integer macro values")
        defines.extend(["-D", f"{key}={value}"])
    # Slang's Yosys pass receives literal quotes from the Yosys command parser.
    # Its own command-file parser handles paths with spaces correctly. Run Yosys
    # in the prepared directory using the local command-file name.
    slang_args = ["--no-implicit-memories", "--top " + top]
    slang_args += ["-D " + f"{key}={value}" for key, value in selected.get("defines", {}).items()]
    slang_args += ["-I " + yquote(directory / "staged" / p.relative_to(case)) for p in include_dirs]
    slang_args += [yquote(directory / "staged" / x) for x in selected["rtl"]]
    (directory / "slang.f").write_text("\n".join(slang_args) + "\n")
    frontend = "read_slang -F slang.f"
    (directory / "abc.constr").write_text(f"set_driving_cell {config['driving_cell']}\nset_load {config['io']['output_load_pf'] * 1000:.12g}\n")
    shutil.copyfile(technology["abc"], directory / "mapping.abc")
    script = f'''read_liberty -lib -ignore_miss_func {yquote(lib)}
{frontend}
hierarchy -check -top {top}
synth -top {top} -noabc
select -assert-none t:$mem*
check -assert
write_rtlil {yquote(directory / 'registers.il')}
dfflibmap -liberty {yquote(lib)}
abc -constr {yquote(directory / 'abc.constr')} -script {yquote(directory / 'mapping.abc')} -liberty {yquote(lib)}
clean -purge
check -assert
write_json {yquote(directory / 'mapped_unbuffered.json')}
'''
    (directory / "synth.ys").write_text(script)
    emit = f'''read_json {yquote(directory / 'mapped.json')}
hierarchy -check -top {top}
select -assert-none t:$mem*
check -assert
tee -o {yquote(directory / 'stat.json')} stat -json -liberty {yquote(lib)}
write_verilog -noattr -noexpr -nodec -norename {yquote(directory / 'mapped.v')}
'''
    (directory / "emit_netlist.ys").write_text(emit)
    (directory / "cells_sim.ys").write_text(f"read_liberty -ignore_miss_func {yquote(lib)}\nwrite_verilog -noattr {yquote(directory / 'cells_sim.raw.v')}\n")
    ns, pf = units["ns_per_time_unit"], units["pf_per_capacitance_unit"]
    clk, io = config["clock"], config["io"]
    sdc = f'''# Explicit units are converted from ns and pF to this Liberty's units.
create_clock -name clk -period {clk['period_ns']/ns:.12g} [get_ports {clock_port}]
set_clock_transition {clk['transition_ns']/ns:.12g} [get_clocks clk]
set_clock_uncertainty {clk['uncertainty_ns']/ns:.12g} [get_clocks clk]
set_input_transition {io['input_transition_ns']/ns:.12g} [all_inputs -no_clocks]
set_input_delay {io['input_delay_ns']/ns:.12g} -clock clk [all_inputs -no_clocks]
set_output_delay {io['output_delay_ns']/ns:.12g} -clock clk [all_outputs]
set_load {io['output_load_pf']/pf:.12g} [all_outputs]
'''
    if clk["propagated"]:
        sdc += "set_propagated_clock [get_clocks clk]\n"
    (directory / "constraints.sdc").write_text(sdc)
    sta = f'''read_liberty {tquote(lib)}
read_verilog {tquote(directory / 'mapped.v')}
link_design {top}
read_sdc {tquote(directory / 'constraints.sdc')}
report_units
report_checks -path_delay max -group_path_count 3 -digits 9 > {tquote(directory / 'setup.txt')}
report_checks -path_delay min -group_path_count 3 -digits 9 > {tquote(directory / 'hold.txt')}
report_check_types -max_slew -max_capacitance -violators -digits 9 > {tquote(directory / 'electrical.txt')}
check_setup > {tquote(directory / 'check_setup.txt')}
exit
'''
    (directory / "timing.tcl").write_text(sta)
    scripts = ["synth.ys", "slang.f", "emit_netlist.ys", "cells_sim.ys", "constraints.sdc", "timing.tcl", "abc.constr", "mapping.abc", "clock_gate_sim.sv"]
    binding = dict(case_manifest_sha256=sha(case_file), source_sha256=source_hashes,
                   technology_config_sha256=sha(technology["path"]), liberty_sha256=sha(lib),
                   license_sha256=sha(technology["license"]), abc_sha256=sha(technology["abc"]),
                   flow_sha256={p.name: sha(p) for p in (Path(__file__), Path(__file__).with_name("netlist_repair.py"))}, mode=mode)
    fingerprint = hashlib.sha256(json.dumps(binding, sort_keys=True).encode()).hexdigest()
    plan = dict(schema_version=1, stage="prepared", prepared_unix=time.time(), directory=str(directory),
                case=str(case), case_name=case.name, mode=mode, top=top, clock_port=clock_port,
                technology_config=str(technology["path"]), liberty=str(lib), config=config, units=units,
                expected_icg_count=selected.get("expected_icg_count"),
                rng_audit=selected.get("rng_audit", design.get("rng_audit")), binding=binding,
                design_fingerprint=fingerprint, scripts_sha256={x: sha(directory / x) for x in scripts},
                estimate_scope=config.get("estimate_scope", "mapped_cell_power_without_interconnect_parasitics"))
    write_json(directory / "resolved.json", plan)
    return plan


def discover_tool(name):
    env_name = {"yosys": "YOSYS", "sta": "OPENSTA", "verilator": "VERILATOR"}.get(name, name.upper())
    candidate = os.environ.get(env_name, name)
    result = shutil.which(candidate)
    if not result:
        raise FileNotFoundError(f"Cannot find {name}; install it on PATH or set {env_name} to its executable")
    return result


def yosys_command():
    result = [discover_tool("yosys"), "-Q", "-T"]
    plugin = os.environ.get("YOSYS_SLANG_PLUGIN")
    if plugin:
        result += ["-m", plugin]
    return result


def run_logged(cmd, log, cwd=None, timeout=None):
    log = Path(log)
    log.parent.mkdir(parents=True, exist_ok=True)
    with log.open("w") as output:
        subprocess.run(list(map(str, cmd)), cwd=cwd, stdout=output, stderr=subprocess.STDOUT,
                       check=True, timeout=timeout)
    text = log.read_text(errors="replace")
    if re.search(r"(?im)^\s*(?:error(?:\s|:)|ERROR:)", text):
        raise RuntimeError(f"Tool reported an error; inspect {log}")
    return text


def checked_tools(directory):
    directory = Path(directory)
    command = yosys_command()
    probe = run_logged(command + ["-p", "help read_slang"], directory / "read_slang.log")
    if "--no-implicit-memories" not in probe:
        raise RuntimeError("Yosys read_slang with --no-implicit-memories is required; load a compatible slang plugin using YOSYS_SLANG_PLUGIN")
    return dict(yosys=run_logged(command + ["-V"], directory / "yosys_version.txt").strip(),
                yosys_executable=command[0], slang_plugin=os.environ.get("YOSYS_SLANG_PLUGIN"))


def audit_netlist(plan):
    directory = Path(plan["directory"])
    design = json.loads((directory / "mapped.json").read_text())
    cells = design["modules"][plan["top"]]["cells"]
    liberty_text = Path(plan["liberty"]).read_text()
    types = sorted({c["type"] for c in cells.values()})
    bodies = {}
    for cell in types:
        bodies[cell] = cell_body(liberty_text, cell)
    icg = plan["config"]["icg"]["cell"]
    unintended_latches = [cell for cell, body in bodies.items()
                          if cell != icg and re.search(r"\blatch\s*\(", body)]
    if unintended_latches:
        raise ValueError(f"Unexpected latch cell types: {unintended_latches}")
    gates = sum(c["type"] == icg for c in cells.values())
    expected = plan.get("expected_icg_count")
    if expected is not None and gates != expected:
        raise ValueError(f"Expected {expected} ICGs, found {gates}")
    audit = dict(passed=True, cell_count=len(cells), cell_types=types, icg_count=gates,
                 all_cells_in_liberty=True, implicit_memory_cells=0, unintended_latches=0)
    rng_spec = plan.get("rng_audit")
    if rng_spec is None and plan["case_name"] == "maxcut128":
        rng_spec = dict(nets=[dict(name=f"lane[{i}].rng_state", width=32) for i in range(128)], expected_registers=4096)
    if rng_spec is not None:
        module = design["modules"][plan["top"]]
        drivers = {}
        for name, cell in cells.items():
            for pin, bits in cell["connections"].items():
                if cell["port_directions"][pin] == "output":
                    for bit in bits:
                        if isinstance(bit, int):
                            if bit in drivers:
                                raise ValueError(f"Multiple mapped output drivers for bit {bit}")
                            drivers[bit] = (name, pin)
        rng_bits, rng_cells = [], []
        for entry in rng_spec["nets"]:
            net, width = entry["name"], entry["width"]
            bits = module["netnames"][net]["bits"]
            if len(bits) != width or any(not isinstance(bit, int) for bit in bits):
                raise ValueError(f"Expected {width} live RNG state bits at {net}")
            for bit in bits:
                name, pin = drivers[bit]
                cell_type = cells[name]["type"]
                if not re.search(r"\bff\s*\(", bodies[cell_type]):
                    raise ValueError(f"RNG state bit is not driven by a Liberty FF output: {name}/{pin}")
                rng_bits.append(bit)
                rng_cells.append(name)
        expected = rng_spec["expected_registers"]
        if expected <= 0 or len(rng_bits) != expected or len(set(rng_bits)) != expected or len(set(rng_cells)) != expected:
            raise ValueError(f"Local RNG states must occupy {expected} distinct bits and FF cells")
        audit.update(local_rngs=len(rng_spec["nets"]), local_rng_registers=expected, local_rng_cells=rng_cells)
    return audit


def synth(plan):
    verify_plan_sources(plan)
    d = Path(plan["directory"])
    if (d / "synthesis.json").exists() or (d / "mapped_unbuffered.json").exists():
        raise FileExistsError(f"Synthesis output already exists in {d}; choose a new --work directory")
    tools = checked_tools(d)
    started = time.time()
    run_logged(yosys_command() + ["-s", d / "synth.ys"], d / "synthesis.log", cwd=d)
    design = json.loads((d / "mapped_unbuffered.json").read_text())
    if plan["config"]["mapping"]["clock_buffering"]:
        design, audit = repair_clock_design(design, library=plan["liberty"], icg=plan["config"]["icg"],
             buffer_config=plan["config"]["buffer"], module_name=plan["top"],
             max_fanout=plan["config"]["mapping"]["max_clock_fanout"], expected_gates=plan.get("expected_icg_count"))
        write_json(d / "clock_buffer_audit.json", audit)
    write_json(d / "mapped.json", design)
    run_logged(yosys_command() + ["-s", d / "emit_netlist.ys"], d / "emit_netlist.log")
    netlist_audit = audit_netlist(plan)
    run_logged(yosys_command() + ["-s", d / "cells_sim.ys"], d / "cells_sim.log")
    text = (d / "cells_sim.raw.v").read_text()
    cell = plan["config"]["icg"]["cell"]
    text = re.sub(r"(?ms)^module\s+\\?" + re.escape(cell) + r"\b.*?^endmodule\s*", "", text)
    if re.search(r"\bmodule\s+\\?" + re.escape(cell) + r"\b", text):
        raise ValueError("ICG remained in Liberty simulation models")
    (d / "cells_sim.v").write_text(text)
    receipt = dict(passed=True, stage="synthesis", started_unix=started, completed_unix=time.time(),
                   design_fingerprint=plan["design_fingerprint"], tools=tools, netlist_audit=netlist_audit,
                   scripts_sha256=plan["scripts_sha256"],
                   outputs_sha256={x: sha(d / x) for x in ("mapped.v", "mapped.json", "stat.json", "cells_sim.v", "clock_gate_sim.sv")})
    write_json(d / "synthesis.json", receipt)
    return receipt


def verify_plan_sources(plan):
    """Check live files too, so callers cannot reuse an old in-memory plan."""
    binding = plan["binding"]
    case = Path(plan["case"])
    expected = {case / name: digest for name, digest in binding["source_sha256"].items()}
    expected[case / "asic.json"] = binding["case_manifest_sha256"]
    expected[Path(plan["technology_config"])] = binding["technology_config_sha256"]
    expected[Path(plan["liberty"])] = binding["liberty_sha256"]
    technology_root = Path(plan["technology_config"]).parent
    expected[(technology_root / plan["config"]["license"]).resolve()] = binding["license_sha256"]
    expected[(technology_root / plan["config"]["mapping"]["abc_script"]).resolve()] = binding["abc_sha256"]
    for name, digest in binding["flow_sha256"].items():
        expected[Path(__file__).parent / name] = digest
    for path, digest in expected.items():
        if sha(path) != digest:
            raise ValueError(f"Prepared input changed: {path}; prepare a fresh run")
    d = Path(plan["directory"])
    for name, digest in plan["scripts_sha256"].items():
        if sha(d / name) != digest:
            raise ValueError(f"Prepared script changed: {name}")


def require_synthesis(plan):
    verify_plan_sources(plan)
    d = Path(plan["directory"])
    receipt = json.loads((d / "synthesis.json").read_text())
    if not receipt.get("passed") or receipt["design_fingerprint"] != plan["design_fingerprint"]:
        raise ValueError("Synthesis source/configuration binding is stale")
    if receipt["scripts_sha256"] != plan["scripts_sha256"]:
        raise ValueError("Synthesis script binding is stale")
    for name, digest in receipt["outputs_sha256"].items():
        if sha(d / name) != digest:
            raise ValueError(f"Synthesis output changed after validation: {name}")
    return receipt


def parse_timing(plan):
    d = Path(plan["directory"])
    slacks = {}
    for name in ("setup", "hold"):
        text = (d / (name + ".txt")).read_text()
        found = re.findall(r"([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)\s+slack \((?:MET|VIOLATED)\)", text)
        if not found:
            raise ValueError(f"No {name} slack found; refusing an empty timing pass")
        slacks[name + "_slack_ns"] = min(map(float, found)) * plan["units"]["ns_per_time_unit"]
    electrical = (d / "electrical.txt").read_text()
    checks = (d / "check_setup.txt").read_text()
    log = (d / "timing.log").read_text()
    issue = re.compile(r"VIOLATED|Warning|Error", re.I)
    passed = all(x >= 0 for x in slacks.values()) and not issue.search(electrical) and not issue.search(checks) and not re.search(r"(?im)^\s*(Warning|Error)", log)
    return dict(passed=bool(passed), **slacks, electrical_passed=not bool(issue.search(electrical)),
                check_setup_passed=not bool(issue.search(checks)))


def timing(plan):
    d = Path(plan["directory"])
    synthesis = require_synthesis(plan)
    if (d / "timing.json").exists():
        raise FileExistsError(f"Timing receipt already exists in {d}; choose a new --work directory")
    started = time.time()
    sta = discover_tool("sta")
    version = run_logged([sta, "-version"], d / "sta_version.txt").strip()
    run_logged([sta, "-exit", d / "timing.tcl"], d / "timing.log")
    status = parse_timing(plan)
    if not status["electrical_passed"] and plan["config"]["mapping"]["electrical_repair"]:
        for name in ("setup.txt", "hold.txt", "electrical.txt", "check_setup.txt", "timing.log", "mapped.json", "mapped.v"):
            shutil.copyfile(d / name, d / ("before_electrical_repair." + name))
        design, audit = repair_electrical_design(json.loads((d / "mapped.json").read_text()),
            (d / "electrical.txt").read_text(), library=plan["liberty"], buffer_config=plan["config"]["buffer"],
            module_name=plan["top"], output_load_lib_units=plan["config"]["io"]["output_load_pf"] / plan["units"]["pf_per_capacitance_unit"])
        write_json(d / "electrical_buffer_audit.json", audit)
        write_json(d / "mapped.json", design)
        run_logged(yosys_command() + ["-s", d / "emit_netlist.ys"], d / "emit_repaired_netlist.log")
        synthesis["netlist_audit"] = audit_netlist(plan)
        synthesis["electrical_repair_unix"] = time.time()
        synthesis["outputs_sha256"].update({x: sha(d / x) for x in ("mapped.v", "mapped.json", "stat.json")})
        write_json(d / "synthesis.json", synthesis)
        run_logged([sta, "-exit", d / "timing.tcl"], d / "timing.log")
        status = parse_timing(plan)
    receipt = dict(**status, stage="timing", started_unix=started, completed_unix=time.time(),
        design_fingerprint=plan["design_fingerprint"], synthesis_receipt_sha256=sha(d / "synthesis.json"),
        mapped_verilog_sha256=sha(d / "mapped.v"), constraints_sha256=sha(d / "constraints.sdc"),
        timing_script_sha256=sha(d / "timing.tcl"),
        liberty_sha256=sha(plan["liberty"]), opensta_version=version, opensta_executable=sta,
        report_sha256={name: sha(d / name) for name in ("setup.txt", "hold.txt", "electrical.txt", "check_setup.txt", "timing.log")},
        clock_period_ns=plan["config"]["clock"]["period_ns"], estimate_scope=plan["estimate_scope"])
    write_json(d / "timing.json", receipt)
    validation = dict(passed=receipt["passed"], stage="timing", completed_unix=receipt["completed_unix"],
        design_fingerprint=plan["design_fingerprint"], binding=plan["binding"],
        checks=dict(setup=status["setup_slack_ns"] >= 0, hold=status["hold_slack_ns"] >= 0,
                    max_capacitance=status["electrical_passed"], max_transition=status["electrical_passed"],
                    constraint_coverage=status["check_setup_passed"]),
        hashes={name: sha(d / name) for name in ("mapped.v", "mapped.json", "timing.tcl", "constraints.sdc", "synthesis.json", "timing.json")},
        liberty_path=plan["liberty"], liberty_sha256=sha(plan["liberty"]))
    write_json(d / "timing_validation.json", validation)
    if not receipt["passed"]:
        raise RuntimeError(f"Timing/electrical validation failed; power reporting is blocked. Inspect {d / 'timing.json'}")
    return receipt


def require_timing(plan):
    d = Path(plan["directory"])
    require_synthesis(plan)
    receipt = json.loads((d / "timing.json").read_text())
    if not receipt.get("passed") or receipt["design_fingerprint"] != plan["design_fingerprint"]:
        raise ValueError("Timing has not passed for the current design")
    for file, key in [(d / "synthesis.json", "synthesis_receipt_sha256"), (d / "mapped.v", "mapped_verilog_sha256"),
                      (d / "constraints.sdc", "constraints_sha256"), (d / "timing.tcl", "timing_script_sha256"),
                      (Path(plan["liberty"]), "liberty_sha256")]:
        if sha(file) != receipt[key]:
            raise ValueError(f"Timing binding changed: {file}")
    for name, digest in receipt["report_sha256"].items():
        if sha(d / name) != digest:
            raise ValueError(f"Timing report changed: {name}")
    return receipt


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("stage", choices=("prepare", "synth", "timing", "check-tools"))
    parser.add_argument("--case", default="cases/maxcut128", help="Package-relative case directory or absolute path")
    parser.add_argument("--tech", default="tech/sky130_hd/config_200ns.json")
    parser.add_argument("--mode", choices=("baseline", "epix"), default="baseline")
    parser.add_argument("--work", default="work", help="Package-relative output root or absolute path")
    args = parser.parse_args()
    plan = prepare(args.case, args.tech, args.mode, args.work)
    if args.stage == "prepare":
        result = {k: plan[k] for k in ("stage", "directory", "design_fingerprint", "estimate_scope")}
    elif args.stage == "check-tools":
        result = checked_tools(plan["directory"])
        result["opensta_executable"] = discover_tool("sta")
    else:
        result = {"synth": synth, "timing": timing}[args.stage](plan)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, FileNotFoundError, FileExistsError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        sys.exit(1)
