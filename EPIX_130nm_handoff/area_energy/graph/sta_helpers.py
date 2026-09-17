#!/usr/bin/env python3
"""Read Liberty data and OpenSTA power reports for energy calculation."""
from __future__ import annotations
import os
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import re
import subprocess
import time
import readback

HERE = Path(__file__).resolve().parent
TOP = 'production_solver'
MACRO = 'sram22_128x40m4w20'
MACRO_COUNT = 3
MACRO_WIDTH = 40
MASK_BITS = 2
FROZEN_SHA = 'e289fc21ae8b8b5ebe1485ee04ef125e5366f4d180d53284b7a42108245c5248'
GATE = 'sky130_fd_sc_hd__dlclkp_1'
BUFFER = 'sky130_fd_sc_hd__buf_16'
WINDOWS = ('setup_only', 'search', 'with_setup')
STD_SHA = 'ec0e1067a35c8bf20b11e58d1e8ac53326067e4dac84a125cc1b917a3518d0d9'
SRAM_SHA = '7039a903d793fd2b91ddbadfcfdec372f57eea41308fa3c3e3f07bc30a0f0d1b'
COMPONENTS = ('internal_w', 'switching_w', 'leakage_w', 'total_w')
STA_SHA = 'e9bfc5ad86dd4e5017e1358bb17ec483379985f3c2acbaea794299a37b1c7129'
STA_DEFAULT = os.environ.get('OPENSTA', 'sta')
NUMBER = r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def write(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def quote(value):
    value = str(value)
    require(not any(c in value for c in '{}\n\r\\'), 'Unsafe Tcl word')
    return '{' + value + '}'


def groups(text, kind):
    result = []
    for match in re.finditer(r'\b' + kind + r'\s*\(([^)]*)\)\s*\{', text):
        i, depth, quoted, escape = match.end(), 1, False, False
        while depth:
            require(i < len(text), 'Unbalanced Liberty')
            c = text[i]
            if c == '"' and not escape:
                quoted = not quoted
            if not quoted:
                depth += (c == '{') - (c == '}')
            escape = c == '\\' and not escape
            i += 1
        result.append((match.group(1).strip().strip('"'), text[match.end() : i - 1]))
    return result


def scalar(text, key, default=None):
    m = re.search(r'\b' + key + r'\s*:\s*(' + NUMBER + r')\s*;', text)
    if m is None:
        require(default is not None, 'Missing Liberty ' + key)
        return default
    x = float(m[1])
    require(math.isfinite(x), 'Nonfinite Liberty ' + key)
    return x


class Libraries:
    """Read the supplied 1.8 V libraries using ns and pF; pin loads omit wires."""

    def __init__(self, stdlib, sramlib):
        self.paths = [Path(stdlib).resolve(), Path(sramlib).resolve()]
        require(
            [sha(p) for p in self.paths] == [STD_SHA, SRAM_SHA], 'Library hash mismatch'
        )
        self.cells, self.cache = {}, {}
        for p in self.paths:
            text = p.read_text()
            require(re.search(r'time_unit\s*:\s*"1ns"', text), 'Time units must be ns')
            require(
                re.search(
                    r'capacitive_load_unit\s*\(\s*1(?:\.0+)?\s*,\s*"?pf"?\s*\)', text
                ),
                'Capacitance units must be pF',
            )
            require(
                math.isclose(scalar(text, 'nom_voltage'), 1.8),
                'Corner voltage mismatch',
            )
            self.cells.update(groups(text, 'cell'))

    def pin(self, cell, pin):
        key = (cell, pin)
        if key not in self.cache:
            require(cell in self.cells, 'Unknown Liberty cell ' + cell)
            pins = dict(groups(self.cells[cell], 'pin'))
            require(pin in pins, 'Unknown Liberty pin ' + cell + '/' + pin)
            body = pins[pin]
            # Pin capacitance appears before nested groups.
            self.cache[key] = {
                name: scalar(body, name, -1)
                for name in (
                    'capacitance',
                    'rise_capacitance',
                    'fall_capacitance',
                    'max_capacitance',
                    'max_transition',
                )
            }
        return self.cache[key]

    def capacitances(self, cell, pin):
        values = self.pin(cell, pin)
        base = values['capacitance']
        rise = values['rise_capacitance'] if values['rise_capacitance'] >= 0 else base
        fall = values['fall_capacitance'] if values['fall_capacitance'] >= 0 else base
        require(min(rise, fall) >= 0, 'Missing pin capacitance')
        return rise, fall


def root_clock_load(module, libs):
    """Sum pin capacitance driven directly by the root clock."""
    root = module['ports']['clk']
    require(
        root['direction'] == 'input'
        and len(root['bits']) == 1
        and type(root['bits'][0]) is int,
        'Invalid root clock boundary',
    )
    bit, sinks = root['bits'][0], []
    for name, cell in module['cells'].items():
        for port, bits in cell['connections'].items():
            if bit in bits:
                require(
                    cell['port_directions'][port] == 'input',
                    'Root clock has internal driver/inout',
                )
                require(len(bits) == 1, 'Unexpected bus at root clock')
                rise, fall = libs.capacitances(cell['type'], port)
                sinks.append(
                    dict(
                        instance=name,
                        pin=port,
                        cell=cell['type'],
                        rise_pf=rise,
                        fall_pf=fall,
                    )
                )
    require(sinks, 'Root clock has no load')
    rise = math.fsum(x['rise_pf'] for x in sinks)
    fall = math.fsum(x['fall_pf'] for x in sinks)
    return dict(
        sinks=sinks,
        rise_load_pf=rise,
        fall_load_pf=fall,
        modeled_load_pf=max(rise, fall),
        voltage_v=1.8,
        convention='max(sum rise C, sum fall C), matching OpenSTA switching load selection',
        wire_capacitance_pf=0,
        external_driver_internal_included=False,
    )


def root_clock_energy(load, counts):
    """Calculate energy used to charge the root clock pin loads."""
    duration = counts['duration_ps']
    edges = counts['clock_edges']
    require(
        type(duration) is int and duration > 0 and type(edges) is int and edges > 0,
        'Empty or noninteger root clock window',
    )
    require(
        duration % 100000 == 0 and edges == 2 * (duration // 100000),
        'Root clock count/period mismatch',
    )
    require(counts['root_clock_high_ps'] * 2 == duration, 'Root clock duty mismatch')
    joules = 0.5 * load['modeled_load_pf'] * 1e-12 * 1.8**2 * edges
    return dict(
        energy_j=joules,
        average_w=joules / (duration * 1e-12),
        transitions=edges,
        load_pf=load['modeled_load_pf'],
        included_in_core_report=False,
        scope='External source charges characterized root input pin loads; driver internal, wire, PLL and pad costs excluded',
    )


def bound_receipt(path, expected_sha):
    require(
        isinstance(expected_sha, str) and re.fullmatch('[0-9a-f]{64}', expected_sha),
        'An explicit expected receipt SHA256 is required',
    )
    require(sha(path) == expected_sha, 'Receipt hash mismatch: ' + str(path))
    return read(path)


def timing_preamble(stdlib, sramlib, netlist, top=TOP):
    return (
        '\n'.join(
            [
                f'read_liberty {quote(stdlib)}',
                f'read_liberty {quote(sramlib)}',
                f'read_verilog {quote(netlist)}',
                f'link_design {top}',
                'create_clock -name clk -period 100 [get_ports clk]',
                'set_clock_transition 0.1 [get_clocks clk]',
                'set_input_transition 0.1 [all_inputs]',
                'set_input_delay 0 -clock clk [all_inputs -no_clocks]',
                'set_output_delay 0 -clock clk [all_outputs]',
                'set_load 0.01 [all_outputs]',
                'set_propagated_clock [all_clocks]',
                'if {[get_property [get_clocks clk] period] != 100} {error "Unexpected time units/clock period"}',
            ]
        )
        + '\n'
    )


def component(values):
    d = dict(zip(COMPONENTS, values))
    require(
        all(math.isfinite(x) and x >= 0 for x in d.values()),
        'Negative/nonfinite reported power',
    )
    require(
        math.isclose(sum(values[:3]), values[3], rel_tol=3e-6, abs_tol=1e-14),
        'Power components do not sum',
    )
    return d


def parse_power(text, expected_instances=None):
    """Read internal, switching, and leakage power in watts."""
    require(
        'Watts' in text and not re.search(r'\b(?:Error|Warning)\b', text),
        'Power report units/error',
    )
    if expected_instances is None:
        match = re.findall(
            r'^Total\s+('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')(?:\s|$)',
            text,
            re.M,
        )
        require(len(match) == 1, 'Missing/duplicate Total row')
        return component(list(map(float, match[0])))
    rows = {}
    for line in text.splitlines():
        m = re.fullmatch(
            r'\s*('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')\s+('
            + NUMBER
            + r')\s+(\S+)\s*',
            line,
        )
        if m:
            require(m[5] not in rows, 'Duplicate power instance')
            rows[m[5]] = component(list(map(float, m.groups()[:4])))
    require(set(rows) == set(expected_instances), 'Power instance coverage mismatch')
    return dict(
        instances=rows,
        subtotal={key: math.fsum(v[key] for v in rows.values()) for key in COMPONENTS},
    )


def parse_slews(path, macros, mapped_sha, hashes):
    lines = Path(path).read_text().splitlines()
    require(
        lines and lines[0] == 'instance\trise_ns\tfall_ns', 'Slew units/header mismatch'
    )
    instances = {}
    for line in lines[1:]:
        n, r, f = line.split('\t')
        require(n not in instances, 'Duplicate macro slew')
        r, f = float(r), float(f)
        require(
            all(math.isfinite(x) and 0.002 <= x <= 0.351 for x in (r, f)),
            'Uncharacterized macro slew',
        )
        instances[n] = dict(rise_ns=r, fall_ns=f)
    require(set(instances) == set(macros), 'Macro slew inventory mismatch')
    return dict(
        passed=True,
        source='OpenSTA propagated clock pin slew',
        propagated_clock=True,
        mapped_json_sha256=mapped_sha,
        units='ns',
        instances=instances,
        input_hashes=hashes,
        selection='maximum analysis point, separate rise and fall; one TT library corner',
        extracted_wire_parasitics=False,
    )


def snapshot(paths):
    return {str(Path(p).resolve()): sha(p) for p in paths}


def check_snapshot(hashes):
    for path, value in hashes.items():
        require(sha(path) == value, 'Bound input changed: ' + path)
