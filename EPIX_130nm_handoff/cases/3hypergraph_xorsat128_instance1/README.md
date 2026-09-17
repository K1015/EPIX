# 3hypergraph_xorsat128_instance1

3-XOR-SAT with 128 variables; 86 factors; target 0 weighted violations.

Run both modes from the [package root](../../README.md):

```bash
./run.sh simulate --cases 3hypergraph_xorsat128_instance1
```

Default: Four sweeps per temperature. Add `--full` for 128 sweeps at each of 16 temperatures. Search stops early if the target is reached.

Add `--stalls` to check randomized pauses.

| File or folder | Use |
|---|---|
| [baseline/](baseline/README.md) | IID top: `xorsat_baseline_solver`. |
| [epix/](epix/README.md) | EPIX top: `xorsat_epix_solver`. |
| [src/](src/README.md) | Shared solver code. |
| [coefficients.hex](coefficients.hex) | 472 packed 32-bit words for factors and adjacency. |
| [instance.json](instance.json) | Problem data, target, and run settings. |
| [reference.h](reference.h) | Constants for the C++ reference. |

- One assignment uses one sequential field/update engine.
- 128 private p-bit LFSRs.
- 472 × 32-bit coefficient memory; 4 SRAM22 banks share one logical port.
- Spins, the best assignment, LFSR state, and EPIX history use registers. Both modes have the same memory layout.

Simulation checks agreement with the reference. Use [area and energy estimation](../../area_energy/README.md) for physical estimates.
