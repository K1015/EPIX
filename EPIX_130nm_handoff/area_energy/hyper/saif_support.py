#!/usr/bin/env python3
"""Read cumulative SAIF activity and count toggles in each time window."""
import hashlib
import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
_runtime_root = os.environ.get('EPIX_VERILATOR_ROOT') or os.environ.get(
    'VERILATOR_ROOT'
)
ORIGINAL = Path(_runtime_root) if _runtime_root else None


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def write_if_changed(path, text):
    if path.exists() and path.read_text() == text:
        return
    temporary = path.with_name(path.name + f'.{os.getpid()}.tmp')
    temporary.write_text(text)
    os.replace(temporary, path)


def prepare():
    """Prepare a local Verilator runtime that can save activity snapshots."""
    if ORIGINAL is None:
        raise RuntimeError(
            'Set EPIX_VERILATOR_ROOT or VERILATOR_ROOT to the matching SAIF-capable Verilator runtime'
        )
    runtime = ROOT / 'tech/saif_runtime'
    inc = runtime / 'include'
    inc.mkdir(parents=True, exist_ok=True)
    for p in (ORIGINAL / 'include').iterdir():
        if p.name in ('verilated_saif_c.h', 'verilated_saif_c.cpp'):
            continue
        target = inc / p.name
        if not target.exists():
            target.symlink_to(p)
    binary_dir = (
        ORIGINAL / 'bin' if (ORIGINAL / 'bin').exists() else ORIGINAL.parents[1] / 'bin'
    )
    link = runtime / 'bin'
    if link.is_symlink() and link.resolve() != binary_dir.resolve():
        link.unlink()
    if not link.exists():
        link.symlink_to(binary_dir)
    header = (ORIGINAL / 'include/verilated_saif_c.h').read_text()
    anchor = '    // Close the file\n    void close()'
    assert header.count(anchor) == 1
    header = header.replace(
        anchor,
        '    // Local observer: cumulative statistics immediately before a time boundary.\n    void snapshot(const char* filename, uint64_t endTime);\n'
        + anchor,
    )
    write_if_changed(inc / 'verilated_saif_c.h', header)
    source = (ORIGINAL / 'include/verilated_saif_c.cpp').read_text()
    anchor = 'void VerilatedSaif::close() VL_MT_SAFE_EXCLUDES(m_mutex) {'
    assert source.count(anchor) == 1
    extension = '''// Campaign-local observer. It advances statistics to the exclusive endpoint,
// writes a cumulative snapshot, and retains all values and transition counters.
// It never evaluates or modifies the simulated model.
void VerilatedSaif::snapshot(const char* filename, uint64_t endTime) {
    const VerilatedLockGuard lock{m_mutex};
    assert(isOpen() && endTime >= currentTime() && m_indent == 0);
    writeBuffered(true);
    const int originalFile = m_filep;
    m_filep = ::open(filename, O_CREAT | O_WRONLY | O_TRUNC | O_CLOEXEC, 0666);
    assert(m_filep >= 0);
    m_time = endTime;
    initializeSaifFileContents();
    finalizeSaifFileContents();
    writeBuffered(true);
    ::close(m_filep);
    m_filep = originalFile;
    assert(m_indent == 0);
}

'''
    source = source.replace(anchor, extension + anchor)
    write_if_changed(inc / 'verilated_saif_c.cpp', source)
    hp = ROOT / 'flow/sim.cpp'
    receipt = dict(
        passed=True,
        canonical_harness_sha256=sha(ROOT / 'flow/sim.cpp'),
        observer_harness_sha256=sha(hp),
        observer_only=True,
        runtime_files={
            p.name: sha(p)
            for p in (inc / 'verilated_saif_c.h', inc / 'verilated_saif_c.cpp')
        },
        original_runtime_files={
            name: sha(ORIGINAL / 'include' / name)
            for name in ('verilated_saif_c.h', 'verilated_saif_c.cpp')
        },
    )
    write_if_changed(
        ROOT / 'SAIF_PREPARATION.json', json.dumps(receipt, indent=2) + '\n'
    )
    return runtime


def normalize(s):
    return s.strip('"').replace('\\[', '[').replace('\\]', ']')


def parse(path, wanted, top):
    """Read activity for the requested pins from a SAIF file."""
    stack = []
    scopes = []
    rows = {}
    duration = None
    timescale = None
    with path.open() as f:
        for line in f:
            s = line.strip()
            if s == '(SAIFILE':
                stack.append('file')
            elif s.startswith('(INSTANCE '):
                name = normalize(s[len('(INSTANCE ') :].strip())
                assert not name.endswith(')')
                scopes.append(name)
                stack.append('instance')
            elif s == '(NET':
                stack.append('net')
            elif s == ')':
                kind = stack.pop()
                if kind == 'instance':
                    scopes.pop()
            elif s.startswith('(DURATION '):
                duration = int(s.split()[1].rstrip(')'))
            elif s.startswith('(TIMESCALE '):
                timescale = s[len('(TIMESCALE ') :].rstrip(')').replace(' ', '')
            elif stack and stack[-1] == 'net' and s.startswith('('):
                name = normalize(s[1:].split()[0])
                key = '/'.join(scopes + [name])
                prefix = top + '/'
                if key.startswith('TOP/'):
                    key = key[4:]
                if key not in wanted:
                    continue
                vals = {
                    k: int(v)
                    for k, v in re.findall(r'\((T0|T1|TZ|TX|TB|TC)\s+(\d+)\)', s)
                }
                assert len(vals) == 6, (key, s)
                assert key not in rows or rows[key] == vals, key
                rows[key] = vals
    assert not stack and duration is not None and timescale == '1ps', (
        path,
        stack,
        duration,
        timescale,
    )
    for key, v in rows.items():
        assert v['T0'] + v['T1'] == duration and v['TZ'] == v['TX'] == v['TB'] == 0, (
            key,
            v,
            duration,
        )
    return duration, rows


def counts(out, d, top, a, b, e):
    """Subtract snapshots to get setup and search toggle counts."""
    targets = json.loads((out / 'targets.json').read_text())
    wanted = set()
    for r in targets:
        wanted.add(normalize(r['path']))
        wanted.add(normalize(r['path']) + f'[{r["bit"]}]')
    parsed = [
        parse(d / f'cumulative.saif.{w}.saif', wanted, top)
        for w in ('warm', 'setup', 'end')
    ]
    assert [x[0] for x in parsed] == [a, b, e]
    data = [x[1] for x in parsed]
    lines = []
    for r in targets:
        base = normalize(r['path'])
        bus = base + f'[{r["bit"]}]'
        key = bus if bus in data[0] else base
        assert all(key in x for x in data), ('Missing SAIF target', r, key)
        warm, setup, end = (x[key] for x in data)
        values = [
            end['TC'] - setup['TC'],
            end['T1'] - setup['T1'],
            0,
            setup['TC'] - warm['TC'],
            setup['T1'] - warm['T1'],
            0,
        ]
        assert min(values) >= 0 and values[1] <= e - b and values[4] <= b - a, (
            r,
            values,
        )
        lines.append(' '.join(map(str, [r['id']] + values)))
    (d / 'counts.tsv').write_text('\n'.join(lines) + '\n')
    return dict(targets=len(targets), durations_ps=[a, b, e], complete_coverage=True)


if __name__ == '__main__':
    print(prepare())
