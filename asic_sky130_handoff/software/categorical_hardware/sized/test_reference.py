#!/usr/bin/env python3
"""Directed arithmetic, policy-boundary, and update-order tests."""
import itertools
import importlib.util
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
from reference import RandomSource, Reference, conditioned, masses, read_cnf


class ReferenceTests(unittest.TestCase):
    def test_zero_seed_defined_and_rng_known_answer(self):
        zero, one = RandomSource(0), RandomSource(1)
        expected = [135184, 33817344, 1323717730, 153799847, 1199344616]
        self.assertEqual([zero.word() for _ in expected], expected)
        self.assertEqual([one.word() for _ in expected], expected)

    def test_equal_masses_lowest_index_tie(self):
        self.assertEqual(masses([0,0,0]), [21846,21845,21845])

    def test_all_masses_positive_and_exact_total(self):
        for b in itertools.product(range(17), repeat=3):
            w = masses(b)
            self.assertEqual(sum(w), 65536)
            self.assertGreater(min(w), 0)

    def test_categorical_interval_boundaries(self):
        w = [1,32767,32768]
        def forbidden():
            self.fail("Unexpected source draw")
        for value, chosen, residual, span in [(0,0,0,1), (1,1,0,32767),
             (32767,1,32766,32767), (32768,2,0,32768), (65535,2,32767,32768)]:
            self.assertEqual(conditioned(value,65536,w,forbidden), (chosen,residual,span))

    def test_rejected_tail_requires_refill(self):
        draws=[]
        def source():
            draws.append(0)
            return 0
        # 65536 is the one unused integer, giving value0/range1 after rejection.
        self.assertEqual(conditioned(65536,65537,[1,1,65534],source), (0,0,32768))
        self.assertEqual(draws,[0])

    def test_maximum_refill_fits_47_bits(self):
        chosen, value, span = conditioned(65534,65535,[1,1,65534],lambda:2147483647)
        self.assertIn(chosen,(0,1,2))
        self.assertTrue(0 <= value < span < 2**47)

    def test_age_refresh_boundary(self):
        model=Reference([(1,2,3)],1,"epix",n=128)
        model.bits=[0]*128; model.true=[0]; model.false=[0]; model.where={0:0}
        model.ages[0]=253;model.values[0]=0;model.ranges[0]=2**31
        model.step()
        self.assertEqual((model.age,model.raw,model.reuse),(254,0,1))
        model.bits=[0]*128; model.true=[0]; model.false=[0]; model.where={0:0}
        model.step()
        self.assertEqual((model.age,model.raw,model.reuse),(0,1,1))

    def test_zero_budget_only_initializes(self):
        model=Reference([(1,2,3)],1,"epix",n=128)
        events=list(model.run(0))
        self.assertEqual(len(events),1)
        self.assertEqual((model.flips,model.raw,model.source.calls),(0,0,128))

    def test_actual_input_incremental_counts_after_each_flip(self):
        root=Path(__file__).resolve().parents[3]
        for case in ("sat128","xorsat128"):
            _,clauses=read_cnf(root/"cases"/case/"input.cnf")
            model=Reference(clauses,7,"epix",n=128)
            for _ in range(100):
                if not model.false:
                    break
                model.step();model.verify_assignment()

    def test_assignment_packing_all_sizes(self):
        for n in (32,128,288,512,800):
            model=Reference([(1,2,n)],17,"epix",n=n)
            packed=model.event(1)[1:1+n//32]
            recovered=[(packed[j//32]>>(j%32))&1 for j in range(n)]
            self.assertEqual(recovered,model.bits)
            self.assertEqual(model.source.calls,n)

    def test_128_event_compatibility(self):
        old_path=Path(__file__).resolve().parents[1]/"reference.py"
        spec=importlib.util.spec_from_file_location("original128_reference",old_path)
        old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
        root=Path(__file__).resolve().parents[3]
        for case in ("sat128","xorsat128"):
            _,clauses=read_cnf(root/"cases"/case/"input.cnf")
            for mode in ("baseline","epix"):
                expected=list(old.Reference(clauses,42,mode).run(500))
                actual=list(Reference(clauses,42,mode,n=128).run(500))
                self.assertEqual(actual,expected)


if __name__ == "__main__":
    unittest.main()
