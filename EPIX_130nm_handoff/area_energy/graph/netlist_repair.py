"""Add clock and signal buffers to a mapped netlist.

Checks use cell pin loads.
OpenSTA must still check timing and electrical limits after each repair.
"""

from __future__ import annotations

import argparse
import collections
import copy
import hashlib
import json
import math
import pathlib
import re


def _body(text, opening):
    """Read a Liberty group while ignoring braces inside strings."""
    depth, quoted, escaped = 1, False, False
    for end in range(opening + 1, len(text)):
        char = text[end]
        if quoted:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = False
        elif char == '"':
            quoted = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if not depth:
                return text[opening + 1 : end]
    raise ValueError("Unbalanced Liberty braces")


def _outer(text):
    # Read pin attributes before nested timing and power groups.
    lines, depth = [], 0
    for line in text.splitlines():
        if depth == 0:
            lines.append(line)
        depth += line.count("{") - line.count("}")
    return "\n".join(lines)


class PinLibrary:
    def __init__(self, path):
        self.path = pathlib.Path(path)
        self.text = self.path.read_text()
        self.cache = {}

    def pin(self, cell_type, pin_name):
        if cell_type not in self.cache:
            pattern = r'\bcell\s*\(\s*"?' + re.escape(cell_type) + r'"?\s*\)\s*\{'
            match = re.search(pattern, self.text)
            if not match:
                raise ValueError(f"Missing Liberty cell {cell_type}")
            cell = _body(self.text, match.end() - 1)
            pins = {}
            for match in re.finditer(r'\bpin\s*\(\s*"?([^"\s)]+)"?\s*\)\s*\{', cell):
                attrs = _outer(_body(cell, match.end() - 1))
                values = {}
                for key in (
                    "capacitance",
                    "rise_capacitance",
                    "fall_capacitance",
                    "max_capacitance",
                    "max_transition",
                ):
                    found = re.search(r'\b' + key + r'\s*:\s*([0-9.eE+-]+)\s*;', attrs)
                    if found:
                        values[key] = float(found.group(1))
                pins[match.group(1)] = values
            self.cache[cell_type] = pins
        return self.cache[cell_type][pin_name]

    def cap(self, cell_type, pin_name):
        attrs = self.pin(cell_type, pin_name)
        values = [
            attrs[k]
            for k in ("capacitance", "rise_capacitance", "fall_capacitance")
            if k in attrs
        ]
        if not values:
            raise ValueError(
                f"Missing characterized input capacitance: {cell_type}/{pin_name}"
            )
        return max(values)


def _inputs(module):
    sinks = collections.defaultdict(list)
    for name, cell in module["cells"].items():
        for port, bits in cell["connections"].items():
            direction = cell["port_directions"][port]
            if direction in ("input", "inout"):
                for index, bit in enumerate(bits):
                    sinks[bit].append((name, port, index))
    return sinks


