#!/usr/bin/env python3
"""Synthetic tests only: no fixture is a measured ASIC result or published artifact.

All test records, evidence placeholders, traces and outputs use temporary folders.
Run from the package root: python3 validation/test_energy_reporting.py
"""
from __future__ import annotations

import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import tempfile
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "flow"))


def module(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "flow" / (name + ".py"))
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


report = module("report_energy")
activity = module("activity")


class EnergyReportingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="synthetic-asic-energy-test-")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.record = self.fixture()

    def fixture(self):
        checks = dict.fromkeys(("rtl_match", "mapped_match", "setup", "hold", "max_capacitance",
                               "max_transition", "constraint_coverage", "all_cell_pin_activity",
                               "zero_unknown_activity", "power_activity_readback"), True)
        trials = [{"trial": i, "seed": 42+i, "initial_state_sha256": str(i%2+1)*64,
                   "success": i%2 == 0, "search_cycles": 10 if i%2 == 0 else 30,
                   "setup_cycles": 2, "fresh_words": 100 if i%2 == 0 else 200} for i in range(32)]
        configs = {}
        for mode, multiplier in (("baseline", 1), ("epix", 1.5)):
            power = {"internal": 0.002*multiplier, "switching": 0.001*multiplier,
                     "leakage": 0.001*multiplier, "total": 0.004*multiplier}
            configs[mode] = dict(evidence={}, checks=dict(checks), trials=copy.deepcopy(trials), area_um2=100.0,
                windows={"search":dict(duration_ns=64000,power_w=dict(power)),
                         "with_setup":dict(duration_ns=70400,power_w=dict(power))})
        record = dict(schema="asic_energy_v1", status="complete", case_id="SYNTHETIC_TEST_ONLY",
            technology=dict(id="SYNTHETIC_TEST_ONLY",liberty_sha256="a"*64),period_ns=100,
            measurement_model="prelayout_zero_delay",activity_population="paired_predeclared",
            boundary="SYNTHETIC ARITHMETIC TEST",trial_ids=list(range(32)),configurations=configs)
        self.sync_evidence(record)
        return record

    def sync_evidence(self, record=None):
        """Construct internally bound SYNTHETIC receipts, never hardware evidence.

        Arithmetic-only tests call this after deliberately changing their fixture.
        Tamper-rejection tests leave the original bytes untouched.
        """
        record = self.record if record is None else record
        for mode, c in record['configurations'].items():
            folder=self.base/mode;folder.mkdir(exist_ok=True)
            c['evidence']={}
            def add(category,name,value):
                path=folder/(category+'_'+name)
                path.write_text(value if isinstance(value,str) else json.dumps(value,sort_keys=True))
                digest=hashlib.sha256(path.read_bytes()).hexdigest()
                c['evidence'].setdefault(category,[]).append(dict(path=str(path.relative_to(self.base)),sha256=digest))
                return digest
            model=dict(compare_fields=['trial','success','local_words'],fresh_word_fields=['local_words'],setup_rng_words=2)
            asic_sha=add('source','asic.json',dict(simulation=model))
            source_sha=add('source','solver.sv','// SYNTHETIC TEST PLACEHOLDER, NOT A DESIGN\n')
            add('inputs','metadata.json',dict(case_id=record['case_id']))
            library_sha=add('technology','cells.lib','SYNTHETIC LIBERTY PLACEHOLDER, NO PHYSICAL TABLES\n')
            record['technology']['liberty_sha256']=library_sha
            tech_sha=add('technology','config.json',dict(id=record['technology']['id']))
            spec=dict(smoke=False,case_id=record['case_id'],boundary=record['boundary'],
                      measurement_model=record['measurement_model'],technology_sha256=tech_sha,trials=len(record['trial_ids']),
                      trial_ids=record['trial_ids'],fresh_words=dict(counter_fields=['local_words'],setup_words=2))
            add('run_spec','RUN_SPEC.json',spec)
            source_map={'solver.sv':source_sha}
            outcomes=[dict(trial=i,seed=42+i,initial_state_sha256=str(i%2+1)*64) for i in range(1000)]
            for trial in c['trials']:outcomes[trial['trial']].update(seed=trial['seed'],initial_state_sha256=trial['initial_state_sha256'])
            vector=dict(passed=True,mode=mode,trials=1000,sha256='b'*64,sources=source_map,outcomes=outcomes)
            add('inputs',mode+'.json',vector)
            headings=['trial','setup_begin','search_begin','end','success','local_words']
            rows=[];cursor=0
            for trial in c['trials']:
                begin=cursor+trial['setup_cycles'];end=begin+trial['search_cycles']
                rows.append([trial['trial'],cursor,begin,end,int(trial['success']),trial['fresh_words']-2]);cursor=end
            rtl_rows=copy.deepcopy(rows)
            for i in range(len(rows),1000):
                rtl_rows.append([i,cursor,cursor+2,cursor+12,1,98]);cursor+=12
            table=lambda values:'\t'.join(headings)+'\n'+''.join('\t'.join(map(str,row))+'\n' for row in values)
            gate_sha=add('mapped_validation','trials.tsv',table(rows))
            rtl_sha=add('rtl_validation','trials.tsv',table(rtl_rows))
            mapped_sha=add('mapped_validation','mapped.v','// SYNTHETIC MAPPED NETLIST PLACEHOLDER\n')
            add('mapped_validation','validation.json',dict(passed=True,trials=len(rows),receipt_sha256=gate_sha,vector_sha256='b'*64,sources={'mapped.v':mapped_sha}))
            add('rtl_validation','validation.json',dict(passed=True,trials=1000,vector_sha256='b'*64,receipt_sha256=rtl_sha,sources=source_map))
            binding=dict(case_manifest_sha256=asic_sha,source_sha256=source_map,technology_config_sha256=tech_sha)
            fingerprint=hashlib.sha256(json.dumps(binding,sort_keys=True).encode()).hexdigest()
            resolved=dict(case_name=record['case_id'],mode=mode,binding=binding,design_fingerprint=fingerprint,
                config=dict(id=record['technology']['id'],liberty_sha256=record['technology']['liberty_sha256'],clock=dict(period_ns=record['period_ns'])))
            add('mapped_validation','resolved.json',resolved)
            stat_sha=add('mapped_validation','stat.json',dict(design=dict(area=c['area_um2'])))
            synth_sha=add('mapped_validation','synthesis.json',dict(passed=True,design_fingerprint=fingerprint,
                outputs_sha256={'stat.json':stat_sha},netlist_audit=dict(local_rng_registers=0)))
            add('timing','timing_validation.json',dict(passed=True,design_fingerprint=fingerprint,binding=binding,
                checks=dict.fromkeys(['setup','hold','max_capacitance','max_transition','constraint_coverage'],True),
                hashes={'synthesis.json':synth_sha}))
            expected_activity = {}
            bound_counts = {}
            for window,w in c['windows'].items():
                counts = dict(trial_count=len(rows), duration_ps=w['duration_ns']*1000,
                              cell_pins=2, input_ports=1, annotated_targets=3,
                              root_clock=dict(density_hz=2e9/record['period_ns'], duty=0.5))
                expected_activity[window] = counts
                bound_counts[window + '.counts.json'] = add('activity',window+'.counts.json',counts)
                add('power',window+'.power.txt','SYNTHETIC UNIT TEST ONLY\nPower (Watts)\nTotal '+
                    ' '.join(str(w['power_w'][k]) for k in ['internal','switching','leakage','total'])+'\n')

            log = ''.join(f"ACTIVITY_READBACK\t{window}\t{phase}\t3\t2\t1\t0\t{2e9/record['period_ns']}\t0.5\tclock\n"
                          for window in ('search', 'with_setup') for phase in ('total', 'rng'))
            log_sha = add('power', 'power.log', log)
            readback = activity.validate_readback(log, expected_activity)
            readback.update(log_sha256=log_sha, input_hashes=bound_counts)
            add('activity', 'activity_readback.json', readback)

    def summarize(self):
        return report.summarize(self.record, self.base)

    def test_negative_saving_is_preserved(self):
        result = self.summarize()
        self.assertAlmostEqual(result["search_energy_saving_percent"], -50)
        self.assertAlmostEqual(result["setup_inclusive_energy_saving_percent"], -50)
        self.assertIn("-50.000000%", report.render(result))

    def test_zero_baseline_energy_renders_unresolved(self):
        for window in self.record["configurations"]["baseline"]["windows"].values():
            window["power_w"] = dict.fromkeys(("internal", "switching", "leakage", "total"), 0)
        self.sync_evidence()
        result = self.summarize()
        self.assertIsNone(result["setup_inclusive_energy_saving_percent"])
        self.assertIn("Unresolved", report.render(result))

    def test_pooled_watts_times_ns_is_mean_nj(self):
        result = self.summarize()["configurations"]["baseline"]
        # 0.004 W * 64000 ns / 32 = 8 nJ; setup adds 0.8 nJ per attempt.
        self.assertAlmostEqual(result["mean_energy_nj"]["search"]["total"], 8)
        self.assertAlmostEqual(result["mean_energy_nj"]["with_setup"]["total"], 8.8)
        self.assertAlmostEqual(result["expected_energy_to_success_nj"], 17.6)
        self.assertEqual(result["successes"], 16)
        self.assertEqual(result["trials"], 32)

    def test_unequal_mode_durations_use_their_own_activity(self):
        epix = self.record["configurations"]["epix"]
        for trial in epix["trials"]:
            if trial["trial"] % 2:trial["search_cycles"] = 70
        epix["windows"]["search"]["duration_ns"] = 128000
        epix["windows"]["with_setup"]["duration_ns"] = 134400
        self.sync_evidence()
        self.assertAlmostEqual(self.summarize()["configurations"]["epix"]["mean_energy_nj"]["search"]["total"], 24)

    def test_failed_trials_remain_in_denominator(self):
        for config in self.record["configurations"].values():
            for trial in config["trials"]:
                trial["success"] = False
        self.sync_evidence()
        result = self.summarize()
        for config in result["configurations"].values():
            self.assertEqual(config["trials"], 32)
            self.assertEqual(config["success_rate"], 0)
            self.assertIsNone(config["expected_energy_to_success_nj"])
            self.assertIsNone(config["K99_empirical"])
        self.assertIsNone(result["expected_energy_to_success_saving_percent"])

    def test_missing_evidence_category_rejected(self):
        del self.record["configurations"]["baseline"]["evidence"]["power"]
        with self.assertRaises(ValueError):
            self.summarize()

    def test_missing_evidence_file_rejected(self):
        (self.base / "baseline/power_search.power.txt").unlink()
        with self.assertRaises(ValueError):
            self.summarize()

    def test_changed_evidence_rejected(self):
        (self.base / "baseline/power_search.power.txt").write_text("Changed synthetic evidence")
        with self.assertRaises(ValueError):
            self.summarize()

    def test_evidence_cannot_escape_bundle(self):
        self.record["configurations"]["baseline"]["evidence"]["power"][0]["path"] = "../outside.txt"
        with self.assertRaises(ValueError):
            self.summarize()

    def test_seed_pair_mismatch_rejected(self):
        self.record["configurations"]["epix"]["trials"][0]["seed"] += 1
        with self.assertRaises(ValueError):
            self.summarize()

    def test_initial_state_pair_mismatch_rejected(self):
        self.record["configurations"]["epix"]["trials"][0]["initial_state_sha256"] = "3" * 64
        with self.assertRaises(ValueError):
            self.summarize()

    def test_empty_initial_state_hashes_rejected(self):
        for config in self.record["configurations"].values():
            config["trials"][0]["initial_state_sha256"] = ""
        with self.assertRaises(ValueError):
            self.summarize()

    def test_fractional_cycle_count_rejected(self):
        epix = self.record["configurations"]["epix"]
        epix["trials"][0]["search_cycles"] += 0.5
        for window in epix["windows"].values():
            window["duration_ns"] += 50
        with self.assertRaises(ValueError):
            self.summarize()

    def test_fractional_word_count_rejected(self):
        self.record["configurations"]["epix"]["trials"][0]["fresh_words"] = 1.5
        with self.assertRaises(ValueError):
            self.summarize()

    def test_noninteger_seed_rejected(self):
        for config in self.record["configurations"].values():
            config["trials"][0]["seed"] = "42"
        with self.assertRaises(ValueError):
            self.summarize()

    def test_trial_population_mismatch_rejected(self):
        self.record["configurations"]["epix"]["trials"].reverse()
        with self.assertRaises(ValueError):
            self.summarize()

    def test_activity_duration_mismatch_rejected(self):
        self.record["configurations"]["epix"]["windows"]["search"]["duration_ns"] += 100
        with self.assertRaises(ValueError):
            self.summarize()

    def test_power_components_must_sum(self):
        self.record["configurations"]["epix"]["windows"]["search"]["power_w"]["total"] *= 2
        with self.assertRaises(ValueError):
            self.summarize()

    def test_nan_power_rejected(self):
        self.record["configurations"]["epix"]["windows"]["search"]["power_w"]["internal"] = float("nan")
        with self.assertRaises(ValueError):
            self.summarize()

    def test_failed_validation_flag_rejected(self):
        self.record["configurations"]["epix"]["checks"]["hold"] = False
        with self.assertRaises(ValueError):
            self.summarize()

    def test_diagnostic_smoke_not_publishable(self):
        self.record["status"] = "diagnostic_smoke"
        with self.assertRaises(ValueError):
            self.summarize()

    def test_changed_success_with_unchanged_evidence_rejected(self):
        self.record['configurations']['baseline']['trials'][0]['success']=False
        with self.assertRaisesRegex(ValueError,'success differs'):
            self.summarize()

    def test_changed_power_with_valid_sum_rejected(self):
        power=self.record['configurations']['baseline']['windows']['search']['power_w']
        for key in power:power[key]*=2
        with self.assertRaisesRegex(ValueError,'power'):
            self.summarize()

    def test_changed_area_with_unchanged_mapping_rejected(self):
        self.record['configurations']['baseline']['area_um2']=200
        with self.assertRaisesRegex(ValueError,'mapped area'):
            self.summarize()

    def test_relabelled_smoke_spec_rejected(self):
        for mode,c in self.record['configurations'].items():
            item=c['evidence']['run_spec'][0];path=self.base/item['path']
            spec=json.loads(path.read_text());spec['smoke']=True;path.write_text(json.dumps(spec))
            item['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
        self.record['status']='complete'
        with self.assertRaisesRegex(ValueError,'run profile differs'):
            self.summarize()

    def test_smoke_population_cannot_be_relabelled_complete(self):
        self.record['trial_ids']=[0,1]
        for c in self.record['configurations'].values():
            c['trials']=c['trials'][:2]
            c['windows']['search']['duration_ns']=4000
            c['windows']['with_setup']['duration_ns']=4400
        self.sync_evidence()
        with self.assertRaisesRegex(ValueError,'at least 32'):
            self.summarize()

    def test_full_functional_trial_requirement_is_bound(self):
        item=self.record['configurations']['baseline']['evidence']['rtl_validation'][1]
        path=self.base/item['path'];receipt=json.loads(path.read_text());receipt['trials']=2
        path.write_text(json.dumps(receipt));item['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
        with self.assertRaisesRegex(ValueError,'complete functional trial'):
            self.summarize()

    def test_unbound_mapped_dimension_header_rejected(self):
        evidence=self.record['configurations']['baseline']['evidence']
        header=self.base/'baseline/source_dimensions.hpp'
        header.write_text('#define MAXCUT_N 800\n')
        value=hashlib.sha256(header.read_bytes()).hexdigest()
        evidence['source'].append(dict(path=str(header.relative_to(self.base)),sha256=value))
        item=next(i for i in evidence['rtl_validation'] if i['path'].endswith('_validation.json'))
        path=self.base/item['path'];receipt=json.loads(path.read_text())
        receipt['sources']['dimensions.hpp']=value
        path.write_text(json.dumps(receipt));item['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
        with self.assertRaisesRegex(ValueError,'mapped build lacks bound C\\+\\+ header'):
            self.summarize()

    def test_borrowed_other_case_mapping_rejected(self):
        c=self.record['configurations']['baseline']
        item=next(i for i in c['evidence']['mapped_validation'] if i['path'].endswith('_resolved.json'))
        path=self.base/item['path'];resolved=json.loads(path.read_text());resolved['case_name']='some_historical_case'
        path.write_text(json.dumps(resolved));item['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
        with self.assertRaisesRegex(ValueError,'different case'):
            self.summarize()


class LibraryTimeActivityTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which("c++"), "C++ compiler required for the actual activity reader")
    def test_ps_library_density_has_correct_scale_with_real_vcd(self):
        with tempfile.TemporaryDirectory(prefix="synthetic-asic-vcd-test-") as folder:
            work = Path(folder)
            (work / "baseline").mkdir()
            (work / "baseline_gate").mkdir()
            mapped = {"modules": {"test_top": {"ports": {
                "clk": {"direction": "input", "bits": [1]},
                "a": {"direction": "input", "bits": [2]}},
                "cells": {"cell0": {"port_directions": {"A": "input", "Y": "output"}}}}}}
            (work / "baseline/mapped.json").write_text(json.dumps(mapped))
            trials = {"workloads": [{"trials": [{"trial": 0, "trial_begin_cycle": 1,
                                                 "search_begin_cycle": 1, "end_cycle": 2}]}]}
            (work / "baseline_gate/receipt.json").write_text(json.dumps(trials))
            # The 100..200 ns active interval contains 2 clock edges and 1 data edge.
            vcd = """$timescale 1ps $end
$scope module test_top $end
$var wire 1 ! clk $end
$var wire 1 \" a $end
$scope module cell0 $end
$var wire 1 \" A $end
$var wire 1 # Y $end
$upscope $end
$upscope $end
$enddefinitions $end
#0
0!
0\"
0#
#50000
1!
#100000
0!
#125000
1\"
1#
#150000
1!
#200000
0!
"""
            (work / "baseline_gate/activity.vcd").write_text(vcd)
            activity.prepare(work, "baseline", 100, "test_top", ns_per_time_unit=0.001)
            text = (work / "baseline_power/search.activity.tcl").read_text()
            densities = [float(v) for v in re.findall(r"epix_annotate (?:pin|port) \{[^}]*\} (\S+)", text)]
            self.assertEqual(len(densities), 3)
            for density in densities:
                self.assertAlmostEqual(density, 1 / 100000)
            counts = json.loads((work / "baseline_power/search.counts.json").read_text())
            self.assertEqual(counts["duration_ps"], 100000)
            self.assertEqual(counts["clock_edges"], 2)
            self.assertEqual(counts["ns_per_library_time_unit"], 0.001)


if __name__ == "__main__":
    unittest.main(verbosity=2)
