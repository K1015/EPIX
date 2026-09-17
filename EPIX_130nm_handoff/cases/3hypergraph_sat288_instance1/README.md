# 3hypergraph_sat288_instance1

3-SAT with 288 variables; 1,238 factors; target 0 weighted violations.

Run both modes from the [package root](../../README.md):

```bash
./run.sh simulate --cases 3hypergraph_sat288_instance1
```

Default: Four sweeps per temperature. Add `--full` for 128 sweeps at each of 16 temperatures. Search stops early if the target is reached.

Add `--stalls` to check randomized pauses.

| File or folder | Use |
|---|---|
| [baseline/](baseline/README.md) | IID top: `sat_baseline_solver`. |
| [epix/](epix/README.md) | EPIX top: `sat_epix_solver`. |
| [src/](src/README.md) | Shared solver code. |
| [coefficients.hex](coefficients.hex) | 5,240 packed 32-bit words for factors and adjacency. |
| [instance.json](instance.json) | Problem data, target, and run settings. |
| [reference.h](reference.h) | Constants for the C++ reference. |

- One assignment uses one sequential field/update engine.
- 288 private p-bit LFSRs.
- 5,240 × 32-bit coefficient memory; 41 SRAM22 banks share one logical port.
- Spins, the best assignment, LFSR state, and EPIX history use registers. Both modes have the same memory layout.

Simulation checks agreement with the reference. Use [area and energy estimation](../../area_energy/README.md) for physical estimates.
