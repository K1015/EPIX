#!/usr/bin/env python3
"""Generate the PYNQ solver tables from a software graph or ternary CNF."""
import argparse
from collections import Counter
import itertools
import json
import math
from pathlib import Path

import numpy as np


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_problem(path):
    if path.suffix.lower() != '.cnf':
        return json.loads(path.read_text())
    clauses, pending, header = [], [], None
    for line in path.read_text().splitlines():
        words = line.split()
        if not words or words[0] == 'c':
            continue
        if words[0] == 'p':
            require(
                header is None and len(words) == 4 and words[1] == 'cnf',
                'Use one DIMACS p cnf header.',
            )
            header = tuple(map(int, words[2:]))
            continue
        require(header is not None, 'Place the DIMACS header before the clauses.')
        for literal in map(int, words):
            if literal:
                pending.append(literal)
            else:
                clauses.append(pending)
                pending = []
    require(header is not None and not pending, 'End each DIMACS clause with zero.')
    require(len(clauses) == header[1], 'Match the clause count in the DIMACS header.')
    return {'n_pbits': header[0], 'clauses': clauses}


def size(problem):
    values = [
        problem[k] for k in ('n_pbits', 'pbits', 'n_variables', 'n') if k in problem
    ]
    require(
        values and type(values[0]) is int and values[0] > 0,
        'Specify a positive integer n_pbits or pbits.',
    )
    require(
        all(type(v) is int and v == values[0] for v in values),
        'Use consistent variable counts.',
    )
    return values[0]


def hex_text(values, bits):
    mask = (1 << bits) - 1
    return ''.join(f'{int(v) & mask:0{(bits + 3) // 4}x}\n' for v in values)


