# chimera_maxcut128_instance1

Chimera MaxCut with 128 variables; signed cut target 66.

Run both modes from the [package root](../../README.md):

```bash
./run.sh simulate --cases chimera_maxcut128_instance1
```

Default: Four sweeps. Add `--full` for 13,118 sweeps: 937 at each of 14 temperatures. The smoke run ends before `done`.

| File or folder | Use |
|---|---|
| [baseline/](baseline/README.md) | IID top: `chimera_baseline_solver`. |
| [epix/](epix/README.md) | EPIX top: `chimera_epix_solver`. |
| [src/](src/README.md) | Shared solver code. |
| [coefficients.hex](coefficients.hex) | 128 rows of eight signed 4-bit neighbor weights. |
| [instance.json](instance.json) | Problem data, target, and run settings. |
| [reference.h](reference.h) | Constants and graph tables for the C++ reference. |

- One assignment uses a two-color update schedule.
- 1 field/score lane; 1 independent 128 × 40-bit coefficient SRAM.
- 128 private p-bit LFSRs.
- Spins, LFSR state, and EPIX history use gated registers. Both modes have the same lane count.

Simulation checks agreement with the reference. Use [area and energy estimation](../../area_energy/README.md) for physical estimates.
