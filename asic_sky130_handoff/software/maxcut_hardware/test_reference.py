#!/usr/bin/env python3
import unittest
import numpy as np
from input_adapter import SIZES,load_selected,seed_words
from reference_adapter import advance_words,draw_indexed,scalar_lfsr_step,ReferenceRunner

class SizedReferenceTests(unittest.TestCase):
    def test_selected_inputs_and_exact_witnesses(self):
        for n in SIZES:
            item=load_selected(n)
            self.assertEqual(item.specification['index'],0)
            self.assertEqual(item.verification['witness_edge_score'],item.specification['target'])
            self.assertEqual(item.verification['witness_adjacency_score'],item.specification['target'])

    def test_dimensions_and_counter_ranges(self):
        expected={32:(24,128),288:(32,1024),512:(48,4096),800:(64,4096)}
        for n,(replicas,budget) in expected.items():
            cfg=load_selected(n).configuration
            self.assertEqual((cfg['replicas']['total'],cfg['maximum_sweeps']),(replicas,budget))
            self.assertEqual(cfg['colors']['node_counts'],[n//4]*4)
            self.assertLess(n*replicas*65535,2**32)
            self.assertEqual(cfg['loading']['initialization_words_total'],replicas*n//32)

    def test_compressed_fields_are_lossless_for_every_degree(self):
        for n in SIZES:
            graph=load_selected(n).graph
            for degree in set(map(int,graph.degrees)):
                values=list(range(-degree,degree+1,2))
                self.assertEqual(len({v>>1 for v in values}),len(values))

    def test_affine_rng_matches_scalar_recurrence(self):
        words=np.array([0,1,0xffffffff,0x12345678,0x80000000],dtype=np.uint64)
        for stride in (1,32):
            expected=[]
            for value in words:
                for _ in range(stride):value=scalar_lfsr_step(value)
                expected.append(value)
            np.testing.assert_array_equal(advance_words(words,stride),expected)

    def test_repeated_node_draws_preserve_request_order(self):
        seeds=seed_words(32,1234,2);actual=seeds.copy();expected=seeds.copy()
        indices=[2,0,2,2,0,31,2,31];golden=[]
        for i in indices:
            value=int(expected[i])
            for _ in range(32):value=scalar_lfsr_step(value)
            expected[i]=value;golden.append(value)
        np.testing.assert_array_equal(draw_indexed(actual,indices),golden)
        np.testing.assert_array_equal(actual,expected)

    def test_trial_pairing_and_native_reuse_audit(self):
        runner=ReferenceRunner(32)
        baseline=runner.run(0,'baseline');epix=runner.run(0,'epix')
        self.assertEqual(baseline['initial_state_sha256'],epix['initial_state_sha256'])
        self.assertTrue(baseline['reuse_audit']['passed'] and epix['reuse_audit']['passed'])
        self.assertTrue(baseline['final_state_digest_verified'] and epix['final_state_digest_verified'])

if __name__=='__main__':unittest.main()
