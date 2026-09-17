# kings_maxcut800_instance1

King's MaxCut with 800 variables; signed cut target 748.

Run both modes from the [package root](../../README.md):

```bash
./run.sh simulate --cases kings_maxcut800_instance1
```

Default: Four sweeps. Add `--full` for up to 4,096 sweeps. Search stops early if the target is reached.

| File or folder | Use |
|---|---|
| [baseline/](baseline/README.md) | IID top: `kings_baseline_solver`. |
| [epix/](epix/README.md) | EPIX top: `kings_epix_solver`. |
| [src/](src/README.md) | Shared solver code. |
| [coefficients.hex](coefficients.hex) | 800 rows of eight signed 4-bit neighbor weights. |
| [instance.json](instance.json) | Problem data, target, and run settings. |
| [reference.h](reference.h) | Constants and graph tables for the C++ reference. |

- 64 replicas form two 32-temperature ladders for replica exchanges and cluster moves.
- 7 field/score lanes; 7 independent 128 × 40-bit coefficient SRAMs.
- 51,200 private p-bit LFSRs, plus two auxiliary RNGs.
- Spins, LFSR state, and EPIX history use gated registers. Both modes have the same replica and lane counts.

Simulation checks agreement with the reference. Use [area and energy estimation](../../area_energy/README.md) for physical estimates.
