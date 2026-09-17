# kings_maxcut800_instance1: IID baseline

Top: `kings_baseline_solver`. Sets `EPIX_ENABLE=0`.

From the [package root](../../../README.md):

```bash
./run.sh simulate --cases kings_maxcut800_instance1 --mode baseline
```

| File | Use |
|---|---|
| [kings_baseline.sv](kings_baseline.sv) | Top wrapper for the [shared solver](../src/README.md). |
| [files.f](files.f) | Source paths, include path, and `EPIX_MODE=0`. |

Use `-f cases/kings_maxcut800_instance1/baseline/files.f` from the package root. Build one case and mode at a time.

Synthesis: define `SYNTHESIS`, omit `A2_VERIFY`, and link the [130 nm libraries](../../../tech/README.md).
Simulation supplies [cell models](../../../testbench/sky130_models.sv) separately.

See the [case guide](../README.md) for inputs and the full run budget.
