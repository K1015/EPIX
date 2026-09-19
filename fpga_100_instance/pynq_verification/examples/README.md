# Board examples

Each family folder contains a fixed 26-variable example. The BIT, HWH and Tcl files form a matching deployment set. The runner uses `problem.json` and `config.json` to check the image, seeds and hardware settings.

Run these commands from the package root on PYNQ-Z1.

Set `PYNQ_PYTHON` as described in the [board setup](../README.md) before using the board commands.

```sh
./run.sh board maxcut --check
sudo env "PYTHON=$PYNQ_PYTHON" ./run.sh board maxcut --trials 1
```

Replace `maxcut` with `chimera`, `sat` or `xorsat` to select another family. Use `all` to run them sequentially. Each example writes new measurements into its own `runs/` folder. Use `--trials 1000` to repeat the original paired campaign.

Graphs complete 1,024 sweeps per trial. SAT and XOR-SAT stop on a solution or after 26,624 flips.

## Rebuild an image

Use Vivado 2022.2 with Zynq-7000 support and source `settings64.sh`. Run this command from the package root on the build host.

```sh
export BUILD_DIR="$PWD/build/maxcut"
python3 examples/maxcut/vivado/build.py --from-rtl --out "$BUILD_DIR" --jobs 4
```

Copy the matching BIT, HWH, plain Tcl and `config.json` files from the new build's `overlay/` folder into a copy of the example. Keep the runner, notebook and problem file together. Changing the input requires updating the RTL and runner before rebuilding.
