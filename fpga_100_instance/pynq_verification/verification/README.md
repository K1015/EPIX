# Verification tools

These checks run locally without programming the FPGA. They require Python 3.6 or later and use Python's standard library.

Set `PYNQ_PYTHON` as described in the [board setup](../README.md) before using the board commands.

```sh
./run.sh verify
./run.sh compare results/board_recheck
```

Run the commands from the package root. The first command checks deployment hashes, ROMs and all 8,000 original trial records. The second command verifies the executed notebooks and compares the eight recent trials with their original same-seed records. Host polling duration is excluded from that comparison.

The `inputs/` folder contains the four reference inputs, certificates and tables needed by these checks. It makes the package independent of the 100-instance collection.

To execute the notebooks again, run this command from the package root on PYNQ-Z1.

```sh
export NOTEBOOK_RESULTS_DIR="$PWD/runs/notebook_check"
sudo env "PYTHON=$PYNQ_PYTHON" ./run.sh notebooks --output "$NOTEBOOK_RESULTS_DIR"
```

The driver uses `nbformat` and `nbconvert` from the tested board environment. It holds the shared board lock and executes one IID/EPIX pair per family. Retrieve the output with `rsync` and pass its directory to `./run.sh compare`.

The verification receipt records the formatting changes to the board runners. Their parsed programs match the original versions. Image and input hashes are still checked directly against the saved board records.
