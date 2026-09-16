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
            require(header is None and len(words) == 4 and words[1] == 'cnf',
                    'Use one DIMACS p cnf header.')
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
    values = [problem[k] for k in ('n_pbits', 'pbits', 'n_variables', 'n') if k in problem]
    require(values and type(values[0]) is int and values[0] > 0,
            'Specify a positive integer n_pbits or pbits.')
    require(all(type(v) is int and v == values[0] for v in values),
            'Use consistent variable counts.')
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
            require(len(edge) == 3 and all(type(v) is int for v in edge),
                    'Use integer [node, node, cut_weight] edges.')
            i, j, weight = edge
            require(0 <= i < n and 0 <= j < n and i != j,
                    'Use distinct zero-based node indices within the graph.')
            key = tuple(sorted((i, j)))
            require(key not in seen, 'List each undirected edge once.')
            seen.add(key)
            # Positive cut weights become negative couplings in E = -sum(J*s*s).
            matrix[i][j] = matrix[j][i] = -weight
    require(len(matrix) == n and all(len(row) == n for row in matrix),
            'Provide a square J matrix matching the variable count.')
    require(all(type(v) is int and -8 <= v <= 7 for row in matrix for v in row),
            'Use integer couplings in the signed 4-bit range [-8, 7].')
    require(all(matrix[i][i] == 0 and all(matrix[i][j] == matrix[j][i]
                for j in range(n)) for i in range(n)),
            'Use a symmetric J matrix with a zero diagonal.')
    require(problem.get('h', [0] * n) == [0] * n,
            'Use zero external fields with this FPGA table format.')
    bound = max(sum(abs(v) for v in row) for row in matrix)
    require(bound <= 63, 'Keep each row sum of absolute couplings at most 63.')
    normalizer = max(1, max(abs(v) for row in matrix for v in row))
    require(problem.get('normalizer', normalizer) == normalizer,
            'Set normalizer to max(1, max(abs(J))).')
    require(len(lut) == 128 and all(type(v) is int and 0 <= v < 2**32 for v in lut),
            'Supply 128 unsigned 32-bit software thresholds.')
    fields = np.array([i if i < 64 else i - 128 for i in range(128)])
    betas = np.geomspace(0.1, 4.0, 1024)
    # Match software operation order, nearest-even rounding and clipping.
    quantized = np.clip(np.rint(8 * betas[:, None] * fields[None, :] / normalizer), -127, 127)
    thresholds = [lut[min(127, abs(i if i < 128 else i - 256))] for i in range(256)]
    return {
        'weights.hex': hex_text(itertools.chain.from_iterable(matrix), 4),
        'quantization_rom.hex': hex_text(quantized.flat, 8),
        'threshold_rom.hex': hex_text(thresholds, 32),
    }, {'pbits': n, 'normalizer': normalizer, 'maximum_local_field': bound,
        'sweeps': 1024, 'beta_start': 0.1, 'beta_end': 4.0, 'field_address_bits': 7}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,default=Path(__file__).resolve().parents[1]/'lfsr_iid/problem.json')
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    files,parameters=graph_tables(read_problem(args.input),json.loads(Path(__file__).with_name('lut32.json').read_text()))
    require(parameters['pbits']==288,'This package implements 288 variables.')
    args.output.mkdir(parents=True,exist_ok=False)
    for name,content in files.items(): (args.output/name).write_text(content)
    (args.output/'parameters.json').write_text(json.dumps(parameters,indent=2)+'\n')
    print(json.dumps(parameters))
if __name__=='__main__':main()
