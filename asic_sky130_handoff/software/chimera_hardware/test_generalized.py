#!/usr/bin/env python3
"""Size, arithmetic, certificate and native-operation tests for actual offline cases."""
import importlib.util,json,sys,unittest
from pathlib import Path
import numpy as np
PACKAGE=Path(__file__).resolve().parents[2]
CASES=[PACKAGE/'cases'/f'chimera{n}' for n in (32,128,288,512,800)]

def reference(case):
    spec=importlib.util.spec_from_file_location(case.name+'_reference',case/'reference.py')
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod);return mod

class GeneralizedChimeraTests(unittest.TestCase):
    def test_source_instance_reproduction_and_certificate(self):
        sys.path.insert(0,str(PACKAGE/'software/chimera_native'))
        import frustrated_loop_instances as native
        import apt_icm
        for case in CASES:
            with self.subTest(case=case.name):
                r=reference(case);spec=r.SPEC
                made=native.make_frustrated_loop_instance(name=spec['instance'],side=spec['side'],alpha=spec['alpha'],min_loop_length=spec['min_loop_length'],max_loop_length=spec['max_loop_length'],seed=spec['generator_seed'])
                self.assertEqual(apt_icm.instance_digest(made.instance),r.GRAPH['instance_digest'])
                self.assertEqual(made.certificate,json.loads((case/'certificate.json').read_text())['certificate'])
                self.assertEqual(r.score(made.planted_bits),r.TARGET)
                self.assertTrue(all(r.COLORS[u]!=r.COLORS[v] for u,v,w in r.EDGES))

    def test_exact_field_math_and_storage_widths(self):
        for case in CASES:
            with self.subTest(case=case.name):
                r=reference(case);maximum=int(np.abs(r.ADJ).sum(axis=1).max())
                self.assertLess(maximum,128);self.assertLess(14*maximum,32768)
                self.assertLess(sum(abs(w) for _,_,w in r.EDGES),32768)
                for numerator in range(-14*maximum,14*maximum+1):
                    integer=min((4*abs(numerator)+r.NORMALIZER//2)//r.NORMALIZER,127)
                    floating=abs(int(np.clip(np.rint(8*numerator/r.FIELD_DENOMINATOR),-127,127)))
                    self.assertEqual(integer,floating)
                self.assertGreater(1/r.FIELD_DENOMINATOR,r.SPEC['field_refresh_delta'])
                self.assertEqual(len(r.LUT),128)
                manifest=json.loads((case/'asic.json').read_text())
                self.assertEqual(manifest['rng_audit']['expected_registers'],32*r.N)
                self.assertEqual(manifest['modes']['epix']['expected_icg_count'],2*r.N)
                self.assertEqual(manifest['rng_sharing']['local_engines'],r.N//32)
                self.assertEqual(manifest['rng_sharing']['stream_states'],r.N)
                self.assertEqual(manifest['rng_sharing']['variables_per_engine'],32)

    def test_service_cycles_for_empty_full_and_parallel_banks(self):
        for case in CASES:
            r=reference(case)
            spec=importlib.util.spec_from_file_location(case.name+'_vectors',case/'make_vectors.py')
            vectors=importlib.util.module_from_spec(spec)
            previous=sys.modules.get('reference')
            try:
                sys.modules['reference']=r
                spec.loader.exec_module(vectors)
            finally:
                if previous is None:sys.modules.pop('reference',None)
                else:sys.modules['reference']=previous
            def predicted(mask):
                return vectors.search_cycles(dict(seeds=np.zeros(r.N),policy_events=[(mask,None,None)]))
            with self.subTest(case=case.name):
                mask=np.zeros(len(r.GROUPS[0]),dtype=bool)
                self.assertEqual(predicted(mask),4)  # One empty update and score.
                mask[:]=True
                self.assertEqual(predicted(mask),19)  # 16 active nodes per bank.
                mask[:]=False
                for bank in range(r.N//32):
                    positions=np.flatnonzero(r.GROUPS[0]//32==bank)
                    mask[positions[-1]]=True
                self.assertEqual(predicted(mask),4)  # One request in every bank.
                mask[np.flatnonzero(r.GROUPS[0]//32==0)[0]]=True
                self.assertEqual(predicted(mask),5)  # Slowest bank has two.

    def test_native_observer_across_all_temperatures(self):
        for case in CASES:
            r=reference(case)
            for mode in ('baseline','epix'):
                with self.subTest(case=case.name,mode=mode):
                    record=r.run(17,mode,sweeps_per_beta=2,beta_count=14)
                    self.assertTrue(r.validate_native(record,sweeps_per_beta=2,beta_count=14)['passed'])
                    self.assertEqual(record['result']['visits'],28*r.N)
                    if mode=='baseline':self.assertEqual(record['result']['local_words'],28*r.N)
                    else:self.assertGreater(record['result']['cached_events'],0)

    def test_lfsr_recurrence_and_raw_word_endpoints(self):
        for case in CASES:
            r=reference(case);values=np.asarray([0,1,0x80000000,0xffffffff,0xfffffffe],dtype=np.uint32)
            self.assertEqual(r.advance(values).tolist(),[r.advance_scalar(int(x)) for x in values])
            self.assertEqual(int(r.LUT[0]),1<<31);self.assertEqual(int(r.LUT[-1]),0xffffffff)
            self.assertEqual(r.advance_scalar(0xffffffff),0xffffffff)
            _,seeds,_=r.initial(0);self.assertFalse(np.any(seeds==0xffffffff));self.assertEqual(len(seeds),r.N)

def main(case=None):
    global CASES
    if case is not None:CASES=[Path(case).resolve()]
    unittest.main(module=__name__,argv=[sys.argv[0]],verbosity=2)
if __name__=='__main__':main()
