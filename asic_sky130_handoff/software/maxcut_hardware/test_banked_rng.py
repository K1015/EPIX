#!/usr/bin/env python3
"""Check the actual bank-service RTL against independent scalar RNG results."""
import os
from pathlib import Path
import random
import shutil
import subprocess
import tempfile
import unittest

from banked_rng import service_block
from reference_adapter import scalar_lfsr_step


def next_word(value):
    for _ in range(32):
        value = scalar_lfsr_step(value)
    return value


def testbench(nodes):
    masks = [0, 1, 1 << (nodes - 1), (1 << nodes) - 1,
             sum(1 << i for i in range(min(31, nodes))),
             (1 << 31) | (1 << (32 if nodes > 32 else 0))]
    random_masks = random.Random(20260915)
    masks += [random_masks.getrandbits(nodes) for _ in range(12)]
    expected = [(0x12345678 + 7919 * i) & 0xffffffff for i in range(nodes)]
    commands = [f"seed_addr={i}; data_in=32'h{value:08x}; tick();"
                for i, value in enumerate(expected)]
    commands += ["seed_we=0;"]
    for index, mask in enumerate(masks):
        clocks = max(1, max(((mask >> i) & 0xffffffff).bit_count()
                            for i in range(0, nodes, 32)))
        commands += [f"phase=LOCAL; refresh_mask={nodes}'h{mask:x}; elapsed=0; #1;",
                     "while(!local_commit) begin tick(); elapsed=elapsed+1;",
                     'if(elapsed>32) $fatal(1,"bank service failed to finish"); end']
        for i in range(nodes):
            if mask & (1 << i):
                expected[i] = next_word(expected[i])
            commands += [f"if(local_rng_word[{i}]!==32'h{expected[i]:08x}) "
                         f'$fatal(1,"word mismatch round {index} node {i}");']
        commands += [f'if(elapsed+1!={clocks}) $fatal(1,"service latency mismatch");',
                     "tick(); phase=IDLE; refresh_mask=0; tick();"]
    return f'''module bank_test;
    localparam IDLE=0, LOCAL=2;
    logic clk=0, rst=1, seed_we=0;
    logic [4:0] phase=IDLE;
    logic [15:0] seed_addr=0;
    logic [31:0] data_in=0;
    logic [{nodes-1}:0] refresh_mask=0;
    integer elapsed;
    function automatic [31:0] advance(input logic [31:0] value);
        reg [31:0] x;
        begin
            x=value;
            for(integer k=0;k<32;k=k+1)
                x={{x[30:0],~(x[31]^x[21]^x[1]^x[0])}};
            advance=x;
        end
    endfunction
{service_block(nodes)}
    task tick;
        begin clk=0; #1; clk=1; #1; clk=0; #1; end
    endtask
    initial begin
        tick(); rst=0; seed_we=1;
        {chr(10).join(commands)}
        $display("BANK_SERVICE_PASS nodes={nodes} rounds={len(masks)}");
        $finish;
    end
endmodule
'''


class BankServiceTests(unittest.TestCase):
    def test_invalid_bank_dimensions(self):
        for nodes in (0, 31, 33, -32):
            with self.assertRaises(ValueError):
                service_block(nodes)

    def test_rtl_streams_and_commit(self):
        tool = shutil.which(os.environ.get('VERILATOR', 'verilator'))
        if not tool:
            self.skipTest('Verilator is needed for the bank-service RTL test')
        for nodes in (32, 64):
            with self.subTest(nodes=nodes), tempfile.TemporaryDirectory(prefix='maxcut-rng-bank-') as temp:
                work = Path(temp)
                source = work / 'bank_test.sv'
                source.write_text(testbench(nodes))
                command = [tool, '--binary', '--timing', '-Wno-fatal', '--top-module',
                           'bank_test', '--Mdir', str(work / 'obj'), '-j', '2', str(source)]
                build = subprocess.run(command, text=True, capture_output=True, timeout=180)
                self.assertEqual(build.returncode, 0, build.stdout + build.stderr)
                result = subprocess.run([str(work / 'obj/Vbank_test')], text=True,
                                        capture_output=True, timeout=30)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertIn('BANK_SERVICE_PASS', result.stdout)


if __name__ == '__main__':
    unittest.main(verbosity=2)
