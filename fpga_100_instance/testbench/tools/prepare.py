#!/usr/bin/env python3
"""Reproduce the fixed 100-case input/export collection in a NEW directory."""
import argparse
from collections import Counter
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time
import numpy as np

HERE = Path(__file__).resolve().parent
PACKAGE = HERE.parents[1]
PROJECT = PACKAGE.parents[1]
SMALL = PROJECT / 'pbit_4families_4to26_1024sweeps_v1'
LARGE = PROJECT / 'EPIX-software/software'
SIZES = [8, 14, 20, 26, 32]
FAMILIES = ['maxcut', 'chimera', 'sat', 'xorsat']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def save(p, d):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(d, indent=2, sort_keys=True) + '\n')


def connected(triples, n):
    adj = [set() for _ in range(n)]
    for c in triples:
        for v in c:
            adj[v].update(c)
    seen, stack = {0}, [0]
    while stack:
        for v in adj[stack.pop()] - seen:
            seen.add(v)
            stack.append(v)
    return len(seen) == n


# Exclude each assignment with the wrong parity using one CNF clause.
def xor_cnf(native):
    out = []
    for c in native:
        for bits in itertools.product((0, 1), repeat=3):
            if sum(bits) % 2 != c['parity']:
                out.append(
                    [-(v + 1) if b else v + 1 for v, b in zip(c['variables'], bits)]
                )
    return out


def generated_native(family, n, i):
    seed = (2150000000 if family == 'sat' else 2160000000) + n * 1000 + i - 1
    rng = np.random.default_rng(seed)
    if family == 'sat':
        witness = rng.integers(0, 2, size=n).tolist()
        native = []
        for _ in range(round(4.3 * n)):
            vs = rng.choice(n, 3, replace=False).tolist()
            mask = int(rng.integers(1, 8))
            native.append(
                [
                    v + 1 if bool(witness[v]) == bool((mask >> j) & 1) else -(v + 1)
                    for j, v in enumerate(vs)
                ]
            )
        cnf = native
    else:
        m = 2 * n // 3 + 1
        degree = np.full(n, 2)
        degree[rng.choice(n, 3 * m - 2 * n, replace=False)] += 1
        for attempt in range(10000):
            slots = np.repeat(np.arange(n), degree)
            rng.shuffle(slots)
            triples = slots.reshape(m, 3).tolist()
            if (
                any(len(set(c)) != 3 for c in triples)
                or len({tuple(sorted(c)) for c in triples}) != m
                or not connected(triples, n)
            ):
                continue
            break
        else:
            raise RuntimeError('Structural generation exhausted')
        witness = rng.integers(0, 2, size=n).tolist()
        native = [
            dict(variables=c, parity=sum(witness[v] for v in c) % 2) for c in triples
        ]
        cnf = xor_cnf(native)
    return (
        dict(n_pbits=n, cnf_clauses=cnf, native_clauses=native),
        dict(witness=witness),
        {
            'kind': 'generated_native',
            'seed': seed,
            'rule': (
                'Planted 3-SAT M=round(4.3*N)'
                if family == 'sat'
                else 'Connected degree-2/3 planted 3-XOR M=floor(2*N/3)+1'
            ),
        },
    )


def generated_graph(family, n, i):
    seed = (2190000000 if family == 'maxcut' else 2200000000) + n * 1000 + i - 1
    rng = np.random.default_rng(seed)
    J = [[0] * n for _ in range(n)]
    if family == 'maxcut':
        ring = {tuple(sorted((v, (v + 1) % n))) for v in range(n)}
        for a in range(n):
            for b in range(a + 1, n):
                if (a, b) in ring or rng.random() < 0.35:
                    J[a][b] = J[b][a] = -int(rng.integers(1, 6))
        rule = 'Connected positive-weight MaxCut: ring backbone, other edges independently p=0.35, weights uniform integers 1..5.'
        extra = {}
    else:
        coords = [[0, c, u, k] for c in range(4) for k in range(4) for u in range(2)][
            :n
        ]
        for a, (ra, ca, ua, ka) in enumerate(coords):
            for b in range(a + 1, n):
                rb, cb, ub, kb = coords[b]
                link = (ca == cb and ua != ub) or (
                    abs(ca - cb) == 1 and ua == ub == 1 and ka == kb
                )
                if link:
                    J[a][b] = J[b][a] = int(rng.choice([-3, -2, -1, 1, 2, 3]))

        # Fixed structural frustration, not solver-outcome screening.
        if J[0][1] * J[1][2] * J[2][3] * J[3][0] > 0:
            J[0][3] = J[3][0] = -J[0][3]
        rule = 'Induced C(1,4,4) patch in interleaved cell order; signed couplings +/-1..3; first four-cycle frustrated.'
        extra = {'coordinates': coords}
    return (
        dict(n_pbits=n, J=J, h=[0] * n),
        {},
        dict(kind='generated_graph', seed=seed, rule=rule, **extra),
    )


