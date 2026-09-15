"""Check clock-gate substitution, timing constraints and input bindings."""
import copy
import itertools
import json
from pathlib import Path
import tempfile
import unittest

import cad
from netlist_repair import repair_clock_design, repair_electrical_design


class FlowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tech = cad.load_technology("tech/sky130_hd/config_200ns.json")

    def test_unit_conversion(self):
        units = cad.liberty_units('time_unit : "1ps"; capacitive_load_unit(1,"ff");')
        self.assertEqual(units, dict(ns_per_time_unit=.001, pf_per_capacitance_unit=.001))
        self.assertEqual(.01 / units["pf_per_capacitance_unit"], 10)

    def test_cell_and_pin_substitution_is_simultaneous(self):
        source = cad.DEFAULT_SOURCE_ICG
        target = dict(cell="LIB_CG", clock_pin="GATE", enable_pin="CLK", output_pin="Z", test_enable_pin="TE")
        text = "sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk), .GATE(en), .GCLK(gclk));"
        self.assertEqual(cad.remap_gates(text, source, target), "LIB_CG gate(.GATE(clk), .CLK(en), .Z(gclk), .TE(1'b0));")
        self.assertIn("gate_latched = (CLK | TE)", cad.gate_model(target))

    def test_preparation_constraints_and_live_source_binding(self):
        with tempfile.TemporaryDirectory() as temporary:
            plan = cad.prepare(mode="baseline", work=temporary)
            d = Path(plan["directory"])
            self.assertEqual(plan["config"]["clock"]["period_ns"], 200)
            self.assertIn("create_clock -name clk -period 200 ", (d / "constraints.sdc").read_text())
            self.assertIn("set_load 10\n", (d / "abc.constr").read_text())
            self.assertIn("set_load 0.01", (d / "constraints.sdc").read_text())
            self.assertIn("read_slang -F slang.f", (d / "synth.ys").read_text())
            self.assertIn("--no-implicit-memories", (d / "slang.f").read_text())
            self.assertFalse((d / "synthesis.json").exists())
            cad.verify_plan_sources(plan)
            with (d / "constraints.sdc").open("a") as file:
                file.write("# changed\n")
            with self.assertRaisesRegex(ValueError, "Prepared script changed"):
                cad.verify_plan_sources(plan)

    def test_absent_adapter_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            with self.assertRaisesRegex(FileNotFoundError, "No ASIC adapter"):
                cad.prepare(case=temporary, work=temporary)

    def test_case_defined_rng_register_audit(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            cells = {}
            for i in range(2):
                cells[f"ff_{i}"] = dict(type="sky130_fd_sc_hd__dfxtp_1",
                    port_directions={"CLK":"input", "D":"input", "Q":"output"},
                    connections={"CLK":[2], "D":[3], "Q":[10+i]})
            module = dict(cells=cells, netnames={"rng_state":dict(bits=[10,11])})
            plan = dict(directory=str(directory), top="top", case_name="custom_case",
                liberty=str(self.tech["liberty"]), config=self.tech["config"], expected_icg_count=0,
                rng_audit=dict(nets=[dict(name="rng_state", width=2)], expected_registers=2))
            cad.write_json(directory / "mapped.json", dict(modules=dict(top=module)))
            result = cad.audit_netlist(plan)
            self.assertEqual(result["local_rng_cells"], ["ff_0", "ff_1"])
            self.assertEqual(result["local_rng_registers"], 2)
            module["netnames"]["rng_state"]["bits"] = [10,10]
            cad.write_json(directory / "mapped.json", dict(modules=dict(top=module)))
            with self.assertRaisesRegex(ValueError, "distinct bits"):
                cad.audit_netlist(plan)
            module["netnames"]["rng_state"]["bits"] = [10,"0"]
            cad.write_json(directory / "mapped.json", dict(modules=dict(top=module)))
            with self.assertRaisesRegex(ValueError, "live RNG state"):
                cad.audit_netlist(plan)

    def test_clock_buffer_roots_and_polarity(self):
        sizes = [16, 17, 32, 128, 1152]
        roots = [10 + x for x in range(len(sizes))]
        cells, nets, sinks = {}, {}, []
        for group, (root, size) in enumerate(zip(roots, sizes)):
            cells[f"gate_{group}"] = dict(hide_name=0, type=self.tech["config"]["icg"]["cell"],
                parameters={}, attributes={}, port_directions={"CLK":"input", "GATE":"input", "GCLK":"output"},
                connections={"CLK":[3], "GATE":[4], "GCLK":[root]})
            nets[f"root_{group}"] = dict(hide_name=0, bits=[root], attributes={})
            for _ in range(size):
                name = f"ff_{len(sinks)}"
                cells[name] = dict(hide_name=0, type="sky130_fd_sc_hd__dfxtp_1", parameters={}, attributes={},
                    port_directions={"CLK":"input", "D":"input", "Q":"output"},
                    connections={"CLK":[root], "D":[2], "Q":[10000 + len(sinks)]})
                sinks.append((name, root))
        design = {"modules":{"top":dict(cells=cells, netnames=nets, attributes={},
            ports={"clk":dict(direction="input",bits=[3]), "data":dict(direction="input",bits=[2])})}}
        original = copy.deepcopy(design)
        fixed, audit = repair_clock_design(design, library=self.tech["liberty"], icg=self.tech["config"]["icg"],
            buffer_config=self.tech["config"]["buffer"], module_name="top", expected_gates=5)
        self.assertEqual(design, original)
        cells = fixed["modules"]["top"]["cells"]
        for bits in itertools.product([0, 1], repeat=len(roots)):
            values = dict(zip(roots, bits))
            for name, cell in cells.items():
                if name.startswith("clock_buffer_"):
                    values[cell["connections"]["X"][0]] = values[cell["connections"]["A"][0]]
            for name, root in sinks:
                self.assertEqual(values[cells[name]["connections"]["CLK"][0]], values[root])
                self.assertEqual(cells[name]["connections"]["D"], [2])
        self.assertEqual(audit["inserted_buffers"], 108)
        self.assertLess(audit["repaired_max_capacitance_ratio"], 1)

    def test_electrical_repair_keeps_output_truth_and_rejects_excess_load(self):
        pins = ["A1", "A2", "B1", "C1", "D1"]
        driver = dict(hide_name=0, type="sky130_fd_sc_hd__a2111oi_0", parameters={}, attributes={},
                      port_directions={**{p:"input" for p in pins}, "Y":"output"},
                      connections={**{p:[2] for p in pins}, "Y":[10]})
        cells = {"source":driver}
        for i in range(13):
            cells[f"sink_{i}"] = dict(hide_name=0, type="sky130_fd_sc_hd__nor2_1", parameters={}, attributes={},
                port_directions={"A":"input", "B":"input", "Y":"output"},
                connections={"A":[10], "B":[2], "Y":[100+i]})
        design = {"modules":{"top":dict(cells=cells, attributes={},
            ports={"in":dict(direction="input",bits=[2]), "out":dict(direction="output",bits=[10,100])},
            netnames={"out":dict(hide_name=0,bits=[10,100],attributes={})})}}
        report = "source/Y 1.462 1.79 -0.328 (VIOLATED)\nsink_0/A 1.5 1.79 -0.29 (VIOLATED)\n"
        args = dict(library=self.tech["liberty"], buffer_config=self.tech["config"]["buffer"], module_name="top")
        original = copy.deepcopy(design)
        fixed, audit = repair_electrical_design(design, report, **args)
        self.assertEqual(design, original)
        self.assertEqual(audit["inserted_buffers"], 1)
        module = fixed["modules"]["top"]
        buffer = module["cells"]["electrical_buffer_000000"]
        bit = buffer["connections"]["X"][0]
        self.assertEqual(buffer["connections"]["A"], [10])
        self.assertEqual(module["ports"]["out"]["bits"], [bit,100])
        self.assertEqual(module["netnames"]["out"]["bits"], [bit,100])
        self.assertTrue(all(module["cells"][f"sink_{i}"]["connections"]["A"] == [bit] for i in range(13)))
        with self.assertRaisesRegex(ValueError, "cannot drive"):
            repair_electrical_design(design, report, output_load_lib_units=1, **args)

    def test_electrical_tree_handles_large_mixed_capacitance_fanout(self):
        cells={"source":dict(type="sky130_fd_sc_hd__buf_4",parameters={},attributes={},
            port_directions={"A":"input","X":"output"},connections={"A":[2],"X":[10]})}
        types=("sky130_fd_sc_hd__buf_1","sky130_fd_sc_hd__buf_4","sky130_fd_sc_hd__buf_16")
        for i in range(4096):
            cells[f"sink_{i:04d}"]=dict(type=types[i%3],parameters={},attributes={},
                port_directions={"A":"input","X":"output"},connections={"A":[10],"X":[100+i]})
        design={"modules":{"top":dict(cells=cells,attributes={},
            ports={"in":dict(direction="input",bits=[2]),"result":dict(direction="output",bits=[10]*7+[100])},
            netnames={"result":dict(hide_name=0,bits=[10]*7+[100],attributes={})})}}
        original=copy.deepcopy(design)
        repaired,audit=repair_electrical_design(design,"source/X 0.13093 40 -39 (VIOLATED)\n",
            library=self.tech['liberty'],buffer_config=self.tech['config']['buffer'],module_name='top')
        self.assertEqual(design,original)
        self.assertGreater(audit['inserted_buffers'],2)
        self.assertGreater(audit['repairs'][0]['max_buffer_depth'],1)
        self.assertLessEqual(audit['repaired_max_capacitance_ratio'],1+1e-12)
        module=repaired['modules']['top']
        self.assertEqual(module['netnames']['result']['bits'],module['ports']['result']['bits'])
        self.assertEqual(module['cells']['source']['connections'],original['modules']['top']['cells']['source']['connections'])
        for value in (0,1):
            signals={10:value}
            for name,cell in module['cells'].items():
                if name.startswith('electrical_buffer_'):
                    self.assertEqual(cell['type'],self.tech['config']['buffer']['cell'])
                    signals[cell['connections']['X'][0]]=signals[cell['connections']['A'][0]]
            for i in range(4096):
                self.assertEqual(signals[module['cells'][f'sink_{i:04d}']['connections']['A'][0]],value)
            for bit in module['ports']['result']['bits'][:7]:
                self.assertEqual(signals[bit],value)
        self.assertEqual(module['ports']['result']['bits'][-1],100)
        self.assertEqual(module['ports']['in']['bits'],[2])
        with self.assertRaisesRegex(ValueError,'already present'):
            repair_electrical_design(repaired,"source/X 0.1 1 -0.9 (VIOLATED)\n",
                library=self.tech['liberty'],buffer_config=self.tech['config']['buffer'],module_name='top')

    def test_electrical_tree_requires_branching_drive_capacity(self):
        # A characterized buffer that can drive only one copy of itself cannot
        # reduce a load above its own maximum by adding arbitrary serial stages.
        library_text="""library(test) {
 cell(BUF) {
  pin(A) { direction : input; capacitance : 0.08; }
  pin(X) { direction : output; max_capacitance : 0.1; }
 }
 cell(SINK) {
  pin(A) { direction : input; capacitance : 0.06; }
  pin(X) { direction : output; max_capacitance : 0.1; }
 }
}"""
        cells={'source':dict(type='BUF',port_directions={'A':'input','X':'output'},connections={'A':[2],'X':[10]})}
        for i in range(3):
            cells[f'sink_{i}']=dict(type='SINK',port_directions={'A':'input','X':'output'},connections={'A':[10],'X':[20+i]})
        design={'modules':{'top':dict(cells=cells,netnames={},ports={'in':dict(direction='input',bits=[2])})}}
        with tempfile.TemporaryDirectory() as temporary:
            path=Path(temporary)/'test.lib';path.write_text(library_text)
            with self.assertRaisesRegex(ValueError,'cannot drive two buffer inputs'):
                repair_electrical_design(design,'source/X 0.1 0.18 -0.08 (VIOLATED)\n',library=path,
                    buffer_config=dict(cell='BUF',input_pin='A',output_pin='X'),module_name='top')


if __name__ == "__main__":
    unittest.main()
