# 3hypergraph_xorsat800_instance1: EPIX

Top: `xorsat_epix_solver`. Uses the runtime mode input. Set `epix_enable=1` for EPIX.

From the [package root](../../../README.md):

```bash
./run.sh simulate --cases 3hypergraph_xorsat800_instance1 --mode epix
```

| File | Use |
|---|---|
| [xorsat_epix.sv](xorsat_epix.sv) | Top wrapper for the [shared solver](../src/README.md). |
| [files.f](files.f) | Source paths, include path, and `A2_PHYSICAL`. |

Use `-f cases/3hypergraph_xorsat800_instance1/epix/files.f` from the package root. Build one case and mode at a time.

Synthesis: define `SYNTHESIS`, omit `A2_VERIFY`, and link the [130 nm libraries](../../../tech/README.md).
Simulation supplies [cell models](../../../testbench/sky130_models.sv) separately.

See the [case guide](../README.md) for inputs and the full run budget.
