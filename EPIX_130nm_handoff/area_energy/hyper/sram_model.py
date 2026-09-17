#!/usr/bin/env python3
"""Sum SRAM internal energy from clock edges and control values.

Use Liberty energy per edge for each enable and write state.
Keep output switching and leakage in the OpenSTA totals.
Replace only the SRAM internal term to avoid counting it twice.
"""
import argparse
import bisect
import hashlib
import json
import math
from pathlib import Path
import re

LIBRARY_SHA256 = '7039a903d793fd2b91ddbadfcfdec372f57eea41308fa3c3e3f07bc30a0f0d1b'
CELL = 'sram22_128x40m4w20'
SCENARIOS = {
    'full_published_model': ('vdd', 'vss'),
    'supply_only_sensitivity': ('vdd',),
}
EDGE_KEYS = tuple(
    f'{edge}_ce{ce}_we{we}'
    for edge in ('rise', 'fall')
    for ce in (0, 1)
    for we in (0, 1)
)
COUNT_KEYS = EDGE_KEYS + (
    'accepted_reads',
    'accepted_writes',
    'writes_with_nonzero_mask',
    'sampled_rstb_low',
)
WINDOWS = ('setup_only', 'search', 'with_setup')


def require(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def groups(text, kind):
    found = []
    for match in re.finditer(r'\b' + re.escape(kind) + r'\s*\(([^)]*)\)\s*\{', text):
        pos, depth, quote, escape = match.end(), 1, False, False
        while depth:
            require(pos < len(text), 'Unterminated Liberty group')
            char = text[pos]
            if char == '"' and not escape:
                quote = not quote
            if not quote:
                depth += (char == '{') - (char == '}')
            escape = char == '\\' and not escape
            pos += 1
        found.append((match.group(1).strip().strip('"'), text[match.end() : pos - 1]))
    return found


def attr(text, name):
    match = re.search(r'\b' + re.escape(name) + r'\s*:\s*"?([^;"\n]+)"?\s*;', text)
    require(match is not None, 'Missing Liberty attribute ' + name)
    return match.group(1).strip()


def vector(text, name):
    match = re.search(
        r'\b' + re.escape(name) + r'\s*\(\s*\\?\s*"([^"]+)"\s*\\?\s*\)', text
    )
    require(match is not None, 'Missing one-dimensional Liberty ' + name)
    values = [float(x.strip()) for x in match.group(1).split(',')]
    require(all(math.isfinite(x) for x in values), 'Nonfinite Liberty vector')
    return values


def interpolate(axis, values, slew_ns):
    """Interpolate within the table; reject slews outside its range."""
    require(len(axis) == len(values) and len(axis) >= 2, 'Invalid interpolation table')
    require(all(math.isfinite(x) for x in axis + values), 'Nonfinite table')
    require(all(a < b for a, b in zip(axis, axis[1:])), 'Unordered table axis')
    require(
        math.isfinite(slew_ns) and axis[0] <= slew_ns <= axis[-1],
        f'Clock slew {slew_ns} ns is outside characterized [{axis[0]}, {axis[-1]}] ns',
    )
    index = min(max(bisect.bisect_right(axis, slew_ns) - 1, 0), len(axis) - 2)
    fraction = (slew_ns - axis[index]) / (axis[index + 1] - axis[index])
    return values[index] + fraction * (values[index + 1] - values[index])


class Model:
    """Load SRAM edge-energy tables and check their units."""

    def __init__(self, path):
        self.library_sha256 = sha(path)
        require(
            self.library_sha256 == LIBRARY_SHA256, 'Official SRAM Liberty hash mismatch'
        )
        text = Path(path).read_text()
        require(
            attr(text, 'time_unit') == '1ns' and attr(text, 'voltage_unit') == '1V',
            'Unexpected time/voltage units',
        )
        require(
            re.search(r'capacitive_load_unit\s*\(\s*1\s*,\s*pf\s*\)', text),
            'Unexpected capacitance unit',
        )
        self.energy_unit_j = 1e-12  # Liberty energy unit: (1 V)^2 * 1 pF.
        cells = groups(text, 'cell')
        require(
            len(cells) == 1 and cells[0][0] == CELL, 'Unexpected SRAM cell inventory'
        )
        clocks = [body for name, body in groups(cells[0][1], 'pin') if name == 'clk']
        require(
            len(clocks) == 1 and attr(clocks[0], 'direction') == 'input',
            'Missing SRAM clock pin',
        )
        self.maximum_clock_slew_ns = float(attr(clocks[0], 'max_transition'))
        all_groups, clock_groups = groups(text, 'internal_power'), groups(
            clocks[0], 'internal_power'
        )
        require(
            len(all_groups) == len(clock_groups) == 8,
            'Unexpected non-clock internal energy model',
        )
        templates = dict(groups(text, 'power_lut_template'))
        self.tables = {}
        condition_values = {
            ('we' if we else '!we') + ('&ce' if ce else '&!ce'): (ce, we)
            for ce in (0, 1)
            for we in (0, 1)
        }
        for _, group in clock_groups:
            condition, rail = attr(group, 'when'), attr(group, 'related_pg_pin')
            require(
                condition in condition_values and rail in ('vdd', 'vss'),
                'Unknown power condition/rail',
            )
            ce, we = condition_values[condition]
            for edge in ('rise', 'fall'):
                tables = groups(group, edge + '_power')
                require(len(tables) == 1, 'Missing or duplicate edge energy table')
                template_name, table = tables[0]
                require(template_name in templates, 'Unknown table template')
                template = templates[template_name]
                require(
                    attr(template, 'variable_1') == 'input_transition_time'
                    and not re.search(r'\bvariable_2\b', template),
                    'Unexpected energy table dimensions',
                )
                axis, values = vector(table, 'index_1'), vector(table, 'values')
                require(
                    len(axis) == len(values) == 7 and all(v >= 0 for v in values),
                    'Invalid energy table',
                )
                require(
                    axis == vector(template, 'index_1'),
                    'Overridden energy axis needs review',
                )
                key = (edge, ce, we, rail)
                require(key not in self.tables, 'Duplicate edge/condition/rail table')
                self.tables[key] = (axis, values)
        require(len(self.tables) == 16, 'Incomplete internal energy table coverage')

    def coefficient_j(self, edge, ce, we, rail, slew_ns):
        require((edge, ce, we, rail) in self.tables, 'Unsupported edge/condition/rail')
        require(
            slew_ns <= self.maximum_clock_slew_ns,
            'SRAM clock transition limit exceeded',
        )
        return (
            interpolate(*self.tables[edge, ce, we, rail], slew_ns) * self.energy_unit_j
        )


def count_energy(model, counts, rise_ns, fall_ns):
    """Sum edge count times energy per edge, including disabled edges."""
    require(all(key in counts for key in EDGE_KEYS), 'Missing joint edge condition')
    require(
        all(type(counts[key]) is int and counts[key] >= 0 for key in EDGE_KEYS),
        'Invalid edge count',
    )
    rows = {}
    for edge in ('rise', 'fall'):
        slew = rise_ns if edge == 'rise' else fall_ns
        for ce in (0, 1):
            for we in (0, 1):
                key = f'{edge}_ce{ce}_we{we}'
                coefficients = {
                    rail: model.coefficient_j(edge, ce, we, rail, slew)
                    for rail in ('vdd', 'vss')
                }
                rows[key] = {
                    'count': counts[key],
                    'slew_ns': slew,
                    'coefficient_j_by_rail': coefficients,
                }
    totals = {
        scenario: math.fsum(
            row['count']
            * math.fsum(row['coefficient_j_by_rail'][rail] for rail in rails)
            for row in rows.values()
        )
        for scenario, rails in SCENARIOS.items()
    }
    return {'internal_j': totals, 'conditions': rows}
