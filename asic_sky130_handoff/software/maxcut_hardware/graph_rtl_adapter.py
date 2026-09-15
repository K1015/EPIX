"""Generate combinational graph functions for the frozen larger ASIC inputs.

This module does not generate the state machine, run trials, or launch ASIC tools.
Its tables use the frozen calibrated ladder and the verified reference kernel.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path

import numpy as np

from input_adapter import SHARED_ROOT, SIZES, file_sha256, load_selected, require
from reference_adapter import KERNEL_SHA256, load_private_kernel


def balanced_sum(terms):
    require(bool(terms), "Cannot generate an empty objective")
    if len(terms) == 1:
        return terms[0]
    middle = len(terms) // 2
    return '(' + balanced_sum(terms[:middle]) + ' +\n' + balanced_sum(terms[middle:]) + ')'


def tables(item, kernel):
    cfg = item.configuration
    probabilities = {}
    for temperature, beta in enumerate(cfg['betas']):
        for raw in range(-8, 9):
            field = int(np.clip(np.rint(kernel.FIELD_SCALE * beta * raw),
                                -kernel.FIELD_LIMIT, kernel.FIELD_LIMIT))
            probabilities[temperature * 17 + raw + 8] = int(kernel.LUT_TABLE[abs(field)])
    swaps = {}
    for left in range(len(cfg['betas']) - 1):
        row = {}
        for gap in range(1, cfg['bounds']['unsigned_gap_max'] + 1):
            probability = kernel.swap_probability(cfg['betas'][left], cfg['betas'][left + 1], 0, -2 * gap)
            threshold = int(probability * kernel.U32_SCALE)
            require(0 <= threshold < 2**32, "Invalid positive-gap exchange threshold")
            if threshold:
                row[gap] = threshold
        swaps[left] = row
    return probabilities, swaps


def generate_functions(item, kernel):
    cfg, graph = item.configuration, item.graph
    n, score_width = graph.n, cfg['widths']['score']
    temperature_width, gap_width = cfg['widths']['temperature_index'], cfg['widths']['unsigned_score_gap']
    probabilities, swaps = tables(item, kernel)
    lines = ['// Generated from the frozen certified signed-weight benchmark.',
             f'function automatic signed [4:0] raw_field(input integer node,input logic [{n-1}:0] bits);',
             'begin', 'case(node)']
    for node in range(n):
        terms = [f"(bits[{int(neighbor)}] ? {'-' if weight > 0 else ''}5'sd1 : {'-' if weight < 0 else ''}5'sd1)"
                 for neighbor, weight in zip(graph.neigh_idx[node], graph.neigh_w[node]) if neighbor < n]
        lines.append(f'{node}: raw_field = ' + ' + '.join(terms) + ';')
    lines += ['default: raw_field=0;', 'endcase', 'end', 'endfunction']
    terms = [f"((bits[{int(a)}] ^ bits[{int(b)}]) ? {'-' if weight < 0 else ''}{score_width}'sd1 : {score_width}'sd0)"
             for a, b, weight in zip(graph.edge_u, graph.edge_v, graph.edge_w)]
    lines += [f'function automatic signed [{score_width-1}:0] score(input logic [{n-1}:0] bits);',
              'begin', 'score = ' + balanced_sum(terms) + ';', 'end', 'endfunction']
    lines += [f'function automatic [31:0] probability(input logic [{temperature_width-1}:0] temp,input logic signed [4:0] raw);',
              'begin', "case (integer'(temp)*17 + integer'($signed(raw)) + 8)"]
    lines += [f"{key}: probability = 32'd{value};" for key, value in probabilities.items()]
    lines += ['default: probability=0;', 'endcase', 'end', 'endfunction']
    lines += [f'function automatic [31:0] swap_threshold(input logic [{temperature_width-1}:0] left,input logic [{gap_width-1}:0] gap);',
              'begin', 'case(left)']
    for left, row in swaps.items():
        lines.append(f'{left}: begin case(gap)')
        lines += [f"{gap}: swap_threshold=32'd{value};" for gap, value in row.items()]
        lines += ['default: swap_threshold=0;', 'endcase end']
    lines += ['default: swap_threshold=0;', 'endcase', 'end', 'endfunction']
    lines += [f'function automatic [{n-1}:0] expand(input logic [{n-1}:0] mask);', 'begin']
    for node in range(n):
        lines.append(f'expand[{node}] = ' + ' | '.join(f'mask[{neighbor}]' for neighbor in (node, *graph.adjacency[node])) + ';')
    lines += ['end', 'endfunction']
    return '\n'.join(lines) + '\n'

