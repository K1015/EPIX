#!/usr/bin/env python3
"""Check that synthesis preserves the color schedule for every p-bit."""
import argparse
import functools
import hashlib
import json
from pathlib import Path
import re


def color_schedule(case, cfg):
    """Read or derive the graph colors, then compare them with the reference."""
    graph = json.loads((case / 'graph.json').read_text())
    provenance = dict(
        graph_sha256=hashlib.sha256((case / 'graph.json').read_bytes()).hexdigest()
    )
    if 'colors' in graph:
        colors = graph['colors']
        provenance['color_source'] = 'explicit_graph_colors'
    else:
        # Derive missing grid colors without changing graph.json.
        # The reference header must contain the same colors.
        spec = json.loads((case / 'software_spec.json').read_text())
        assert cfg['family'] == 'maxcut' and spec['family'] == 'kings'
        width = spec['width']
        assert isinstance(width, int) and width > 0
        colors = [((i // width) % 2) * 2 + i % 2 for i in range(cfg['n'])]
        provenance.update(
            color_source='derived_kings_grid',
            grid_width=width,
            software_spec_sha256=hashlib.sha256(
                (case / 'software_spec.json').read_bytes()
            ).hexdigest(),
        )
    assert len(colors) == cfg['n'] and all(
        isinstance(c, int) and 0 <= c < 4 for c in colors
    )
    assert all(colors[u] != colors[v] for u, v, _ in graph['edges'])
    match = re.search(r'\bcolors\s*=\s*\{([^}]*)\}', (case / 'case.hpp').read_text())
    assert match is not None, 'Native color table missing'
    native = [int(x.strip()) for x in match[1].split(',') if x.strip()]
    assert (
        colors == native
    ), 'Graph color schedule differs from independent native table'
    provenance['native_header_sha256'] = hashlib.sha256(
        (case / 'case.hpp').read_bytes()
    ).hexdigest()
    return colors, provenance


def verify_nonconstant(netlist, case):
    """Reject a color selector that synthesis reduced to a constant."""
    netlist, case = Path(netlist), Path(case)
    cfg = json.loads((case / 'config.json').read_text())
    colors, provenance = color_schedule(case, cfg)
    module = json.loads(netlist.read_text())['modules'][cfg['top']]
    for lane, base in enumerate(range(0, cfg['n'], 128)):
        assert len(set(colors)) > 1
        selected = module['netnames'][f'service_{lane}.selected']['bits'][0]
        assert isinstance(selected, int), ('constant color selection', lane, selected)
    return dict(
        passed=True,
        scope='reject_constant_selection_only',
        exhaustive_truth_table=False,
        case=case.name,
        lanes=cfg['clusters'],
        netlist_sha256=hashlib.sha256(netlist.read_bytes()).hexdigest(),
        **provenance,
    )


def verify(netlist, case):
    """Compare every valid site and color pair with the graph schedule."""
    netlist, case = Path(netlist), Path(case)
    cfg = json.loads((case / 'config.json').read_text())
    colors, provenance = color_schedule(case, cfg)
    module = json.loads(netlist.read_text())['modules'][cfg['top']]
    drivers = {
        bit: (name, pin)
        for name, cell in module['cells'].items()
        for pin, bits in cell['connections'].items()
        if cell['port_directions'][pin] == 'output'
        for bit in bits
        if isinstance(bit, int)
    }
    tested = 0
    for lane, base in enumerate(range(0, cfg['n'], 128)):
        selected = module['netnames'][f'service_{lane}.selected']['bits'][0]
        slot_bits = module['netnames'][f'service_{lane}.slot']['bits']
        color_bits = module['netnames'][f'service_{lane}.color']['bits']
        for slot in range(min(128, cfg['n'] - base)):
            for color in range(max(colors) + 1):
                values = {}
                for bits, value in [(slot_bits, slot), (color_bits, color)]:
                    for i, bit in enumerate(bits):
                        want = (value >> i) & 1
                        if isinstance(bit, str):
                            assert bit in ('0', '1') and int(bit) == want
                        else:
                            assert bit not in values or values[bit] == want
                            values[bit] = want

                @functools.lru_cache(None)
                def evaluate(bit):
                    if isinstance(bit, str):
                        assert bit in ('0', '1'), ('undefined color selection', bit)
                        return int(bit)
                    if bit in values:
                        return values[bit]
                    name, pin = drivers[bit]
                    cell = module['cells'][name]
                    typ = cell['type']
                    pins = {
                        p: evaluate(bs[0])
                        for p, bs in cell['connections'].items()
                        if cell['port_directions'][p] == 'input'
                    }
                    a, b = pins.get('A'), pins.get('B')
                    if typ == '$_NOT_':
                        return 1 - a
                    if typ == '$_BUF_':
                        return a
                    if typ == '$_AND_':
                        return a & b
                    if typ == '$_OR_':
                        return a | b
                    if typ == '$_XOR_':
                        return a ^ b
                    if typ == '$_XNOR_':
                        return 1 - (a ^ b)
                    if typ == '$_NAND_':
                        return 1 - (a & b)
                    if typ == '$_NOR_':
                        return 1 - (a | b)
                    if typ == '$_ANDNOT_':
                        return a & (1 - b)
                    if typ == '$_ORNOT_':
                        return a | (1 - b)
                    if typ == '$_MUX_':
                        return b if pins['S'] else a
                    if typ == '$_NMUX_':
                        return 1 - (b if pins['S'] else a)
                    raise AssertionError(
                        ('unsupported selection cone cell', name, typ, pin)
                    )

                actual = evaluate(selected)
                expected = int(colors[base + slot] == color)
                assert actual == expected, dict(
                    lane=lane, slot=slot, color=color, actual=actual, expected=expected
                )
                tested += 1
    return dict(
        passed=True,
        scope='all_valid_site_color_pairs',
        exhaustive_truth_table=True,
        case=case.name,
        combinations=tested,
        netlist_sha256=hashlib.sha256(netlist.read_bytes()).hexdigest(),
        **provenance,
    )


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('netlist', type=Path)
    p.add_argument('case', type=Path)
    p.add_argument('receipt', type=Path)
    a = p.parse_args()
    try:
        result = verify(a.netlist, a.case)
    except Exception as error:
        result = dict(passed=False, error=str(error))
    a.receipt.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result))
    raise SystemExit(0 if result['passed'] else 1)
