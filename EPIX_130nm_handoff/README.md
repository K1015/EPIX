# EPIX 130 nm evaluation

This folder contains 16 A2 cases: King's MaxCut, Chimera, SAT and XOR-SAT at 128, 288, 512 and 800 variables. Case names match the results workbook. Chimera512 uses instance 4.

## Start here

Run from this folder:

```bash
./run.sh list
./run.sh simulate --cases 3hypergraph_sat128_instance1
```

Simulation runs both baseline and EPIX. The default is a four-sweep check. Add `--full --trials 3` for the native budget and three trials.

A simulation pass means the RTL matches the reference. Target hits are reported separately.

## Folders

| Folder | What it contains |
|---|---|
| [cases/](cases/README.md) | Inputs and RTL for the 16 cases. |
| [testbench/](testbench/README.md) | Simulation drivers and software references. |
| [tech/](tech/README.md) | SKY130 standard-cell and SRAM libraries. |
| [area_energy/](area_energy/README.md) | Mapping, power, energy and area code. |
| [Worked example](area_energy/example/README.md) | Actual waveforms and step-by-step energy calculations. |

Every source folder has a short README. [run.sh](run.sh) starts the simulation runner.

## Area and energy

**Yosys maps the RTL → Verilator records activity → OpenSTA estimates power.**

```bash
python3 area_energy/run.py energy --cases 3hypergraph_sat128_instance1 --work ../EPIX_130nm_results
```

The result includes on-chip loading and search, including SRAM. Reports separate dynamic energy, leakage energy, standard-cell area and SRAM area.

These are pre-route estimates at 1.8 V, 25 C and 5 MHz. Host energy and routed-wire effects are outside this model. See [tool setup and commands](area_energy/README.md).

## Selected energy results

Existing complete-run estimates, including setup and SRAM. All listed cases hit their targets in both modes. The other cases are still under investigation.

| Case | Baseline (nJ) | EPIX (nJ) | Saving |
|---|---:|---:|---:|
| [Chimera128](cases/chimera_maxcut128_instance1/README.md) | 171659.906 | 133799.840 | 22.06% |
| [Chimera288](cases/chimera_maxcut288_instance1/README.md) | 350697.792 | 278205.053 | 20.67% |
| [Chimera512, instance 4](cases/chimera_maxcut512_instance4/README.md) | 648839.467 | 512175.929 | 21.06% |
| [SAT128](cases/3hypergraph_sat128_instance1/README.md) | 52788.214 | 43664.957 | 17.28% |
| [XOR-SAT128](cases/3hypergraph_xorsat128_instance1/README.md) | 11031.136 | 9450.277 | 14.33% |

The Chimera rows use one trial each; SAT and XOR-SAT use three each. These are existing results, not new measurements from this documentation update.
