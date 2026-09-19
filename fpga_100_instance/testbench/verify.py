#!/usr/bin/env python3
"""Verify inputs, exact witnesses, source identities and every exported ROM."""
import argparse
from collections import Counter
import hashlib
import itertools
import json
import math
from pathlib import Path
import random
import re
import shutil
import subprocess
import tempfile
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SIZES = [8, 14, 20, 26, 32]
FAMILIES = ['maxcut', 'chimera', 'sat', 'xorsat']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def read(p):
    return json.loads(Path(p).read_text())


def energy(J, b):
    return -sum(
        J[i][j] * (2 * b[i] - 1) * (2 * b[j] - 1)
        for i in range(len(b))
        for j in range(i + 1, len(b))
    )


def cnf_score(clauses, b):
    return sum(not any(b[abs(v) - 1] == int(v > 0) for v in c) for c in clauses)


def native_score(p, b):
    if p['family'] == 'sat':
        return cnf_score(p['native_clauses'], b)
    return sum(
        sum(b[v] for v in c['variables']) % 2 != c['parity']
        for c in p['native_clauses']
    )


def hex_values(p):
    return [int(s, 16) for s in p.read_text().splitlines()]


def check_exact_solver():
    rng = random.Random(20260918)
    with tempfile.TemporaryDirectory(prefix='epix_exact_check_') as tmp:
        exe = Path(tmp) / 'exact_graph'
        subprocess.run(
            [
                shutil.which('clang') or shutil.which('cc'),
                '-O3',
                '-std=c11',
                '-Wall',
                '-Wextra',
                '-Werror',
                str(ROOT / 'testbench/tools/exact_graph.c'),
                '-o',
                str(exe),
            ],
            check=True,
        )
        for case in range(80):
            n = 2 + case % 11
            J = [[0] * n for _ in range(n)]
            for i in range(n):
                for j in range(i + 1, n):
                    J[i][j] = J[j][i] = rng.choice([-5, -3, -1, 0, 0, 1, 2, 4])

            # Independent direct enumeration includes every assignment.
            brute = min(energy(J, b) for b in itertools.product((0, 1), repeat=n))
            text = str(n) + '\n' + ' '.join(str(v) for row in J for v in row)
            r = json.loads(subprocess.check_output([str(exe)], input=text, text=True))
            assert r['minimum_ising_energy'] == r['lower_bound'] == brute, case
            assert energy(J, [(r['witness_state'] >> i) & 1 for i in range(n)]) == brute
    return 80


