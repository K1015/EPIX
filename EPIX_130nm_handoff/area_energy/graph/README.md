# King's MaxCut and Chimera evaluation

Run through [area_energy/run.py](../README.md). These files validate RTL, map the design, check timing and estimate energy.

| File | Purpose |
|---|---|
| [build_rtl.py](build_rtl.py) | Build both modes and check against the software reference. |
| [sim.cpp](sim.cpp) | Load inputs and drive the reference simulation. |
| [map.py](map.py) | Map logic; check timing, SRAMs and private RNGs. |
| [netlist_repair.py](netlist_repair.py) | Add buffers where pin loads require them. |
| [check_selection.py](check_selection.py) | Check site and color selection after mapping. |
| [close_hold.py](close_hold.py) | Repair hold timing and report final area. |
| [profile.py](profile.py) | Compare RTL and mapped trials; collect energy. |
| [power_saif.py](power_saif.py) | Build the mapped simulator with activity recording. |
| [saif_support.py](saif_support.py) | Split recorded activity into setup and search. |
| [power_closed.py](power_closed.py) | Check activity and combine power components. |
| [sram_model.py](sram_model.py) | Calculate SRAM internal energy from Liberty tables. |
| [sta_helpers.py](sta_helpers.py) | Read library data and timing/power reports. |
| [readback.py](readback.py), [readback.tcl](readback.tcl) | Check that OpenSTA preserves assigned activity. |
| [macro_activity.cpp](macro_activity.cpp) | Count SRAM edges and enable/write signals. |

The runner copies these files into the work folder's `graph/flow/`. It also creates `cases/`, `rtl/`, `tech/` and `results/` there. Internal `iid` results mean baseline; `epix` means EPIX. The original solver top is retained for hardware checks.

Read `mapped/status.json` and `closed/status.json` for area and timing. Trial energy is in `power_saif/profile_s<budget>_t<trial>/result.json`. A short run with `native_complete=false` is only a partial run.

See the [main guide](../README.md) for commands and measurement scope, and [tools/](../tools/README.md) for requirements.
