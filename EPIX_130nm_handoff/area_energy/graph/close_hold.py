import os

#!/usr/bin/env python3
"""Preserve original mapping and close minimum-delay timing in a new netlist stage."""
import concurrent.futures as cf
import collections
import json
import re
import time
from pathlib import Path
import map as mapping

ROOT = mapping.ROOT
DELAY = 'sky130_fd_sc_hd__dlygate4sd3_1'
BUFFER = 'sky130_fd_sc_hd__buf_16'


def repair_hold(design, top, text):
    """Add delay cells at inputs that fail hold timing."""
    module = design['modules'][top]
    cells = module['cells']
    targets = set()
    for block in text.split('Startpoint:')[1:]:
        if '(VIOLATED)' not in block:
            continue
        before = block.split('data arrival time')[0]
        pins = re.findall(
            r'^\s*[+-]?[\d.]+\s+[+-]?[\d.]+\s+[\^v]\s+(\S+)\s+\(', before, re.M
        )
        assert pins, block
        endpoint = pins[-1]
        assert '/' in endpoint, endpoint
        name, pin = endpoint.rsplit('/', 1)
        assert name in cells, endpoint
        bus = re.fullmatch(r'(.+)\[(\d+)\]', pin)
        index = 0
        if bus and bus[1] in cells[name]['connections']:
            pin = bus[1]
            index = int(bus[2])
        assert cells[name]['port_directions'][pin] == 'input', endpoint
        assert pin not in ('CLK', 'clk'), endpoint
        targets.add((name, pin, index))
    assert targets, 'Hold violations without repairable endpoints'
    nextbit = (
        max(
            b
            for c in cells.values()
            for bs in c['connections'].values()
            for b in bs
            if isinstance(b, int)
        )
        + 1
    )
    offset = sum(n.startswith('hold_delay_') for n in cells)
    for idx, (name, pin, index) in enumerate(sorted(targets)):
        bit = cells[name]['connections'][pin][index]
        assert isinstance(bit, int)
        for j, typ in enumerate((DELAY, BUFFER)):
            label = f'hold_delay_{offset+idx*2+j:06d}'
            cells[label] = dict(
                hide_name=0,
                type=typ,
                parameters={},
                attributes={},
                port_directions={'A': 'input', 'X': 'output'},
                connections={'A': [bit], 'X': [nextbit]},
            )
            module['netnames'][label + '_out'] = dict(
                hide_name=0, bits=[nextbit], attributes={}
            )
            bit = nextbit
            nextbit += 1
        cells[name]['connections'][pin][index] = bit
    return design, sorted(targets)


def run_timing(out, top):
    """Run setup, hold, and electrical checks."""
    mapping.timing(out, top)
    p = out / 'timing.tcl'
    s = p.read_text().replace(
        'report_checks -path_delay min -group_path_count 5',
        'report_checks -path_delay min -slack_max 0 -group_path_count 200000 -endpoint_path_count 1',
    )
    p.write_text(s)
    mapping.run([mapping.os.environ['OPENSTA'], '-exit', p], out / 'timing.log')


def task(case, mode):
    """Repair timing, then sum standard-cell and SRAM areas."""
    base = ROOT / 'results' / case.name / mode / 'mapped'
    out = base.parent / 'closed'
    out.mkdir(exist_ok=True, parents=True)
    result = dict(case=case.name, mode=mode, passed=False, started=time.time())
    try:
        deadline = time.time() + 43200
        while True:
            if (base / 'status.json').exists():
                x = json.loads((base / 'status.json').read_text())
                if x.get('passed'):
                    break
            if time.time() > deadline:
                raise RuntimeError('Base mapping did not pass')
            time.sleep(10)
        top = json.loads((case / 'config.json').read_text())['top']
        result.update(x)
        result['passed'] = False
        result['base_mapped_sha256'] = x['mapped_sha256']
        design = json.loads((base / 'mapped.json').read_text())
        mapping.emit(design, out, top)
        run_timing(out, top)
        for attempt in range(10):
            report = (out / 'hold.txt').read_text()
            if '(VIOLATED)' not in report:
                break
            design, targets = repair_hold(design, top, report)
            (out / f'hold_repair_{attempt}.json').write_text(
                json.dumps(
                    dict(endpoints=targets, delay_cell=DELAY, buffer_cell=BUFFER),
                    indent=2,
                )
            )
            mapping.emit(design, out, top)
            run_timing(out, top)
        assert (
            '(VIOLATED)' not in (out / 'hold.txt').read_text()
        ), 'Hold repair did not converge'
        for attempt in range(4):
            if '(VIOLATED)' not in (out / 'electrical.txt').read_text():
                break
            design, audit = mapping.repair.repair_electrical_design(
                design,
                (out / 'electrical.txt').read_text(),
                library=mapping.STD,
                buffer_config=dict(cell=BUFFER, input_pin='A', output_pin='X'),
                module_name=top,
            )
            (out / f'electrical_repair_{attempt}.json').write_text(
                json.dumps(audit, indent=2)
            )
            mapping.emit(design, out, top)
            run_timing(out, top)
        assert all(
            '(VIOLATED)' not in (out / f).read_text()
            for f in ('hold.txt', 'setup.txt', 'electrical.txt')
        ), 'Final timing/electrical check failed'
        cells = design['modules'][top]['cells']
        counts = collections.Counter(c['type'] for c in cells.values())
        areas = {}
        for path in (mapping.STD, mapping.SRAM):
            text = path.read_text()
            for typ in counts:
                m = re.search(
                    r'\bcell\s*\(\s*"?' + re.escape(typ) + r'"?\s*\)\s*\{', text
                )
                if m:
                    body = mapping.repair._body(text, m.end() - 1)
                    areas[typ] = float(re.search(r'\barea\s*:\s*([\d.eE+-]+)', body)[1])
        assert set(areas) == set(counts)
        result.update(
            passed=True,
            hold_pass=True,
            setup_pass=True,
            electrical_pass=True,
            area_um2=sum(areas[t] * v for t, v in counts.items()),
            cells=len(cells),
            counts=counts,
            hold_added_cells=sum(n.startswith('hold_delay_') for n in cells),
            mapped_sha256=mapping.sha(out / 'mapped.v'),
            mapped_json_sha256=mapping.sha(out / 'mapped.json'),
        )
    except Exception as e:
        result.update(passed=False, error=str(e))
    result['ended'] = time.time()
    (out / 'status.json').write_text(json.dumps(result, indent=2) + '\n')
    print(case.name, mode, result['passed'], result.get('error', ''), flush=True)
    return result


if __name__ == '__main__':
    import argparse

    p = argparse.ArgumentParser()
    p.add_argument('--cases', nargs='*')
    a = p.parse_args()
    cases = [
        x
        for x in sorted((ROOT / 'cases').iterdir())
        if not a.cases or x.name in a.cases
    ]
    with cf.ThreadPoolExecutor(
        max_workers=int(os.environ.get('EPIX_FLOW_WORKERS', '1'))
    ) as pool:
        rows = list(
            pool.map(
                lambda x: task(*x), [(c, m) for c in cases for m in ('iid', 'epix')]
            )
        )
    (ROOT / 'results/closure_summary.json').write_text(
        json.dumps(rows, indent=2) + '\n'
    )