def source_case(family, n, i):
    if n == 32 and family in ('maxcut', 'chimera'):
        return generated_graph(family, n, i)
    if n < 32 and family in ('sat', 'xorsat') and i > 1:
        return generated_native(family, n, i)

    # Prefer packaged inputs so regeneration works after moving the folder.
    bundled = PACKAGE / 'cases' / family / f'n{n:02d}' / f'instance{i:02d}'
    if (bundled / 'source/problem.json').exists():
        # A completed package is sufficient to rebuild itself after relocation.
        p = json.loads((bundled / 'problem.json').read_text())
        c = json.loads((bundled / 'certificate.json').read_text())
        provenance = json.loads((bundled / 'provenance.json').read_text())
        assert sha(bundled / 'source/problem.json') == provenance['input_sha256']
        assert (
            sha(bundled / 'source/certificate.json') == provenance['certificate_sha256']
        )
        return p, c, provenance
    if n == 32:
        prefix = '3hypergraph_' + family
        folder = LARGE / (prefix + '32') / (prefix + f'32_instance{i}')
        ip, cp = folder / 'problem.json', folder / 'certificate.json'
        d, c = json.loads(ip.read_text()), json.loads(cp.read_text())
        if family == 'sat':
            native = [
                [(v + 1) * s for v, s in zip(cl['variables'], cl['signs'])]
                for cl in d['constraints']
            ]
            cnf = native
        else:
            native = d['constraints']
            cnf = xor_cnf(native)
        p = dict(n_pbits=n, native_clauses=native, cnf_clauses=cnf)
    elif family in ('maxcut', 'chimera'):
        name = f'{family}_n{n:02d}_i{i:02d}.json'
        ip, cp = (
            SMALL / family / 'instances' / name,
            SMALL / family / 'solutions' / name,
        )
        d, c = json.loads(ip.read_text()), json.loads(cp.read_text())
        p = dict(n_pbits=n, J=d['J'], h=d['h'])
        c = {**c, 'witness': [(c['witness_state'] >> v) & 1 for v in range(n)]}
    else:
        f = family.upper()
        name = f'{f}_native_n{n:02d}_i01.json'
        base = SMALL / f / 'fpga_native_v1'
        ip, cp = base / 'instances' / name, base / 'verification' / name
        d, c = json.loads(ip.read_text()), json.loads(cp.read_text())
        p = dict(
            n_pbits=n, native_clauses=d['native_clauses'], cnf_clauses=d['cnf_clauses']
        )
    provenance = dict(
        kind='retained_input',
        input_path=str(ip.relative_to(PROJECT)),
        input_sha256=sha(ip),
        certificate_path=str(cp.relative_to(PROJECT)),
        certificate_sha256=sha(cp),
    )
    if 'generator_seed' in d:
        provenance['seed'] = d['generator_seed']
    return p, c, provenance


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    spec = importlib.util.spec_from_file_location(
        'tables', PACKAGE / 'hex_generation/generate.py'
    )
    tables = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tables)
    build = HERE / 'build'
    build.mkdir(exist_ok=True)
    exe = build / 'exact_graph'
    compiler = shutil.which('clang') or shutil.which('cc')
    subprocess.run(
        [
            compiler,
            '-O3',
            '-std=c11',
            '-Wall',
            '-Wextra',
            '-Werror',
            str(HERE / 'exact_graph.c'),
            '-o',
            str(exe),
        ],
        check=True,
    )
    protocol = dict(
        schema='epix_100_input_protocol_v1',
        sizes=SIZES,
        families=FAMILIES,
        instances_per_group=5,
        selection='Small graph i01..i05 and native i01 retained; new native i02..i05 use fixed seeds; native32 selects numbered instances1..5 before new runs; graph32 generated with documented structural continuations.',
        auxiliary_variables=0,
        graph32_scope='Structural continuation, not a claim that unavailable historical graph generator code or its exact sampling distribution was reproduced.',
        graph32_seeds='2190000000 (MaxCut) or 2200000000 (Chimera) + N*1000 + instance_index - 1',
        native_seeds='2150000000 (SAT) or 2160000000 (XORSAT) + N*1000 + instance_index - 1',
        native_rules={
            'sat': 'M=round(4.3N), planted ternary clauses, repeated clauses allowed',
            'xorsat': 'M=floor(2N/3)+1, connected unique triples, degree2/3, four CNF clauses per parity constraint',
        },
        rng='One shared serial Galois LFSR; mask0x80200003;32 bit steps per requested word;zero seed maps to0xA5C36EFE',
        graph_solver='1024 full sequential heat-bath sweeps, geomspace beta0.1..4, delta_q1, max reuse age2',
        native_solver='Native categorical probSAT, EPIX age254; solution or1024*N flips;31-bit word projection',
        scope='Software inputs, independently checked target evidence, and FPGA data exports; no new bitstreams or physical board campaign.',
        numpy_version=np.__version__,
        generator_sha256=sha(__file__),
        exact_solver_sha256=sha(HERE / 'exact_graph.c'),
        hex_generator_sha256=sha(PACKAGE / 'hex_generation/generate.py'),
    )
    save(out / 'protocol.json', protocol)
    rows = []
    for family in FAMILIES:
        for n in SIZES:
            for i in range(1, 6):
                name = f'{family}_n{n:02d}_i{i:02d}'
                folder = out / family / f'n{n:02d}' / f'instance{i:02d}'
                p, c, provenance = source_case(family, n, i)
                p.update(
                    schema='epix_fpga_input_v1',
                    id=name,
                    family=family,
                    n_variables=n,
                    n_auxiliary=0,
                )
                folder.mkdir(parents=True)
                if provenance['kind'] == 'retained_input':
                    (folder / 'source').mkdir()
                    bundled = (
                        PACKAGE
                        / 'cases'
                        / family
                        / f'n{n:02d}'
                        / f'instance{i:02d}'
                        / 'source'
                    )
                    for key, source_name in [
                        ('input_path', 'problem.json'),
                        ('certificate_path', 'certificate.json'),
                    ]:
                        src = (
                            bundled / source_name
                            if (bundled / source_name).exists()
                            else PROJECT / provenance[key]
                        )
                        shutil.copy2(src, folder / 'source' / source_name)
                save(folder / 'problem.json', p)
                save(folder / 'provenance.json', provenance)
                if family in ('maxcut', 'chimera'):
                    started = time.monotonic()
                    result = subprocess.run(
                        [str(exe)],
                        input=str(n)
                        + '\n'
                        + ' '.join(str(v) for row in p['J'] for v in row),
                        text=True,
                        capture_output=True,
                        check=True,
                    )
                    cert = json.loads(result.stdout)
                    if 'minimum_ising_energy' in c:
                        assert (
                            cert['minimum_ising_energy'] == c['minimum_ising_energy']
                        ), name
                    cert.update(
                        witness=[(cert['witness_state'] >> v) & 1 for v in range(n)],
                        target=cert['minimum_ising_energy'],
                        objective='minimum zero-field Ising energy',
                        solver_source_sha256=sha(HERE / 'exact_graph.c'),
                        elapsed_seconds=time.monotonic() - started,
                    )
                    cert['maximum_signed_cut'] = (
                        cert['target'] * -1
                        - sum(p['J'][a][b] for a in range(n) for b in range(a + 1, n))
                    ) // 2
                    break_bits = 4
                else:
                    cert = dict(
                        witness=c['witness'],
                        target=0,
                        lower_bound=0,
                        objective='minimum violated native constraints',
                        method='satisfying_witness_and_nonnegative_objective',
                    )

                    # Size the mass-ROM address from the largest possible break count.
                    counts = Counter(v for cl in p['cnf_clauses'] for v in cl)
                    bound = max(counts[-v] for cl in p['cnf_clauses'] for v in cl)
                    break_bits = max(4, bound.bit_length())
                    assert break_bits <= 5
                    (folder / 'problem.cnf').write_text(
                        f'p cnf {n} {len(p["cnf_clauses"])}\n'
                        + ''.join(
                            ' '.join(map(str, cl)) + ' 0\n' for cl in p['cnf_clauses']
                        )
                    )
                cert.update(id=name, problem_sha256=sha(folder / 'problem.json'))
                save(folder / 'certificate.json', cert)
                parameters = tables.generate(
                    family, folder / 'problem.json', folder / 'fpga', break_bits
                )
                row = dict(
                    id=name,
                    family=family,
                    n_variables=n,
                    instance_index=i,
                    path=str(folder.relative_to(out)),
                    origin=provenance['kind'],
                    parameters=parameters,
                    sha256={
                        str(f.relative_to(folder)): sha(f)
                        for f in sorted(folder.rglob('*'))
                        if f.is_file()
                    },
                )
                rows.append(row)
                print(
                    f'{len(rows)}/100 {name}: target={cert["target"]}, exported',
                    flush=True,
                )
    save(
        out / 'manifest.json',
        dict(
            schema='epix_100_input_manifest_v1',
            status='GENERATED',
            case_count=len(rows),
            protocol_sha256=sha(out / 'protocol.json'),
            instances=rows,
        ),
    )


if __name__ == '__main__':
    main()
