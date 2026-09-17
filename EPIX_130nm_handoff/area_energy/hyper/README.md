# SAT and XOR-SAT evaluation

Run through [area_energy/run.py](../README.md). These files validate RTL, map the design, check timing and estimate energy.

| File | Purpose |
|---|---|
| [sat.py](sat.py), [xorsat.py](xorsat.py) | Evaluate EPIX and its fresh-sampling diagnostic. |
| [sat_baseline.py](sat_baseline.py), [xorsat_baseline.py](xorsat_baseline.py) | Evaluate the separately synthesized baseline. |
| [sat_sim.cpp](sat_sim.cpp), [xorsat_sim.cpp](xorsat_sim.cpp) | Drive trials and compare each update with the reference. |
| [map.py](map.py) | Shared mapping, buffering and timing helpers. |
| [close_hold.py](close_hold.py) | Repair hold timing and calculate final area. |
| [netlist_repair.py](netlist_repair.py) | Add buffers where pin loads require them. |
| [power_closed.py](power_closed.py) | Combine cell power with explicit SRAM energy. |
| [macro_activity.cpp](macro_activity.cpp) | Count SRAM edges and enable/write signals. |
| [sram_model.py](sram_model.py) | Calculate SRAM internal energy from Liberty tables. |
| [saif_support.py](saif_support.py) | Split recorded activity into setup and search. |
| [sta_helpers.py](sta_helpers.py) | Read library data and timing/power reports. |
| [readback.py](readback.py), [readback.tcl](readback.tcl) | Check that OpenSTA preserves assigned activity. |

The runner copies the chosen entry point to `flow/campaign_a2.py` and its driver to `flow/sim.cpp` in each work engine. It copies the selected wrapper as `a2_chip`, keeping its parameters and connections. Shared RTL and references live under the work folder's `hyper/` directory.

Internal case names are short, such as `sat128` and `xorsat128`. Trials use seeds 1730–1732 and 128 sweeps per temperature. Reports compare the separate baseline's `fresh` trials with EPIX's `epix` trials. EPIX's own `fresh` trials are diagnostics.

Results are under each engine's `results/<short-id>/shared/`. Read `closed/status.json` for final area/timing and `power/<mode>_<seed>_128_stall0/result.json` for energy.

See the [main guide](../README.md) for commands and measurement scope, and [tools/](../tools/README.md) for requirements.
