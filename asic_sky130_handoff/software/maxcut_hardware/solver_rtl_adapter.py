"""Prepare complete sized solver RTL from the reviewed metadata-compressed source.

No import-time writes, trials, synthesis, or remote jobs. Generation requires a
fresh destination; --check verifies an existing preparation without rewriting it.
"""
from __future__ import annotations

import argparse
from collections import Counter
from datetime import datetime, timezone
import difflib
import hashlib
import json
from pathlib import Path
import re

from input_adapter import (SHARED_ROOT, SIZES, file_sha256, load_selected,
                           require, signed_width, unsigned_width)
from banked_rng import bank_solver, update_config



def sha(data):
    return hashlib.sha256(data).hexdigest()


def configuration(item):
    cfg = json.loads(json.dumps(item.configuration))
    widths, bounds = cfg['widths'], cfg['bounds']
    n, replicas = cfg['n'], cfg['replicas']['total']
    temperatures = cfg['replicas']['temperatures']
    require(cfg['replicas']['copies_per_temperature'] == 2, 'Template uses two copies')
    require(temperatures % 2 == 0 and replicas == 2 * temperatures, 'Exchange schedule needs even temperatures')
    require(cfg['colors']['count'] == 4 and cfg['colors']['node_counts'] == [n // 4] * 4,
            'Template requires balanced four-color groups')
    require(cfg['rng']['steps_per_fresh_word'] == cfg['rng']['word_bits'] == 32, 'RNG word contract changed')
    require(cfg['policies']['max_hold_age'] in (2,4), 'Unsupported age limit')
    require(min(cfg['betas']) >= cfg['policies']['field_refresh_delta'], 'Raw equality simplification does not apply')
    eligible = cfg['icm']['eligible_temperature_indices']
    require(eligible == list(range(eligible[0], temperatures)), 'ICM eligible temperatures are not a terminal interval')
    require(cfg['icm']['max_cluster_nodes'] >= cfg['icm']['max_disagreement_nodes'],
            'Cluster bound cannot be implied by the disagreement bound')
    require(cfg['maximum_sweeps'] < 2**16, 'Configured sweep limit exceeds the existing port')
    require(all(bounds['maximum_' + key] < 2**32 for key in ('local_words', 'node_visits', 'swap_words', 'icm_words')),
            'Configured counters exceed the existing ports')
    # The interface is safe even if a diagnostic uses the largest 16-bit limit.
    interface_maxima = dict(local_words=n * replicas * (2**16-1),
                           node_visits=n * replicas * (2**16-1),
                           swap_words=temperatures * (2**16-1),
                           icm_words=((2**16-1) // cfg['icm']['interval_sweeps']) * len(eligible))
    require(max(interface_maxima.values()) < 2**32, 'A legal sweep port value can overflow a counter')
    require(widths['score_difference'] == widths['score'] + 1, 'Difference extension requires one extra bit')
    require(widths['local_raw_field'] == 5 and max(item.graph.degrees) <= 8, 'Raw field contract changed')
    field_widths = [signed_width((-int(d)) // 2, int(d) // 2) for d in item.graph.degrees]
    count_width = unsigned_width(cfg['policies']['max_hold_age'])
    require(count_width in (2,3), 'Remaining-count width is unsupported')
    cfg['compressed_metadata'] = dict(remaining_bits=count_width,
        remaining_fresh=cfg['policies']['max_hold_age'], remaining_invalid_or_exhausted=0,
        remaining_reuse='decrement by one', saved_field='signed arithmetic h >>> 1',
        field_bits_by_degree={str(d): signed_width((-d)//2, d//2) for d in sorted(set(map(int, item.graph.degrees)))},
        degree_histogram={str(k): int(v) for k, v in sorted(Counter(map(int, item.graph.degrees)).items())},
        logical_bits=replicas * sum(count_width + width for width in field_widths),
        raw_field_retained_for_sampling=True)
    cfg['solver_interface'] = dict(module='corrected_solver', seed_addr_bits=widths['seed_address'],
        bank_bits=widths['replica_index'], init_word_bits=widths['init_word'], best_cut_bits=widths['score'],
        state_bits=n, state_words=n//32, sweep_port_bits=16, counter_port_bits=32, phase_bits=5, event_bits=3,
        maximum_counter_values_at_full_sweep_port=interface_maxima,
        score_initial=-(1 << (widths['score']-1)),
        icm_first_temperature=eligible[0], icm_last_temperature=eligible[-1],
        cluster_bound_implied_by_disagreement_bound=True)
    return cfg, field_widths


def generate_solver(item, template):
    cfg, field_widths = configuration(item)
    w = cfg['widths']; n = cfg['n']; replicas = cfg['replicas']['total']
    temps = cfg['replicas']['temperatures']; policy = cfg['policies']; icm = cfg['icm']
    constants = f'''    localparam integer NODE_COUNT={n}, GRAPH_WIDTH={cfg['width']};
    localparam integer REPLICAS={replicas}, TEMPERATURES={temps}, COLOR_NODES={n//4};
    localparam integer REUSE_LIMIT={policy['max_hold_age']}, REMAINING_BITS={cfg['compressed_metadata']['remaining_bits']};
    localparam integer ICM_FIRST={icm['eligible_temperature_indices'][0]}, ICM_LAST={icm['eligible_temperature_indices'][-1]};
    localparam integer ICM_INTERVAL={icm['interval_sweeps']}, ICM_MAX_DISAGREEMENT={icm['max_disagreement_nodes']};
    localparam integer POP_COUNT_BITS={w['population_count']}, FRESH_COUNT_BITS={w['fresh_words_per_color']};
    localparam logic signed [{w['score']-1}:0] SCORE_INITIAL={cfg['solver_interface']['score_initial']};
    localparam logic signed [{w['score']-1}:0] EXACT_TARGET={cfg['exact_target']};
'''
    changes = []

    def edit(before, after, count=1):
        nonlocal template
        require(template.count(before) == count, f'Unexpected template anchor count: {before!r}; expected {count}, got {template.count(before)}')
        template = template.replace(before, after)
        changes.append(dict(before=before, after=after, occurrences=count))

    edit('    input logic [7:0] seed_addr,', f"    input logic [{w['seed_address']-1}:0] seed_addr,")
    edit('    input logic [4:0] init_bank, read_bank,', f"    input logic [{w['replica_index']-1}:0] init_bank, read_bank,")
    edit('    input logic [1:0] init_word,', f"    input logic [{w['init_word']-1}:0] init_word,")
    edit('signed [9:0]', f"signed [{w['score']-1}:0]", 3)
    edit('[127:0]', f'[{n-1}:0]', 9)
    edit('    logic [4:0] phase,replica;', f"    logic [4:0] phase;\n    logic [{w['replica_index']-1}:0] replica;")
    edit('    logic [3:0] icm_temp,swap_left;', f"    logic [{w['temperature_index']-1}:0] icm_temp,swap_left;")
    edit('    `include "metadata_widths.svh"\n', '    `include "metadata_widths.svh"\n' + constants)
    edit('[0:23]', '[0:REPLICAS-1]', 5)
    edit('    wire [3:0] temperature=(replica>=12)? replica-12:replica;',
         f"    wire [{w['temperature_index']-1}:0] temperature=(replica>=TEMPERATURES)? replica-TEMPERATURES:replica;")
    edit('    wire [4:0] swap_a=(swap_copy?12:0)+swap_left;',
         f"    wire [{w['replica_index']-1}:0] swap_a=(swap_copy?TEMPERATURES:0)+swap_left;")
    edit('    wire [4:0] swap_b=swap_a+1;', f"    wire [{w['replica_index']-1}:0] swap_b=swap_a+1;")
    edit('    wire signed [10:0] cut_difference=$signed(cuts[swap_b])-$signed(cuts[swap_a]);',
         f"    wire signed [{w['score_difference']-1}:0] cut_difference="
         f"$signed({{cuts[swap_b][{w['score']-1}],cuts[swap_b]}})-$signed({{cuts[swap_a][{w['score']-1}],cuts[swap_a]}});")
    edit('cut_difference[9:0]', f"cut_difference[{w['unsigned_score_gap']-1}:0]")
    edit('icm_temp+12', 'icm_temp+TEMPERATURES', 4)
    edit('    logic [7:0] disagreement_count;', '    logic [POP_COUNT_BITS-1:0] disagreement_count;')
    edit('i<128', 'i<NODE_COUNT', 4)
    edit("{7'b0,disagreement[i]}", "{{(POP_COUNT_BITS-1){1'b0}},disagreement[i]}")
    edit("?8'd1:disagreement_count", "?POP_COUNT_BITS'(1):disagreement_count")
    edit('    logic [7:0] fresh_count;', '    logic [FRESH_COUNT_BITS-1:0] fresh_count;')
    edit("{7'b0,refresh_mask[i]}", "{{(FRESH_COUNT_BITS-1){1'b0}},refresh_mask[i]}")
    edit('read_bank<24', 'read_bank<REPLICAS')
    edit('replica==23', 'replica==REPLICAS-1', 3)
    edit('replica!=23', 'replica!=REPLICAS-1')
    edit('r<24', 'r<REPLICAS', 3)
    edit('((i/8)%2)*2+(i%2)', '((i/GRAPH_WIDTH)%2)*2+((i%GRAPH_WIDTH)%2)')
    edit('        logic [1:0] remaining[0:REPLICAS-1];', '        logic [REMAINING_BITS-1:0] remaining[0:REPLICAS-1];')
    edit('remaining[r]<=2;', "remaining[r]<=REMAINING_BITS'(REUSE_LIMIT);")
    edit('icm_temp==11', 'icm_temp==ICM_LAST')
    edit('best_cut<=-512', 'best_cut<=SCORE_INITIAL', 2)
    edit('icm_temp<=9', 'icm_temp<=ICM_FIRST', 2)
    edit('seed_addr==128', 'seed_addr==NODE_COUNT')
    edit('seed_addr==129', 'seed_addr==NODE_COUNT+1')
    edit('current_cut>=121', 'current_cut>=EXACT_TARGET', 4)
    edit('sweeps[1:0]==0', '(sweeps % ICM_INTERVAL)==0')
    edit('node_visits<=node_visits+32', 'node_visits<=node_visits+COLOR_NODES')
    edit('disagreement_count>64', 'disagreement_count>ICM_MAX_DISAGREEMENT')
    edit('swap_left+2>=11', 'swap_left+2>=TEMPERATURES-1')
    require(not re.search(r'\b(?:128|127|129|121)\b',
                         template[template.index('    localparam IDLE='):]),
            'Legacy semantic size/target/schedule literal remains in the solver body')
    require(not any(value in template for value in ('r<24', 'replica==23', 'replica!=23',
            'icm_temp+12', 'icm_temp==11', 'icm_temp<=9', 'swap_left+2>=11', 'i/8')),
            'Legacy replica, color, or temperature schedule anchor remains')
    if n >= 512:
        # Each clocked process owns scalar registers. The read arrays remain wire
        # aliases, preserving all bank/node indices and nonblocking update order.
        # This avoids treating disjoint array elements as shared clocked storage
        # during simulation elaboration; it changes no clocks or policy logic.
        edit(f'logic [{n-1}:0] spins[0:REPLICAS-1];',
             f'wire [{n-1}:0] spins[0:REPLICAS-1];')
        edit('logic [REMAINING_BITS-1:0] remaining[0:REPLICAS-1];',
             'wire [REMAINING_BITS-1:0] remaining[0:REPLICAS-1];')
        edit('logic signed [FIELD_BITS-1:0] saved_field[0:REPLICAS-1];',
             'wire signed [FIELD_BITS-1:0] saved_field[0:REPLICAS-1];')
        begin = template.index('        for(genvar r=0;r<REPLICAS;r=r+1) begin: storage')
        end = template.index('    task automatic begin_swaps;', begin)
        before = template[begin:end]
        after = before.replace('spins[r][i]<=', 'spin_reg<=')
        after = after.replace('remaining[r]', 'remaining_reg').replace('saved_field[r]', 'saved_field_reg')
        after = after.replace('begin: storage\n', '''begin: storage
            logic spin_reg;
            logic [REMAINING_BITS-1:0] remaining_reg;
            logic signed [FIELD_BITS-1:0] saved_field_reg;
            assign spins[r][i]=spin_reg;
            assign remaining[r]=remaining_reg;
            assign saved_field[r]=saved_field_reg;
''')
        require(before.count('spins[r][i]<=') == 6, 'Unexpected spin register writers')
        require(before.count('remaining[r]') == 8, 'Unexpected reuse counter references')
        require(before.count('saved_field[r]') == 3, 'Unexpected saved field writers')
        edit(before, after)
        cfg['storage_ownership'] = 'scalar registers per lane and replica; indexed wire read aliases'
    require(template.count('sky130_fd_sc_hd__dlclkp_1') == 2, 'Clock gate topology changed')
    template = bank_solver(template, n)
    cfg = update_config(cfg)
    changes.append(dict(change='one RNG transform per 32 nodes; independent stream states retained'))
    return template, cfg, field_widths, changes
