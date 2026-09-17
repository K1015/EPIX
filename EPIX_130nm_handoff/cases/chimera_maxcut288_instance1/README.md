# chimera_maxcut288_instance1

Chimera MaxCut with 288 variables; signed cut target 150.

Run both modes from the [package root](../../README.md):

```bash
./run.sh simulate --cases chimera_maxcut288_instance1
```

Default: Four sweeps. Add `--full` for 13,118 sweeps: 937 at each of 14 temperatures. The smoke run ends before `done`.

| File or folder | Use |
|---|---|
| [baseline/](baseline/README.md) | IID top: `chimera_baseline_solver`. |
| [epix/](epix/README.md) | EPIX top: `chimera_epix_solver`. |
| [src/](src/README.md) | Shared solver code. |
| [coefficients.hex](coefficients.hex) | 288 rows of eight signed 4-bit neighbor weights. |
| [instance.json](instance.json) | Problem data, target, and run settings. |
| [reference.h](reference.h) | Constants and graph tables for the C++ reference. |

- One assignment uses a two-color update schedule.
- 3 field/score lanes; 3 independent 128 × 40-bit coefficient SRAMs.
- 288 private p-bit LFSRs.
- Spins, LFSR state, and EPIX history use gated registers. Both modes have the same lane count.

Simulation checks agreement with the reference. Use [area and energy estimation](../../area_energy/README.md) for physical estimates.
