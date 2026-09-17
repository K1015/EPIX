"""Check that OpenSTA keeps every pin activity value after reporting power."""

import math
from pathlib import Path


def instrument(script, helper, expected_counts, *, idle=False):
    """Add activity checks after each OpenSTA power report."""
    lines = ['source {' + str(helper) + '}']
    window = 'idle' if idle else None
    if idle:
        count = expected_counts.get('idle')
        if type(count) is not int or count <= 0:
            raise ValueError('Idle coverage must be derived from modeled pin topology')
        lines.append(f'epix_readback_reset idle {count}')
    for line in script.splitlines():
        lines.append(line)
        if line == 'sta::clear_power':
            # The next source command selects the time window.
            window = None
        if line.startswith('source ') and '.activity.tcl' in line:
            window = Path(line[8:-1]).name.removesuffix('.activity.tcl')
            lines.insert(
                len(lines) - 1,
                f'epix_readback_reset {window} {expected_counts[window]}',
            )
        if line.startswith('report_power '):
            if not window:
                raise ValueError('Power report without a known activity window')
            report = Path(line.split(' > {', 1)[1][:-1]).name
            phase = report.removeprefix(window + '.').removesuffix('.txt')
            lines.append('epix_readback_check ' + phase)
    return '\n'.join(lines) + '\n'


def validate(log, expected, phase_map):
    """Require every measured pin and input port to keep its activity."""
    rows = {}
    for line in log.splitlines():
        if line.startswith('ACTIVITY_READBACK_ERROR'):
            raise ValueError('Post-power activity mismatch: ' + line)
        if not line.startswith('ACTIVITY_READBACK\t'):
            continue
        fields = line.split('\t')
        if len(fields) != 12:
            raise ValueError('Malformed activity readback summary')
        _, window, phase, *values = fields
        key = (window, phase)
        if key in rows:
            raise ValueError('Duplicate activity readback summary')
        checked, inputs, pins, users, constants, errors = map(int, values[:6])
        density, duty = map(float, values[6:8])
        origin = values[8]
        if window not in expected:
            raise ValueError('Unexpected activity window')
        want = expected[window]
        if checked != want['count'] or inputs != want['inputs'] or pins != want['pins']:
            raise ValueError('Incomplete post-power activity coverage')
        if (
            errors
            or checked != users + constants
            or min(checked, inputs, pins, users, constants) < 0
        ):
            raise ValueError('Unknown or unpreserved post-power activity')
        if not (
            math.isclose(density, 1e7, rel_tol=1e-5)
            and duty == 0.5
            and origin == 'clock'
        ):
            raise ValueError('Root clock activity mismatch')
        rows[key] = dict(
            checked=checked,
            input_ports=inputs,
            pins=pins,
            user_origin=users,
            matching_constant_origin=constants,
            errors=errors,
            root_clock=dict(density_hz=density, duty=duty, origin=origin),
        )
    if set(rows) != {(w, p) for w, phases in phase_map.items() for p in phases}:
        raise ValueError('Missing or unexpected post-power readback phase')
    return dict(
        passed=True,
        scope='Every explicit pin/input activity after every report_power',
        expected=expected,
        windows={
            w: {p: rows[(w, p)] for p in phases} for w, phases in phase_map.items()
        },
        total_pin_and_input_checks=sum(r['checked'] for r in rows.values()),
        root_clock_checked_separately=True,
        unknown_origin_accepted=False,
        density_relative_tolerance=1e-5,
        density_absolute_tolerance_hz=1e-12,
        duty_absolute_tolerance=0.000501,
        constant_rule='Only constant origin with zero density and identical exact duty 0 or 1',
    )
