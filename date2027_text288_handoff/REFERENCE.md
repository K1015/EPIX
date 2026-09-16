# DATE2027 technical reference

[Quick start](README.md) · [Measured results](RESULTS.md)

## Additional checks

From the demo directory, test the board runner using recorded register data (no FPGA access):

```sh
python3 software/test_runner.py
```

With Verilator, GNU make and a C++ compiler installed, run a full first-seed AXI simulation for both policies:

```sh
python3 software/run_rtl.py --output runs/axi_simulation
```

Compare a completed board run with the independent reference:

```sh
python3 software/compare_board.py lfsr_epix/runs/<run-id>
```

Use `--reference runs/software_100` to compare against a fresh software run. From a policy folder, render the captured states with Matplotlib installed:

```sh
python3 view_run.py runs/<run-id> --mode epix --output frames.png
```

## Problem and protocol

For target spins `t_i` in `{−1,+1}`, each four-neighbor grid edge has coupling `J_ij = t_i t_j`. The energy is `H = −sum(J_ij s_i s_j)`. All 540 edges can simultaneously contribute −1, so **H_min = −540**. Connectedness means the only ground states are the bitmap and its global inverse. Signed cut weights are `W = −J`, with maximum cut **167**. See the [certificate](recorded/software/CERTIFICATE.json).

This planted, unfrustrated instance demonstrates image convergence. Its results do not establish performance on difficult arbitrary Max-Cut instances. No auxiliary variables or target clamping are used.

Both policies run 1024 full sequential sweeps, without early stopping. The 100 seeds were fixed before inspecting outcomes. The shared 32-bit Galois LFSR uses mask `0x80200003` and 32 transitions per word. Annealing uses `geomspace(0.1, 4, 1024)`, nearest-even quantization of `8 * beta * field`, and clipping to ±127. EPIX uses field-change threshold 1 and reuse age limit 2. Exact-hit results use the best observed assignment. Times cover the complete fixed-budget run.

## Generate ROMs and rebuild

Recreate the ROMs in a new directory:

```sh
python3 hex_generation/generate.py --output runs/generated_roms
```

The generator defaults to `lfsr_iid/problem.json`; `--input` can select another compatible 288-variable signed graph. It produces the weights, quantization and threshold tables. `verify.py` checks that the supplied instance regenerates byte-for-byte. Merely editing `problem.json` does not change the FPGA image. Supporting a different problem also requires updating target constants, configuration, validation and reference data before rebuilding.

Install Vivado 2022.2 with Zynq-7000 support and source its `settings64.sh`. From either policy directory:

```sh
python3 vivado/build.py --out /absolute/path/to/fresh/build --jobs 4
```

The helper always reconstructs the project from RTL; `--from-rtl` is accepted for compatibility. It checks timing, DRC errors, one shared LFSR and reset wiring, then exports the BIT/HWH/plain Tcl and updated `config.json` in `overlay/`. Copy those four matching files together into a copy of the same policy folder. Keep `problem.json`, the notebook and runner. Rebuilding need not produce a bit-identical image, so retain the new build receipt and rerun the software/board comparisons before reporting new hardware results.

The source names retain the original `maxcut26` module prefix for compatibility; the distributed RTL and ABI implement 288 variables. The build passed its gates but produced warnings; the recorded reports preserve them.

## Trace interface

ABI 6.0 uses design ID `0x4d433236` at AXI base `0x43c00000`. Initial, final and best states are nine little-endian 32-bit words at offsets `0x100`, `0x140` and `0x180`. Bit `i` maps to row `i // 24`, column `i % 24`.

Frames occur at sweeps `0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024`. Frame `f` starts at `0x400 + 64*f`: nine state words, signed current energy, cycles, RNG words, updates, signed best energy, reuse and fresh counts. At `0x200`, bits 4:0 give frame count, bit 5 indicates a write in progress, and bit 6 indicates overflow. Capture uses a 256 × 32 synchronous memory and does not stall the solver.

## Evidence and packaging

Original trial data, software reference, completion receipts and comparison receipts are included unchanged. Host identities and process listings are omitted. Build reports replace private path prefixes and the host name with placeholders; [REPORTS.json](recorded/build/REPORTS.json) records both original and distributed hashes. BIT/HWH/Tcl, RTL and ROM contents are unchanged. Board time was stale; the experiment date, 2026-09-16 UTC, derives from the original host receipts.

The package adapts runner options, notebooks and relative build paths. [VALIDATION.json](VALIDATION.json) records fresh packaging checks separately from historical physical measurements. No new board run or Vivado implementation was performed during packaging. `MANIFEST.json` covers all delivered files except itself and validation reports created by users.
