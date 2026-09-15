# Future SKY130 measurements

The current stage is software/RTL simulation verification. The steps below describe the later synthesis and measurement runs needed to obtain area, power, latency and energy estimates.

When starting that stage, complete [tool setup](../tools/README.md), then run from the package root. Both modes will use SKY130 HD TT, 1.8 V, 25 °C and 200 ns.

```sh
make check
python3 run.py --profile full --work runs/sky130_full
```

The order is 128, 288, 512, 800, then 32 variables. At each size, the suite processes Max-Cut, Chimera, SAT and XORSAT, with IID before EPIX: 20 problems and 40 designs.

For each case, the runner will:

1. Generate paired software vectors and compare RTL for 1,000 trials per mode at the specified search budget.
2. Synthesize with Yosys/Slang and map cells to SKY130. Check setup, hold, capacitance, transition and constraint coverage at 200 ns.
3. Simulate the mapped designs with Verilator for trials 0–31, check their outcomes and counters, and record FST activity.
4. Count activity at every mapped cell pin. Calculate power with OpenSTA and verify that it retained the supplied activity.
5. Combine power and elapsed cycles to report energy.

Repeat the command with the same work directory to resume a measurement run. The runner will reuse completed stages after checking their source, tool and output hashes, and retain failed attempts' logs. The default uses one case at a time and two compiler workers. Provide at least 20 GiB free space; larger designs and traces need additional capacity. Use `--build-timeout` and `--run-timeout` to allow longer tool runs.

For a short tool check, use `--profile pilot --work runs/sky130_pilot`. It uses three functional and three activity trials per mode and labels its estimates `pilot`.

The runner will create `ENERGY.csv`, `ENERGY.json` and `ENERGY.md` in the work directory as cases finish. Values will be populated only after the measurement runs and required checks pass: area (µm²), mean power (mW), mean latency (µs), mean energy (nJ), successes and completion status for all 40 designs. Reports will include search and setup-plus-search windows, completed unsuccessful trials, and matched IID/EPIX savings. Negative savings will indicate increased cost; pending measurements will remain empty.

Each case's generated `state.json` will identify its detailed timing, activity and power results. The [SKY130 configuration](../tech/README.md) defines the loads and clock conditions. The estimates will cover mapped cells before layout with an ideal root clock.