def repair_clock_design(
    design,
    *,
    library,
    icg,
    buffer_config,
    max_fanout=16,
    module_name="corrected_solver",
    expected_gates=None,
):
    """Return the buffered design and its connection and load checks."""
    gate_type, gate_out = icg["cell"], icg["output_pin"]
    buffer_type = buffer_config["cell"]
    buffer_in, buffer_out = buffer_config["input_pin"], buffer_config["output_pin"]
    if max_fanout < 2 or max_fanout > 16:
        raise ValueError("max_fanout must be between 2 and 16")
    design = copy.deepcopy(design)
    module = design["modules"][module_name]
    cells = module["cells"]
    gates = sorted(name for name, cell in cells.items() if cell["type"] == gate_type)
    if expected_gates is not None and len(gates) != expected_gates:
        raise ValueError(f"Expected {expected_gates} clock gates, found {len(gates)}")
    if not gates:
        raise ValueError("No clock gates found")
    if any(name.startswith("clock_buffer_") for name in cells):
        raise ValueError("Clock repair is already present; refusing a second transform")
    pinlib = PinLibrary(library)
    original_inputs = _inputs(module)
    original_cells = set(cells)
    numeric_bits = [
        bit
        for cell in cells.values()
        for bits in cell["connections"].values()
        for bit in bits
        if isinstance(bit, int)
    ]
    numeric_bits += [
        bit
        for net in module["netnames"].values()
        for bit in net["bits"]
        if isinstance(bit, int)
    ]
    numeric_bits += [
        bit
        for port in module["ports"].values()
        for bit in port["bits"]
        if isinstance(bit, int)
    ]
    next_bit = max(numeric_bits, default=1) + 1
    inserted, parents, gate_audits = [], {}, []

    def sink_cap(sink):
        name, port, _ = sink
        return pinlib.cap(cells[name]["type"], port)

    def buffer(source):
        nonlocal next_bit
        name = f"clock_buffer_{len(inserted):06d}"
        net_name = name + "_out"
        if name in cells or net_name in module["netnames"]:
            raise ValueError(f"Name collision: {name}")
        bit = next_bit
        next_bit += 1
        cells[name] = dict(
            hide_name=0,
            type=buffer_type,
            parameters={},
            attributes={},
            port_directions={buffer_in: "input", buffer_out: "output"},
            connections={buffer_in: [source], buffer_out: [bit]},
        )
        module["netnames"][net_name] = dict(hide_name=0, bits=[bit], attributes={})
        inserted.append(name)
        parents[bit] = source
        return bit

    def distribute(source, sinks):
        if len(sinks) <= max_fanout:
            for name, port, index in sinks:
                cells[name]["connections"][port][index] = source
            return
        groups = min(max_fanout, (len(sinks) + max_fanout - 1) // max_fanout)
        size, extra = divmod(len(sinks), groups)
        start = 0
        for group in range(groups):
            end = start + size + (group < extra)
            distribute(buffer(source), sinks[start:end])
            start = end

    original_wiring = {}
    for name in gates:
        outputs = cells[name]["connections"][gate_out]
        if len(outputs) != 1 or not isinstance(outputs[0], int):
            raise ValueError(f"Expected numeric single-bit GCLK on {name}")
        bit = outputs[0]
        if any(bit in port["bits"] for port in module["ports"].values()):
            raise ValueError(f"Gated clock {name} is also a top-level port")
        sinks = sorted(original_inputs.get(bit, []))
        if not sinks:
            raise ValueError(f"Clock gate {name} has no sinks")
        for sink in sinks:
            if sink in original_wiring:
                raise ValueError("Overlapping clock-gate sinks")
            original_wiring[sink] = bit
        original_cap = sum(sink_cap(sink) for sink in sinks)
        first = len(inserted)
        distribute(bit, sinks)
        depths = []
        for sink in sinks:
            cell, port, index = sink
            actual, depth = cells[cell]["connections"][port][index], 0
            while actual in parents:
                actual, depth = parents[actual], depth + 1
            assert actual == bit, f"Clock root changed for {sink}"
            depths.append(depth)
        assert max(depths) - min(depths) <= 1, "Unbalanced buffer tree"
        gate_audits.append(
            dict(
                gate=name,
                original_fanout=len(sinks),
                original_pin_load_lib_units=original_cap,
                inserted_buffers=len(inserted) - first,
                min_buffer_depth=min(depths),
                max_buffer_depth=max(depths),
            )
        )

    # All inputs outside the repaired clock trees must stay unchanged.
    for bit, sinks in original_inputs.items():
        for sink in sinks:
            name, port, index = sink
            if sink not in original_wiring:
                assert cells[name]["connections"][port][index] == bit
    assert original_cells.issubset(cells)
    final_inputs = _inputs(module)
    load_audits = []
    for name in gates + inserted:
        cell = cells[name]
        port = gate_out if cell["type"] == gate_type else buffer_out
        bit = cell["connections"][port][0]
        sinks = final_inputs.get(bit, [])
        cap = sum(sink_cap(sink) for sink in sinks)
        limit = pinlib.pin(cell["type"], port)["max_capacitance"]
        assert len(sinks) <= max_fanout, (name, len(sinks))
        assert cap <= limit, (name, cap, limit)
        load_audits.append(
            dict(
                instance=name,
                fanout=len(sinks),
                pin_load_lib_units=cap,
                max_capacitance_lib_units=limit,
            )
        )
    final_outputs = collections.Counter(
        bit
        for cell in cells.values()
        for port, bits in cell["connections"].items()
        if cell["port_directions"][port] == "output"
        for bit in bits
        if isinstance(bit, int)
    )
    for bit in parents:
        assert final_outputs[bit] == 1
    audit = dict(
        passed=True,
        module=module_name,
        clock_gates=len(gates),
        max_fanout=max_fanout,
        buffer_type=buffer_type,
        inserted_buffers=len(inserted),
        original_clock_sink_pins=len(original_wiring),
        original_max_fanout=max(row["original_fanout"] for row in gate_audits),
        original_max_pin_load_lib_units=max(
            row["original_pin_load_lib_units"] for row in gate_audits
        ),
        repaired_max_fanout=max(row["fanout"] for row in load_audits),
        repaired_max_pin_load_lib_units=max(
            row["pin_load_lib_units"] for row in load_audits
        ),
        repaired_max_capacitance_ratio=max(
            row["pin_load_lib_units"] / row["max_capacitance_lib_units"]
            for row in load_audits
        ),
        library_sha256=hashlib.sha256(pathlib.Path(library).read_bytes()).hexdigest(),
        load_basis="Worst of nominal, rise, and fall cell-pin capacitance; excludes wires",
        original_sink_roots_preserved=True,
        unaffected_input_connections_preserved=True,
        gates=gate_audits,
        repaired_driver_loads=load_audits,
    )
    return design, audit


def violation_pins(report):
    number = r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?"
    pattern = rf"^\s*(\S+)\s+({number})\s+({number})\s+({number})\s+\(VIOLATED\)"
    matches = list(re.finditer(pattern, report, re.MULTILINE))
    if len(matches) != report.count("(VIOLATED)"):
        raise ValueError(
            "Unrecognized electrical violation row; refusing partial parsing"
        )
    if re.search(r"Warning|Error", report, re.IGNORECASE):
        raise ValueError("Electrical report contains a warning or error")
    return [match.group(1) for match in matches]


def repair_electrical_design(
    design,
    electrical_report,
    *,
    library,
    buffer_config,
    module_name="corrected_solver",
    output_load_lib_units=0.01,
):
    """Add buffer trees and check that their loads stay within limits."""
    buffer_type = buffer_config["cell"]
    buffer_in, buffer_out = buffer_config["input_pin"], buffer_config["output_pin"]
    if not math.isfinite(output_load_lib_units) or output_load_lib_units < 0:
        raise ValueError("Output load must be finite and nonnegative")
    design = copy.deepcopy(design)
    module = design["modules"][module_name]
    cells, ports, nets = module["cells"], module["ports"], module["netnames"]
    existing_buffer_count = sum(name.startswith("electrical_buffer_") for name in cells)
    pinlib = PinLibrary(library)
    buffer_input_cap = pinlib.cap(buffer_type, buffer_in)
    # SRAM inputs have stricter slew limits.
    # Limit branch loads, then require OpenSTA to pass.
    buffer_limit = min(0.10, pinlib.pin(buffer_type, buffer_out)["max_capacitance"])
    sinks = _inputs(module)
    drivers = {}
    all_bits = []
    for name, cell in cells.items():
        for pin, bits in cell["connections"].items():
            all_bits.extend(bit for bit in bits if isinstance(bit, int))
            if cell["port_directions"][pin] == "output":
                for index, bit in enumerate(bits):
                    drivers.setdefault(bit, []).append((name, pin, index))
    for obj in list(ports.values()) + list(nets.values()):
        all_bits.extend(bit for bit in obj["bits"] if isinstance(bit, int))
    next_bit = max(all_bits, default=1) + 1
    reported = violation_pins(electrical_report)
    selected = {}

    def report_bit(label):
        if "/" in label:
            name, pin = label.rsplit("/", 1)
            bus = re.fullmatch(r'(.+)\[(\d+)\]', pin)
            if name in cells and bus and bus[1] in cells[name]['connections']:
                return cells[name]['connections'][bus[1]][int(bus[2])]
            if name not in cells or pin not in cells[name]["connections"]:
                raise ValueError(f"Unknown reported cell pin {label}")
            bits = cells[name]["connections"][pin]
            if len(bits) != 1:
                raise ValueError(f"Expected scalar mapped cell pin {label}")
            return bits[0]
        if label in ports and len(ports[label]["bits"]) == 1:
            return ports[label]["bits"][0]
        match = re.fullmatch(r"(.+)\[(\d+)\]", label)
        if match and match.group(1) in ports:
            port = ports[match.group(1)]
            index = int(match.group(2)) - port.get("offset", 0)
            if not 0 <= index < len(port["bits"]):
                raise ValueError(f"Port bit index outside declaration: {label}")
            return port["bits"][index]
        raise ValueError(f"Unknown reported pin {label}")

    for label in reported:
        bit = report_bit(label)
        found = drivers.get(bit, [])
        if len(found) != 1:
            raise ValueError(
                f"Reported pin {label} has {len(found)} cell output drivers"
            )
        selected.setdefault(found[0], dict(bit=bit, reported_pins=[]))[
            "reported_pins"
        ].append(label)

    output_sinks = {}
    for name, port in ports.items():
        for index, bit in enumerate(port["bits"]):
            if port["direction"] == "output":
                output_sinks.setdefault(bit, []).append((name, index))
            elif bit in [item["bit"] for item in selected.values()]:
                raise ValueError(
                    f"Selected output net also drives an input/inout port: {name}"
                )
    replacements, audit_rows, inserted = {}, [], []
    before_connections = {
        name: copy.deepcopy(cell["connections"]) for name, cell in cells.items()
    }
    before_ports = {name: list(port["bits"]) for name, port in ports.items()}
    original_sink_keys = set()

    def fits(load, limit):
        return load <= limit * (1 + 1e-12) + 1e-15

    if not all(math.isfinite(x) and x > 0 for x in (buffer_input_cap, buffer_limit)):
        raise ValueError(
            "Buffer input and maximum output capacitances must be positive and finite"
        )
    max_branches = int(math.floor(buffer_limit / buffer_input_cap))
    while max_branches and not fits(max_branches * buffer_input_cap, buffer_limit):
        max_branches -= 1

    def buffer(source):
        nonlocal next_bit
        name = f"electrical_buffer_{existing_buffer_count+len(inserted):06d}"
        net_name = name + "_out"
        if name in cells or net_name in nets:
            raise ValueError(f"Name collision: {name}")
        bit = next_bit
        next_bit += 1
        replacements[bit] = source
        cells[name] = dict(
            hide_name=0,
            type=buffer_type,
            parameters={},
            attributes={},
            port_directions={buffer_in: "input", buffer_out: "output"},
            connections={buffer_in: [source], buffer_out: [bit]},
        )
        nets[net_name] = dict(hide_name=0, bits=[bit], attributes={})
        inserted.append(name)
        return name, bit

    def connect(source, sink):
        kind, name, pin, index, _ = sink
        if kind == "cell":
            cells[name]["connections"][pin][index] = source
            original_sink_keys.add((name, pin, index))
        else:
            ports[name]["bits"][index] = source
            # Keep output port declarations and their nets consistent.
            if name not in nets:
                nets[name] = dict(
                    hide_name=0, bits=list(ports[name]["bits"]), attributes={}
                )
            else:
                nets[name]["bits"][index] = source

    def distribute(source, pending):
        load = sum(sink[4] for sink in pending)
        if fits(load, buffer_limit):
            for sink in pending:
                connect(source, sink)
            return
        if max_branches < 2:
            raise ValueError(
                f"{buffer_type} cannot drive two buffer inputs; a load-reducing tree is impossible"
            )
        # Balance branches by pin capacitance.
        # Each output drives at most max_branches buffer inputs.
        groups = min(max_branches, len(pending), max(2, math.ceil(load / buffer_limit)))
        if groups < 2:
            raise ValueError(
                f"One {buffer_type} cannot drive an indivisible sink load of {load}"
            )
        partitions = [[] for _ in range(groups)]
        loads = [0.0] * groups
        for sink in sorted(pending, key=lambda item: (-item[4], item[:4])):
            index = min(range(groups), key=lambda k: (loads[k], len(partitions[k]), k))
            partitions[index].append(sink)
            loads[index] += sink[4]
        for partition in partitions:
            if partition:
                _, child = buffer(source)
                distribute(child, partition)

    def original_root(bit):
        visited = set()
        while bit in replacements:
            if bit in visited:
                raise AssertionError("Cycle in noninverting repair tree")
            visited.add(bit)
            bit = replacements[bit]
        return bit

    for driver, entry in sorted(selected.items()):
        name, pin, index = driver
        bit = entry["bit"]
        if not isinstance(bit, int):
            raise ValueError("Cannot buffer a constant net")
        if len(cells[name]["connections"][pin]) != 1:
            raise ValueError(f"Expected a scalar mapped driver output: {name}/{pin}")
        source_limit = pinlib.pin(cells[name]["type"], pin)["max_capacitance"]
        if not math.isfinite(source_limit) or source_limit <= 0:
            raise ValueError(
                f"Missing positive source maximum capacitance: {name}/{pin}"
            )
        cell_sinks, external_sinks = sinks.get(bit, []), output_sinks.get(bit, [])
        pending = []
        for cn, cp, ci in cell_sinks:
            if cells[cn]["port_directions"][cp] != "input":
                raise ValueError("Cannot rewrite an inout cell pin")
            pending.append(("cell", cn, cp, ci, pinlib.cap(cells[cn]["type"], cp)))
        pending.extend(
            ("port", pn, "", pi, output_load_lib_units) for pn, pi in external_sinks
        )
        if not pending:
            raise ValueError(f"Reported driver {name}/{pin} has no characterized sinks")
        for sink in pending:
            if not math.isfinite(sink[4]) or sink[4] < 0:
                raise ValueError(f"Invalid characterized sink capacitance: {sink[:4]}")
            if not fits(sink[4], buffer_limit):
                raise ValueError(
                    f"One {buffer_type} cannot drive indivisible sink {sink[:4]} of {sink[4]} library capacitance units"
                )
        original_load = sum(sink[4] for sink in pending)
        if not fits(buffer_input_cap, source_limit):
            raise ValueError(f"Source {name}/{pin} cannot drive one {buffer_type}")
        first = len(inserted)
        root_name, root_bit = buffer(bit)
        distribute(root_bit, pending)
        depths = []
        for kind, sn, sp, si, _ in pending:
            actual = (
                cells[sn]["connections"][sp][si]
                if kind == "cell"
                else ports[sn]["bits"][si]
            )
            depth = 0
            while actual in replacements:
                actual = replacements[actual]
                depth += 1
            assert actual == bit, f"Electrical root changed for {sn}/{sp}"
            depths.append(depth)
        audit_rows.append(
            dict(
                driver=f"{name}/{pin}",
                driver_cell_type=cells[name]["type"],
                reported_pins=sorted(set(entry["reported_pins"])),
                buffer=root_name,
                inserted_buffers=len(inserted) - first,
                min_buffer_depth=min(depths),
                max_buffer_depth=max(depths),
                original_fanout=len(cell_sinks),
                original_output_port_bits=len(external_sinks),
                original_load_lib_units=original_load,
                source_repaired_load_lib_units=buffer_input_cap,
                source_max_capacitance_lib_units=source_limit,
                buffer_max_capacitance_lib_units=buffer_limit,
            )
        )

    for name, connections in before_connections.items():
        for pin, bits in connections.items():
            for index, bit in enumerate(bits):
                current = cells[name]["connections"][pin][index]
                if (name, pin, index) in original_sink_keys:
                    assert original_root(current) == bit
                else:
                    assert current == bit, (name, pin, index)
    for name, bits in before_ports.items():
        for index, bit in enumerate(bits):
            current = ports[name]["bits"][index]
            assert current == bit or original_root(current) == bit
    final_sinks = _inputs(module)
    final_outputs = collections.Counter(
        bit
        for port in ports.values()
        if port["direction"] == "output"
        for bit in port["bits"]
    )
    load_rows = []
    audited = [(name, pin) for name, pin, _ in sorted(selected)] + [
        (name, buffer_out) for name in inserted
    ]
    for name, pin in audited:
        bit = cells[name]["connections"][pin][0]
        loads = final_sinks.get(bit, [])
        cap = sum(pinlib.cap(cells[cn]["type"], cp) for cn, cp, _ in loads)
        cap += output_load_lib_units * final_outputs[bit]
        limit = pinlib.pin(cells[name]["type"], pin)["max_capacitance"]
        assert fits(cap, limit), (name, pin, cap, limit)
        load_rows.append(
            dict(
                instance=name,
                output_pin=pin,
                fanout=len(loads),
                output_port_bits=final_outputs[bit],
                load_lib_units=cap,
                max_capacitance_lib_units=limit,
            )
        )
    for row in audit_rows:
        cell = cells[row["buffer"]]
        source = cell["connections"][buffer_in][0]
        assert final_sinks[source] == [(row["buffer"], buffer_in, 0)]
        assert final_outputs[source] == 0
    output_drivers = collections.Counter(
        bit
        for cell in cells.values()
        for pin, bits in cell["connections"].items()
        if cell["port_directions"][pin] == "output"
        for bit in bits
        if isinstance(bit, int)
    )
    assert all(
        output_drivers[bit] == 1 for bit in replacements
    ), "Repair output has multiple drivers"
    return design, dict(
        passed=True,
        reported_violation_rows=len(reported),
        inserted_buffers=len(inserted),
        buffer_type=buffer_type,
        original_input_and_output_truth_preserved=True,
        unaffected_connections_preserved=True,
        output_load_lib_units_per_bit=output_load_lib_units,
        max_buffer_branches=max_branches,
        repaired_max_capacitance_ratio=max(
            (
                row["load_lib_units"] / row["max_capacitance_lib_units"]
                for row in load_rows
            ),
            default=0,
        ),
        load_basis="Worst characterized cell-pin capacitance plus declared output loads; excludes wires",
        library_sha256=hashlib.sha256(pathlib.Path(library).read_bytes()).hexdigest(),
        repairs=audit_rows,
        repaired_driver_loads=load_rows,
    )
