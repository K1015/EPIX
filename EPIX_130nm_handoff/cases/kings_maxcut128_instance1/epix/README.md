# kings_maxcut128_instance1: EPIX

Top: `kings_epix_solver`. Sets `EPIX_ENABLE=1`.

From the [package root](../../../README.md):

```bash
./run.sh simulate --cases kings_maxcut128_instance1 --mode epix
```

| File | Use |
|---|---|
| [kings_epix.sv](kings_epix.sv) | Top wrapper for the [shared solver](../src/README.md). |
| [files.f](files.f) | Source paths, include path, and `EPIX_MODE=1`. |

Use `-f cases/kings_maxcut128_instance1/epix/files.f` from the package root. Build one case and mode at a time.

Synthesis: define `SYNTHESIS`, omit `A2_VERIFY`, and link the [130 nm libraries](../../../tech/README.md).
Simulation supplies [cell models](../../../testbench/sky130_models.sv) separately.

See the [case guide](../README.md) for inputs and the full run budget.
