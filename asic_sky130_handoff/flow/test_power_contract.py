"""Exercise power/CAD receipt interoperability with temporary synthetic files.

These fixtures test guards only; they are not hardware validation or energy data.
"""
import json
from pathlib import Path
import tempfile
import unittest

import cad
import power


class PowerContractTests(unittest.TestCase):
    def test_mapped_build_binds_case_dimension_header(self):
        with tempfile.TemporaryDirectory() as temporary:
            case=Path(temporary)
            header=case/'dimensions.hpp'
            header.write_text('#define MAXCUT_N 800\n')
            rtl=dict(sources={'dimensions.hpp':cad.sha(header)})
            self.assertEqual(power.simulation_dependencies(case,{},rtl),[header.resolve()])
            header.write_text('#define MAXCUT_N 128\n')
            with self.assertRaisesRegex(ValueError,'simulation dependency changed'):
                power.simulation_dependencies(case,{},rtl)

    def test_explicit_driver_dependencies_are_bound(self):
        with tempfile.TemporaryDirectory() as temporary:
            case=Path(temporary)
            header=case/'constants.hpp'
            header.write_text('constexpr int n=800;\n')
            self.assertEqual(power.simulation_dependencies(case,dict(dependency_sources=['constants.hpp']),dict(sources={})),[header.resolve()])

    def test_adapter_accepts_case_specific_ports_and_counts(self):
        with tempfile.TemporaryDirectory() as temporary:
            case = Path(temporary)
            options = dict(driver="sim.cpp", prefix="Vcustom", compare_fields=["trial","success","raw_words"],
                fresh_word_fields=["raw_words"], setup_rng_words=129, boundary="Test boundary")
            cad.write_json(case / "asic.json", dict(top="custom", simulation=options))
            result = power.adapter(case)
            self.assertEqual(result["top"], "custom")
            self.assertEqual(result["setup_rng_words"], 129)
            options["compare_fields"] = ["trial"]
            cad.write_json(case / "asic.json", dict(top="custom", simulation=options))
            with self.assertRaisesRegex(ValueError, "success"):
                power.adapter(case)

    def fixture(self, root):
        case = root / "case"
        case.mkdir()
        (case / "solver.sv").write_text("module top(input clk, output q); assign q = clk; endmodule\n")
        cad.write_json(case / "asic.json", dict(schema_version=1, top="top", clock_port="clk",
            modes={m: dict(rtl=["solver.sv"], include_dirs=[], defines={}) for m in power.MODES}))
        reference = root / "reference"
        (reference / "vectors").mkdir(parents=True)
        config = cad.load_technology("tech/sky130_hd/config_200ns.json")["config"]
        for mode in power.MODES:
            plan = cad.prepare(case, mode=mode, work=root / "mapping")
            d = Path(plan["directory"])
            for name in ("mapped.v", "mapped.json", "stat.json", "cells_sim.v"):
                (d / name).write_text("synthetic receipt-contract fixture\n")
            synthesis = dict(passed=True, design_fingerprint=plan["design_fingerprint"],
                scripts_sha256=plan["scripts_sha256"],
                outputs_sha256={name: cad.sha(d / name) for name in
                    ("mapped.v", "mapped.json", "stat.json", "cells_sim.v", "clock_gate_sim.sv")})
            cad.write_json(d / "synthesis.json", synthesis)
            reports = ("setup.txt", "hold.txt", "electrical.txt", "check_setup.txt", "timing.log")
            for name in reports:
                (d / name).write_text("synthetic receipt-contract fixture\n")
            timing = dict(passed=True, design_fingerprint=plan["design_fingerprint"],
                synthesis_receipt_sha256=cad.sha(d / "synthesis.json"),
                mapped_verilog_sha256=cad.sha(d / "mapped.v"),
                constraints_sha256=cad.sha(d / "constraints.sdc"),
                timing_script_sha256=cad.sha(d / "timing.tcl"), liberty_sha256=cad.sha(plan["liberty"]),
                report_sha256={name: cad.sha(d / name) for name in reports})
            cad.write_json(d / "timing.json", timing)
            cad.write_json(d / "timing_validation.json", dict(passed=True,
                design_fingerprint=plan["design_fingerprint"], binding=plan["binding"],
                checks=dict(setup=True, hold=True, max_capacitance=True, max_transition=True, constraint_coverage=True),
                hashes={name: cad.sha(d / name) for name in
                        ("mapped.v", "mapped.json", "timing.tcl", "constraints.sdc", "synthesis.json", "timing.json")}))
            vector = reference / "vectors" / (mode + ".bin")
            vector.write_bytes(b"synthetic fixture; never simulated")
            cad.write_json(vector.with_suffix(".json"), dict(passed=True, trials=1, sha256=cad.sha(vector), sources={}))
            rtl = reference / ("rtl_" + mode)
            rtl.mkdir()
            (rtl / "trials.tsv").write_text("synthetic fixture; never simulated\n")
            cad.write_json(rtl / "validation.json", dict(passed=True, trials=1, vector_sha256=cad.sha(vector),
                receipt_sha256=cad.sha(rtl / "trials.tsv"), sources={}))
        return case, reference, d.parent, config

    def test_current_cad_receipts_are_consumed(self):
        with tempfile.TemporaryDirectory() as temporary:
            power.validate_inputs(*self.fixture(Path(temporary)), trials=1, smoke=True)

    def test_changed_cell_models_are_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            values = self.fixture(Path(temporary))
            (values[2] / "baseline" / "cells_sim.v").write_text("changed model\n")
            with self.assertRaisesRegex(ValueError, "Synthesis output changed"):
                power.validate_inputs(*values, trials=1, smoke=True)

    def test_shortened_categorical_budget_cannot_be_reported_as_production(self):
        with tempfile.TemporaryDirectory() as temporary:
            values = self.fixture(Path(temporary))
            case, reference, _, _ = values
            cad.write_json(case / "metadata.json", dict(max_flips=100000000))
            path = reference / "vectors" / "baseline.json"
            vector = json.loads(path.read_text())
            vector.update(trials=1000, outcomes=[dict(trial=i, flip_limit=1,
                full_software_flip_budget=False) for i in range(1000)])
            cad.write_json(path, vector)
            with self.assertRaisesRegex(ValueError, "shortened flip budgets"):
                power.validate_inputs(*values, trials=32, smoke=False)

    def test_shortened_large_graph_budget_cannot_be_reported_as_production(self):
        with tempfile.TemporaryDirectory() as temporary:
            values = self.fixture(Path(temporary))
            case, reference, _, _ = values
            cad.write_json(case / "metadata.json", dict(family="MAXCUT", maximum_sweeps=4096))
            path = reference / "vectors" / "baseline.json"
            vector = json.loads(path.read_text())
            vector.update(trials=1000, outcomes=[dict(trial=i, full_software_budget=False,
                canonical_maximum_sweeps=4096) for i in range(1000)])
            cad.write_json(path, vector)
            with self.assertRaisesRegex(ValueError, "shortened sweep budgets"):
                power.validate_inputs(*values, trials=32, smoke=False)


if __name__ == "__main__":
    unittest.main()
