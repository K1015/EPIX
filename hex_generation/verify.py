#!/usr/bin/env python3
"""Compare regenerated tables with both policies and check input format limits."""
import copy
import json
from pathlib import Path
import re
import tempfile
import unittest

from generate import clause_tables, generate, graph_tables, read_problem

HERE = Path(__file__).resolve().parent
HANDOFF = HERE.parent if (HERE.parent / 'maxcut26').is_dir() else HERE.parent / 'pynq_z1_handoff'


class TableChecks(unittest.TestCase):
    def test_existing_rtl_tables(self):
        compared = 0
        with tempfile.TemporaryDirectory() as directory:
            for family in ('maxcut', 'chimera', 'sat', 'xorsat'):
                with self.subTest(family=family):
                    suffix = '.cnf' if family == 'sat' else '.json'
                    source = HERE / 'examples' / (family + '26' + suffix)
                    output = Path(directory) / family
                    generate(family, source, output)
                    for policy in ('lfsr_iid', 'lfsr_epix'):
                        rtl = HANDOFF / (family + '26') / policy / 'vivado/ip_repo/maxcut26/src'
                        for path in sorted(output.glob('*.hex')):
                            self.assertEqual(path.read_bytes(), (rtl / path.name).read_bytes(), str(path))
                            compared += 1
                        if family in ('sat', 'xorsat'):
                            expected = (rtl / 'categorical_solver.sv').read_text()
                            generated = (output / 'clauses.svh').read_text()
                            pattern = r"16'd(\d+): clause_rom=24'h([0-9a-f]+);"
                            self.assertEqual(re.findall(pattern, generated), re.findall(pattern, expected))
                            self.assertEqual(re.search(r'CLAUSES=(\d+)', generated).group(1),
                                             re.search(r'CLAUSES=(\d+)', expected).group(1))
        self.assertEqual(compared, 16)

    def test_graph_format_limits(self):
        lut = json.loads((HERE / 'lut32.json').read_text())
        examples = [
            {'n_pbits': 2, 'J': [[0, 8], [8, 0]]},
            {'n_pbits': 2, 'J': [[0, 1], [0, 0]]},
            {'n_pbits': 2, 'J': [[0, 1], [1, 0]], 'h': [1, 0]},
            {'n_pbits': 2, 'edges': [[0, 1, 1], [1, 0, 1]]},
            {'n_pbits': 11, 'J': [[0 if i == j else 7 for j in range(11)] for i in range(11)]},
        ]
        for problem in examples:
            with self.subTest(problem=problem), self.assertRaises(ValueError):
                graph_tables(problem, lut)

    def test_cut_edge_sign(self):
        lut = json.loads((HERE / 'lut32.json').read_text())
        files, _ = graph_tables({'n_pbits': 2, 'edges': [[0, 1, 3]]}, lut)
        self.assertEqual(files['weights.hex'], '0\nd\nd\n0\n')

    def test_clause_format_limits(self):
        examples = [
            {'n_pbits': 3, 'clauses': [[1, 1, -2]]},
            {'n_pbits': 3, 'clauses': [[1, 2, 4]]},
            {'n_pbits': 129, 'clauses': [[1, 2, 3]]},
            {'n_pbits': 3, 'clauses': [[1, 2, 3], *[[-1, 2, 3]] * 16]},
        ]
        for problem in examples:
            with self.subTest(problem=problem), self.assertRaises(ValueError):
                clause_tables(problem, 4)

    def test_five_bit_mass_table_preserves_shared_entries(self):
        problem = {'n_pbits': 3, 'clauses': [[1, 2, 3]]}
        small, _ = clause_tables(problem, 4)
        large, _ = clause_tables(problem, 5)
        a, b = small['masses.hex'].splitlines(), large['masses.hex'].splitlines()
        self.assertEqual(len(b), 32768)
        for i, entry in enumerate(a):
            address = ((i >> 8) << 10) | (((i >> 4) & 15) << 5) | (i & 15)
            self.assertEqual(entry, b[address])
        expanded = copy.deepcopy(problem)
        expanded['clauses'] += [[-1, 2, 3]] * 16
        _, parameters = clause_tables(expanded, 5)
        self.assertEqual(parameters['maximum_candidate_break'], 16)

    def test_dimacs_multiline_clauses(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'example.cnf'
            source.write_text('c example\np cnf 3 2\n1 -2\n3 0 -1 2 -3 0\n')
            self.assertEqual(read_problem(source)['clauses'], [[1, -2, 3], [-1, 2, -3]])
            source.write_text('p cnf 3 1\n1 2 3\n')
            with self.assertRaises(ValueError):
                read_problem(source)


if __name__ == '__main__':
    unittest.main(verbosity=2)
