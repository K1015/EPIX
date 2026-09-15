#!/usr/bin/env python3
"""Exercise real Chimera RTL at valid, directed cache states before an update."""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import random
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
CASE = ROOT / 'cases/chimera128'
LAST_RECEIPT = None


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def advance(value):
    for _ in range(32):
        bit = 1 ^ ((value >> 31) ^ (value >> 21) ^ (value >> 1) ^ value) & 1
        value = ((value << 1) | bit) & 0xffffffff
    return value


def packed(values, width=1):
    return sum((int(value) & ((1 << width) - 1)) << (width * i) for i, value in enumerate(values))


def literal(values, width=1):
    return f"{len(values) * width}'h{packed(values, width):x}"


def make_testbench():
    graph = json.loads((CASE / 'graph.json').read_text())
    n = graph['n']
    selected = [i for i, color in enumerate(graph['colors']) if color == 0]
    banks = [[i for i in selected if i // 32 == bank] for bank in range(4)]
    random_bits = random.Random(20260915)
    state = [random_bits.randrange(2) for _ in range(n)]
    fields = [0] * n
    for u, v, weight in graph['edges']:
        fields[u] -= weight * (2 * state[v] - 1)
        fields[v] -= weight * (2 * state[u] - 1)
    # No edge joins two selected nodes, so these assignments preserve their fields.
    for node in selected:
        state[node] = int(fields[node] >= 0)
    normalizer = max(abs(weight) for _, _, weight in graph['edges'])
    thresholds = []
    for value in fields:
        address = min((4 * abs(value) + normalizer // 2) // normalizer, 127)
        thresholds.append(min(round(2**32 / (1 + math.exp(-address / 4))), 2**32 - 1))
    patterns = [
        ('no_requests', []),
        ('lane_31', [31]),
        ('one_per_bank', [bank[-1] for bank in banks]),
        ('uneven_8_1_0_5', banks[0][:8] + banks[1][:1] + banks[3][:5]),
        ('all_selected', selected),
        ('last_bank_only', banks[-1]),
        ('no_requests_after_activity', []),
    ]
    seeds = [(0x12345678 + 7919 * i) & 0xffffffff for i in range(n)]
    lines, rounds = [], []
    for label, requests in patterns:
        requests = set(requests)
        assert requests <= set(selected)
        # A reusable word must also reproduce the spin stored by its prior refresh.
        for node in set(selected) - requests:
            sample = int(seeds[node] < thresholds[node] if fields[node] >= 0
                         else seeds[node] > thresholds[node])
            if sample != state[node]:
                seeds[node] = node + 1
            assert int(seeds[node] < thresholds[node] if fields[node] >= 0
                       else seeds[node] > thresholds[node]) == state[node]
        remaining = [0] * n
        saved = [0] * n
        for node in selected:
            remaining[node] = 0 if node in requests else 2
            saved[node] = fields[node]
        lines += [f'// {label}', 'rst=1; start=0; seed_we=0; init_we=0; tick(); rst=0; seed_we=1;']
        for node, value in enumerate(seeds):
            lines += [f"seed_addr=7'd{node}; data_in=32'h{value:08x}; tick();"]
        lines += ['seed_we=0; init_we=1;']
        for word in range(4):
            lines += [f"init_word=2'd{word}; data_in={literal(state[word * 32:(word + 1) * 32])}; tick();"]
        lines += ['init_we=0;', f'if(rng_all!=={literal(seeds,32)}) $fatal(1,"seed address mismatch: {label}");',
                  'start=1; tick(); start=0; tick();',
                  f'if(phase!==3\'d2) $fatal(1,"not in update: {label}");']
        # Cache registers are initialized once; requests, gates and controller remain unforced.
        for node in selected:
            lines += [f'dut.lane[{node}].remaining=2\'d{remaining[node]};',
                      f"dut.lane[{node}].saved_numerator=16'h{saved[node] & 0xffff:04x};"]
        lines += ['#1;', f"if(dut.refresh_mask!==128'h{sum(1 << node for node in requests):x}) $fatal(1,\"invalid cache setup: {label}\");"]
        waiting = [[node for node in bank if node in requests] for bank in banks]
        cycles = max(1, max(map(len, waiting)))
        current = list(seeds)
        expected_words = list(seeds)
        for node in requests:
            expected_words[node] = advance(seeds[node])
        expected_state = list(state)
        fire_count = 0
        for node in selected:
            sample = int(expected_words[node] < thresholds[node] if fields[node] >= 0
                         else expected_words[node] > thresholds[node])
            expected_state[node] = sample
            fire_count += node in requests or sample != state[node]
        for cycle in range(cycles):
            final = cycle == cycles - 1
            visible = list(current)
            for bank in waiting:
                if cycle < len(bank):
                    node = bank[cycle]
                    visible[node] = advance(current[node])
            lines += [f"if(dut.commit!==1'b{int(final)}) $fatal(1,\"commit latency: {label}/{cycle}\");",
                      f'if(sample_all!=={literal(visible,32)}) $fatal(1,"word bypass: {label}/{cycle}");',
                      'tick();']
            current = visible
            lines += [f'if(rng_all!=={literal(current,32)}) $fatal(1,"RNG sequence: {label}/{cycle}");']
            if not final:
                lines += [f'if(state_read!=={literal(state)}) $fatal(1,"spin changed before commit: {label}");',
                          f'if(remaining_all!=={literal(remaining,2)} || saved_all!=={literal(saved,16)}) $fatal(1,"cache changed before commit: {label}");',
                          f'if(words!=0 || visits!=0 || fired!=0 || phase!=2) $fatal(1,"accounting changed before commit: {label}");']
        expected_remaining = [2 if node in requests else 1 if node in selected else 0 for node in range(n)]
        lines += [f'if(state_read!=={literal(expected_state)}) $fatal(1,"committed sample: {label}");',
                  f'if(remaining_all!=={literal(expected_remaining,2)} || saved_all!=={literal(saved,16)}) $fatal(1,"cache commit: {label}");',
                  f'if(words!={len(requests)} || visits!=64 || fired!={fire_count} || phase!=3) $fatal(1,"commit accounting: {label}");',
                  'tick();',
                  f'if(rng_all!=={literal(current,32)} || words!={len(requests)} || visits!=64 || fired!={fire_count}) $fatal(1,"extra service after commit: {label}");']
        rounds.append(dict(name=label, requests=len(requests), bank_requests=list(map(len, waiting)),
                           service_cycles=cycles, fired_updates=fire_count))
        seeds = current
    body = '\n'.join(lines)
    testbench = f'''`timescale 1ns/1ps
module chimera_bank_test;
    logic clk=0,rst=1,start=0,seed_we=0,init_we=0;
    logic [6:0] seed_addr=0;
    logic [1:0] init_word=0;
    logic [31:0] data_in=0;
    wire [127:0] state_read;
    wire [31:0] words,visits,fired;
    wire [2:0] phase;
    wire [4095:0] rng_all,sample_all;
    wire [255:0] remaining_all;
    wire [2047:0] saved_all;
    chimera_solver #(.EPIX_ENABLE(1),.SWEEPS_PER_BETA(1),.BETA_COUNT(1)) dut(
        .clk,.rst,.start,.seed_we,.init_we,.seed_addr,.init_word,.data_in,.state_read,
        .local_words(words),.node_visits(visits),.fired_cycles(fired),.phase_out(phase),
        .done(),.success(),.final_success(),.sweeps(),.best_cut(),.final_cut(),
        .first_exact_sweep(),.witness(),.event_out());
    for(genvar i=0;i<128;i=i+1) begin: observe
        assign rng_all[i*32+:32]=dut.lane[i].rng_state;
        assign sample_all[i*32+:32]=dut.lane[i].sample_word;
        assign remaining_all[i*2+:2]=dut.lane[i].remaining;
        assign saved_all[i*16+:16]=dut.lane[i].saved_numerator;
    end
    task tick;
        begin clk=0; #1; clk=1; #1; clk=0; #1; end
    endtask
    initial begin
        {body}
        $display("CHIMERA_BANK_PASS rounds={len(rounds)}");
        $finish;
    end
endmodule
'''
    return testbench, rounds


def check(verilator):
    sources = [CASE / 'graph.json', *sorted((CASE / 'rtl/epix').glob('*.sv*'))]
    before = {str(path.relative_to(ROOT)): sha(path) for path in sources}
    text, rounds = make_testbench()
    with tempfile.TemporaryDirectory(prefix='chimera-bank-directed-') as temporary:
        work = Path(temporary)
        source = work / 'test.sv'
        source.write_text(text)
        command = [verilator, '--binary', '--timing', '-Wno-fatal', '--top-module',
                   'chimera_bank_test', '--Mdir', str(work / 'obj'), '-j', '2',
                   '-I' + str(CASE / 'rtl/epix'), str(source),
                   str(CASE / 'rtl/epix/solver.sv'), str(CASE / 'rtl/epix/clock_gate_sim.sv')]
        built = subprocess.run(command, capture_output=True, text=True, timeout=180)
        if built.returncode:
            raise AssertionError(built.stdout + built.stderr)
        result = subprocess.run([str(work / 'obj/Vchimera_bank_test')], capture_output=True,
                                text=True, timeout=30)
        if result.returncode or 'CHIMERA_BANK_PASS' not in result.stdout:
            raise AssertionError(result.stdout + result.stderr)
    if before != {str(path.relative_to(ROOT)): sha(path) for path in sources}:
        raise AssertionError('Solver source changed during the test')
    return dict(passed=True, case_id='chimera128', mode='epix', rounds=rounds, source_sha256=before,
                test_source_sha256=sha(Path(__file__)), generated_testbench_sha256=hashlib.sha256(text.encode()).hexdigest(),
                verilator_version=subprocess.check_output([verilator, '--version'], text=True).strip(),
                checks=['seed addresses across 31/32 and every bank', 'independent RNG sequences',
                        'empty and unequal request banks', 'final-word bypass', 'spin/cache/counter stability before commit',
                        'one commit with exact word/visit/fire counts', 'no extra RNG service during score'],
                scope='Actual unmodified solver RTL. Spins/seeds load through ports; only cache age/field registers '
                      'are initialized at the first update to valid directed EPIX decisions. Every reusable word reproduces its stored spin. This is not a whole-search trial.',
                output=result.stdout.strip())


class ChimeraBankRTLTests(unittest.TestCase):
    def test_actual_rtl_requests_and_commit(self):
        global LAST_RECEIPT
        tool = shutil.which(os.environ.get('VERILATOR', 'verilator'))
        if not tool:
            self.skipTest('Verilator is required for the directed RTL test')
        LAST_RECEIPT = check(tool)
        self.assertTrue(LAST_RECEIPT['passed'])


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    options, remaining = parser.parse_known_args()
    import sys
    result = unittest.main(argv=[sys.argv[0], *remaining], exit=False).result
    if options.output and LAST_RECEIPT and result.wasSuccessful():
        options.output.parent.mkdir(parents=True, exist_ok=True)
        options.output.write_text(json.dumps(LAST_RECEIPT, indent=2) + '\n')
    raise SystemExit(0 if result.wasSuccessful() else 1)