def validate(cases):
    manifest = read(cases / 'manifest.json')
    rows = manifest['instances']
    assert len(rows) == 100 and len({r['id'] for r in rows}) == 100
    assert Counter((r['family'], r['n_variables']) for r in rows) == Counter(
        {(f, n): 5 for f in FAMILIES for n in SIZES}
    )
    assert sha(cases / 'protocol.json') == manifest['protocol_sha256']
    protocol = read(cases / 'protocol.json')
    for name, relative in [
        ('generator_sha256', 'testbench/tools/prepare.py'),
        ('exact_solver_sha256', 'testbench/tools/exact_graph.c'),
        ('hex_generator_sha256', 'hex_generation/generate.py'),
    ]:
        assert protocol[name] == sha(ROOT / relative)
    thresholds = read(ROOT / 'hex_generation/lut32.json')
    mass_checked = set()
    hashes = 0
    xor_patterns = 0
    identities = set()
    rng = random.Random(731)
    graph_widths = Counter()
    break_widths = Counter()
    origins = Counter()

    # Check each input against its certificate and exported hardware tables.
    for row in rows:
        folder = cases / row['path']
        p = read(folder / 'problem.json')
        cert = read(folder / 'certificate.json')
        prov = read(folder / 'provenance.json')
        for name, digest in row['sha256'].items():
            assert sha(folder / name) == digest, (row['id'], name)
            hashes += 1
        assert set(row['sha256']) == {
            str(f.relative_to(folder)) for f in folder.rglob('*') if f.is_file()
        }
        n = p['n_pbits']
        f = p['family']
        assert n == p['n_variables'] == row['n_variables'] and p['n_auxiliary'] == 0
        assert p['id'] == cert['id'] == row['id'] and cert['problem_sha256'] == sha(
            folder / 'problem.json'
        )
        assert 'witness' not in p and 'planted_assignment' not in p
        b = cert['witness']
        assert len(b) == n and all(type(v) == int and v in (0, 1) for v in b)
        origins[prov['kind']] += 1
        if prov['kind'] == 'retained_input':
            assert sha(folder / 'source/problem.json') == prov['input_sha256']
            assert sha(folder / 'source/certificate.json') == prov['certificate_sha256']
            original = read(folder / 'source/problem.json')
            if f in ('maxcut', 'chimera'):
                assert original['J'] == p['J'] and original['h'] == p['h']
            elif n < 32:
                assert (
                    original['native_clauses'] == p['native_clauses']
                    and original['cnf_clauses'] == p['cnf_clauses']
                )
            elif f == 'sat':
                assert p['native_clauses'] == [
                    [(v + 1) * s for v, s in zip(c['variables'], c['signs'])]
                    for c in original['constraints']
                ]
            else:
                assert original['constraints'] == p['native_clauses']
        par = read(folder / 'fpga/parameters.json')
        assert par == row['parameters'] and par['pbits'] == n
        if f in ('maxcut', 'chimera'):
            J = p['J']
            assert len(J) == n and all(len(r) == n for r in J) and p['h'] == [0] * n
            assert all(
                J[i][j] == J[j][i] and (i != j or J[i][j] == 0)
                for i in range(n)
                for j in range(n)
            )
            assert all(type(v) == int and -8 <= v <= 7 for r in J for v in r)
            assert (
                energy(J, b)
                == cert['target']
                == cert['lower_bound']
                == cert['minimum_ising_energy']
            )
            assert cert['solver_source_sha256'] == sha(
                ROOT / 'testbench/tools/exact_graph.c'
            )
            if (folder / 'source/certificate.json').exists():
                assert (
                    read(folder / 'source/certificate.json')['minimum_ising_energy']
                    == cert['target']
                )
            cut = sum(
                -J[i][j] for i in range(n) for j in range(i + 1, n) if b[i] != b[j]
            )
            assert cut == cert['maximum_signed_cut']
            if f == 'maxcut':
                assert all(v <= 0 for r in J for v in r)
            else:
                coords = (
                    prov.get('coordinates')
                    or read(folder / 'source/problem.json')['source']['coordinates']
                )
                assert len(coords) == n and len({tuple(c) for c in coords}) == n
                for i, (ri, ci, ui, ki) in enumerate(coords):
                    for j in range(i + 1, n):
                        rj, cj, uj, kj = coords[j]
                        allowed = (ri == rj and ci == cj and ui != uj) or (
                            ui == uj
                            and ki == kj
                            and (
                                (ui == 0 and ci == cj and abs(ri - rj) == 1)
                                or (ui == 1 and ri == rj and abs(ci - cj) == 1)
                            )
                        )
                        assert bool(J[i][j]) == bool(allowed)
                assert J[0][1] * J[1][2] * J[2][3] * J[3][0] < 0
            seen, stack = {0}, [0]
            while stack:
                u = stack.pop()
                for v in range(n):
                    if J[u][v] and v not in seen:
                        seen.add(v)
                        stack.append(v)
            assert len(seen) == n
            values = hex_values(folder / 'fpga/weights.hex')
            assert values == [v & 15 for r in J for v in r]
            fb = par['field_address_bits']
            graph_widths[fb] += 1
            count = 1 << fb
            bound = max(sum(abs(v) for v in r) for r in J)
            norm = max(1, max(abs(v) for r in J for v in r))
            assert (
                par['maximum_local_field'] == bound < count // 2
                and par['normalizer'] == norm
            )
            q = hex_values(folder / 'fpga/quantization_rom.hex')
            assert len(q) == 1024 * count
            fields = np.arange(count)
            fields[count // 2 :] -= count
            expected = np.clip(
                np.rint(
                    8 * np.geomspace(0.1, 4, 1024)[:, None] * fields[None, :] / norm
                ),
                -127,
                127,
            ).astype(int)
            assert np.array_equal(np.asarray(q).reshape(1024, count), expected & 255)
            assert hex_values(folder / 'fpga/threshold_rom.hex') == [
                thresholds[min(127, abs(v if v < 128 else v - 256))] for v in range(256)
            ]
            signature = json.dumps([f, n, J], separators=(',', ':'))
        else:
            clauses = p['cnf_clauses']
            assert all(
                len(c) == 3
                and len(set(map(abs, c))) == 3
                and all(1 <= abs(v) <= n for v in c)
                for c in clauses
            )
            assert (
                cnf_score(clauses, b)
                == native_score(p, b)
                == cert['target']
                == cert['lower_bound']
                == 0
            )
            if f == 'sat':
                assert clauses == p['native_clauses'] and len(clauses) == round(4.3 * n)
            else:
                native = p['native_clauses']
                assert len(native) == 2 * n // 3 + 1 and len(clauses) == 4 * len(native)
                assert len({tuple(sorted(c['variables'])) for c in native}) == len(
                    native
                )
                degrees = Counter(v for c in native for v in c['variables'])
                assert set(degrees) == set(range(n)) and set(degrees.values()) <= {2, 3}
                seen, stack = {0}, [0]
                adj = [set() for _ in range(n)]
                for k, c in enumerate(native):
                    vs = c['variables']
                    assert len(set(vs)) == 3 and c['parity'] in (0, 1)
                    for v in vs:
                        adj[v].update(vs)
                    for bits in itertools.product((0, 1), repeat=3):
                        assignment = [0] * n
                        for v, bit in zip(vs, bits):
                            assignment[v] = bit
                        assert cnf_score(clauses[k * 4 : k * 4 + 4], assignment) == int(
                            sum(bits) % 2 != c['parity']
                        )
                        xor_patterns += 1
                while stack:
                    for v in adj[stack.pop()] - seen:
                        seen.add(v)
                        stack.append(v)
                assert len(seen) == n
            for _ in range(20):
                bits = [rng.randrange(2) for _ in range(n)]
                assert native_score(p, bits) == cnf_score(clauses, bits)
            lines = (folder / 'problem.cnf').read_text().splitlines()
            assert lines[0] == f'p cnf {n} {len(clauses)}'
            assert [
                list(map(int, l.split()))[:-1] for l in lines[1:]
            ] == clauses and all(l.endswith(' 0') for l in lines[1:])
            encoded = re.findall(
                r"16'd(\d+): clause_rom=24'h([0-9a-f]+);",
                (folder / 'fpga/clauses.svh').read_text(),
            )
            assert len(encoded) == len(clauses)
            for k, (idx, packed) in enumerate(encoded):
                assert int(idx) == k
                v = int(packed, 16)
                decoded = [
                    ((v >> (8 * j) & 127) + 1) * (1 if v >> (8 * j) & 128 else -1)
                    for j in range(3)
                ]
                assert decoded == clauses[k]
            bb = par['break_address_bits']
            break_widths[bb] += 1
            occ = Counter(v for c in clauses for v in c)
            assert (
                par['maximum_candidate_break']
                == max(occ[-v] for c in clauses for v in c)
                < 1 << bb
            )
            assert par['clauses'] == len(clauses)
            mp = folder / 'fpga/masses.hex'
            digest = sha(mp)
            if digest not in mass_checked:
                mass_checked.add(digest)
                values = hex_values(mp)
                assert len(values) == 1 << (3 * bb)
                for addr, packed in enumerate(values):
                    br = [(addr >> (bb * j)) & ((1 << bb) - 1) for j in (2, 1, 0)]
                    probs = [math.pow(0.9 + x, -2.06) for x in br]
                    z = sum(probs)
                    scaled = [65533 * x / z for x in probs]
                    expected = [1 + math.floor(v) for v in scaled]
                    frac = [x - math.floor(x) for x in scaled]
                    for _ in range(65536 - sum(expected)):
                        k = max(range(3), key=frac.__getitem__)
                        expected[k] += 1
                        frac[k] = -1
                    a, bmass = packed & 65535, packed >> 16
                    assert [a, bmass, 65536 - a - bmass] == expected and min(
                        expected
                    ) > 0
            signature = json.dumps(
                [f, n, sorted(tuple(sorted(c)) for c in clauses)], separators=(',', ':')
            )
        digest = hashlib.sha256(signature.encode()).hexdigest()
        assert digest not in identities, row['id']
        identities.add(digest)
    return dict(
        status='PASS',
        cases=100,
        group_count=20,
        instances_per_group=5,
        hashed_case_files=hashes,
        exact_target_witnesses=100,
        unique_problem_identities=len(identities),
        xor_truth_table_assignments=xor_patterns,
        origins=dict(origins),
        field_address_bits=dict(graph_widths),
        break_address_bits=dict(break_widths),
        manifest_sha256=sha(cases / 'manifest.json'),
    )


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--cases', type=Path, default=ROOT / 'cases')
    ap.add_argument('--output', type=Path)
    ap.add_argument('--check-exact-solver', action='store_true')
    args = ap.parse_args()
    report = validate(args.cases)
    if args.check_exact_solver:
        report['independent_brute_force_solver_checks'] = check_exact_solver()
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