def graph_tables(problem, lut):
    n = size(problem)
    matrix = problem.get('J')
    if matrix is None:
        require('edges' in problem, 'Supply a J matrix or an edges list.')
        matrix = [[0] * n for _ in range(n)]
        seen = set()
        for edge in problem['edges']:
            require(
                len(edge) == 3 and all(type(v) is int for v in edge),
                'Use integer [node, node, cut_weight] edges.',
            )
            i, j, weight = edge
            require(
                0 <= i < n and 0 <= j < n and i != j,
                'Use distinct zero-based node indices within the graph.',
            )
            key = tuple(sorted((i, j)))
            require(key not in seen, 'List each undirected edge once.')
            seen.add(key)

            # Positive cut weights become negative couplings in E = -sum(J*s*s).
            matrix[i][j] = matrix[j][i] = -weight
    require(
        len(matrix) == n and all(len(row) == n for row in matrix),
        'Provide a square J matrix matching the variable count.',
    )
    require(
        all(type(v) is int and -8 <= v <= 7 for row in matrix for v in row),
        'Use integer couplings in the signed 4-bit range [-8, 7].',
    )
    require(
        all(
            matrix[i][i] == 0 and all(matrix[i][j] == matrix[j][i] for j in range(n))
            for i in range(n)
        ),
        'Use a symmetric J matrix with a zero diagonal.',
    )
    require(
        problem.get('h', [0] * n) == [0] * n,
        'Use zero external fields with this FPGA table format.',
    )
    bound = max(sum(abs(v) for v in row) for row in matrix)
    field_bits = max(7, 1 + bound.bit_length())
    field_count = 1 << field_bits
    normalizer = max(1, max(abs(v) for row in matrix for v in row))
    require(
        problem.get('normalizer', normalizer) == normalizer,
        'Set normalizer to max(1, max(abs(J))).',
    )
    require(
        len(lut) == 128 and all(type(v) is int and 0 <= v < 2**32 for v in lut),
        'Supply 128 unsigned 32-bit software thresholds.',
    )
    fields = np.array(
        [i if i < field_count // 2 else i - field_count for i in range(field_count)]
    )
    betas = np.geomspace(0.1, 4.0, 1024)

    # Match software operation order, nearest-even rounding and clipping.
    quantized = np.clip(
        np.rint(8 * betas[:, None] * fields[None, :] / normalizer), -127, 127
    )
    thresholds = [lut[min(127, abs(i if i < 128 else i - 256))] for i in range(256)]
    return {
        'weights.hex': hex_text(itertools.chain.from_iterable(matrix), 4),
        'quantization_rom.hex': hex_text(quantized.flat, 8),
        'threshold_rom.hex': hex_text(thresholds, 32),
    }, {
        'pbits': n,
        'normalizer': normalizer,
        'maximum_local_field': bound,
        'sweeps': 1024,
        'beta_start': 0.1,
        'beta_end': 4.0,
        'field_address_bits': field_bits,
    }


def masses(breaks):
    probabilities = [math.pow(0.9 + b, -2.06) for b in breaks]
    total = sum(probabilities)
    scaled = [65533 * p / total for p in probabilities]
    weights = [1 + math.floor(v) for v in scaled]
    fractions = [v - math.floor(v) for v in scaled]

    # Allocate remaining units by fractional size, preserving first-index ties.
    while sum(weights) < 65536:
        index = max(range(3), key=fractions.__getitem__)
        weights[index] += 1
        fractions[index] = -1
    return weights


def clause_tables(problem, break_bits):
    n = size(problem)
    require(n <= 128, 'Use at most 128 variables with the 24-bit clause format.')
    clauses = problem.get('clauses', problem.get('cnf_clauses'))
    require(
        isinstance(clauses, list) and 0 < len(clauses) <= 65535,
        'Supply clauses or cnf_clauses as a list of ternary CNF clauses.',
    )
    for clause in clauses:
        require(
            len(clause) == 3
            and all(type(v) is int and 0 < abs(v) <= n for v in clause)
            and len({abs(v) for v in clause}) == 3,
            'Use three distinct, signed one-based variables in each clause.',
        )
    require(break_bits in (4, 5), 'Choose 4 or 5 bits per break count.')
    occurrences = Counter(itertools.chain.from_iterable(clauses))
    bound = max(occurrences[-v] for clause in clauses for v in clause)
    require(
        bound < 2**break_bits,
        'Increase --break-bits and the matching RTL address width.',
    )
    packed_masses = []
    for breaks in itertools.product(range(2**break_bits), repeat=3):
        a, b, c = masses(breaks)
        require(
            min(a, b, c) > 0 and a + b + c == 65536,
            'Use positive masses totaling 65536.',
        )
        packed_masses.append(a | (b << 16))
    lines = [
        f'localparam integer CLAUSES={len(clauses)};',
        'function automatic [23:0] clause_rom(input logic [15:0] index);',
        '    begin case(index)',
    ]
    for index, clause in enumerate(clauses):
        packed = sum(
            ((abs(v) - 1) | (128 if v > 0 else 0)) << (8 * j)
            for j, v in enumerate(clause)
        )
        lines.append(f"        16'd{index}: clause_rom=24'h{packed:06x};")
    lines += ['        default: clause_rom=0;', '    endcase end', 'endfunction']
    return {
        'masses.hex': hex_text(packed_masses, 32),
        'clauses.svh': '\n'.join(lines) + '\n',
    }, {
        'pbits': n,
        'clauses': len(clauses),
        'break_address_bits': break_bits,
        'maximum_candidate_break': bound,
        'mass_entries': len(packed_masses),
    }


def generate(family, source, output, break_bits=4, lut_path=None):
    problem = read_problem(Path(source))
    if family in ('maxcut', 'chimera'):
        lut_path = (
            Path(lut_path) if lut_path else Path(__file__).with_name('lut32.json')
        )
        files, parameters = graph_tables(problem, json.loads(lut_path.read_text()))
    else:
        require(family in ('sat', 'xorsat'), 'Choose maxcut, chimera, sat or xorsat.')
        files, parameters = clause_tables(problem, break_bits)
    parameters = {'family': family, **parameters}
    files['parameters.json'] = json.dumps(parameters, indent=2) + '\n'
    output = Path(output)
    output.mkdir(parents=True, exist_ok=True)
    for name, text in files.items():
        (output / name).write_text(text)
    return parameters


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '--family', required=True, choices=('maxcut', 'chimera', 'sat', 'xorsat')
    )
    parser.add_argument('--input', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--break-bits', type=int, default=4, choices=(4, 5))
    parser.add_argument(
        '--lut', type=Path, help='Optional 128-entry software threshold JSON.'
    )
    args = parser.parse_args()
    try:
        result = generate(
            args.family, args.input, args.output, args.break_bits, args.lut
        )
    except (ValueError, OSError) as error:
        parser.error(str(error))
    print(
        f"Generated {args.family} tables for {result['pbits']} variables in {args.output}"
    )


if __name__ == '__main__':
    main()
