# Functional simulation

[run.py](run.py) builds a selected case and checks it against the software reference. Start it with [run.sh](../run.sh).

## Run

From the package root:

```bash
./run.sh simulate --cases 3hypergraph_sat128_instance1
```

Both modes run. The default is four sweeps and one trial. Use `--full --trials 3` for the native budget. Use `--stalls` to test SAT/XOR-SAT pause behavior.

Requires Python 3.9+, Verilator 5, make and a C++17 compiler.

| Option | Meaning |
|---|---|
| `list` / `lint` / `simulate` | List cases, check RTL or run simulation. |
| `--cases NAME ...` | Select case directories. Required for simulation. |
| `--mode MODE` | Choose `baseline`, `epix` or `both`. Default: both. |
| `--sweeps 4` | Set a short budget. For SAT/XOR-SAT, this is per temperature. |
| `--jobs 2` | Number of compiler jobs. |
| `--work PATH` | Save outputs here. Default: package `results/`. |
| `--timeout 7200` | Time limit in seconds for each build or run. |

## Files

| File | Purpose |
|---|---|
| [run.py](run.py) | Build and run selected cases. |
| [graph_sim.cpp](graph_sim.cpp) | Check King's MaxCut and Chimera. |
| [sat_sim.cpp](sat_sim.cpp) | Check SAT updates and counters. |
| [xorsat_sim.cpp](xorsat_sim.cpp) | Check XOR-SAT updates and field caching. |
| [cache_reference.h](cache_reference.h) | Reference model for the XOR field cache. |
| [hyper_reference.py](hyper_reference.py) | Generate SAT/XOR-SAT reference traces. |
| [sky130_models.sv](sky130_models.sv) | Functional SRAM and clock-gate models. Simulation only. |

## Read the output

Each case/mode folder contains build logs, simulation logs and trial results. SAT/XOR-SAT also create reference vectors.

`passed` means agreement with the reference. `success` means the target was reached. Short Chimera runs can report `complete=0`.

The reference model's `energy` is the problem objective. Electrical energy in joules comes from [area_energy/](../area_energy/README.md).
