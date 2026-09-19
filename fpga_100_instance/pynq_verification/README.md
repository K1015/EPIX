# PYNQ-Z1 verification

This package contains complete 26-variable MaxCut, Chimera, SAT and XOR-SAT examples. Each example uses one shared LFSR at 100 MHz and supports IID and EPIX with the same image.

The four Jupyter notebooks passed a hardware check on September 18, 2026. Both modes reached the exact target in every trial, giving eight successful trials. Their states and counters matched the original same-seed board records.

## Run an example

Set the connection variables for your board and copy this folder with `rsync`.

```sh
export BOARD_HOST="<user>@<board>"
export BOARD_DIR="<remote-package-directory>"
rsync -av ./ "$BOARD_HOST:$BOARD_DIR/"
```

The tested environment uses PYNQ 2.1 and Python 3.6. On the board, set `PYNQ_PYTHON` to its hardware-enabled interpreter. The default below matches the tested installation. Run these commands from the package root.

```sh
export PYNQ_PYTHON="${PYNQ_PYTHON:-/opt/python3.6/bin/python3.6}"
./run.sh verify
sudo env "PYTHON=$PYNQ_PYTHON" ./run.sh board all --trials 1
```

You can also open `Demo.ipynb` in any example folder. Each notebook runs one IID/EPIX pair. Run only one notebook or board process at a time.

## Folders

| Folder | Description |
|---|---|
| [examples/](examples/README.md) | This folder contains the four runnable examples and their Vivado projects. |
| [verification/](verification/README.md) | This folder contains the verification scripts and four reference inputs. |
| [results/](results/README.md) | This folder contains the original measurements and executed notebooks. |

The [parent software package](../README.md) contains all 100 inputs and their software tools. The verification tools work independently of the parent software tools. A ZCU102 port still requires the work described in [ZCU102.md](verification/ZCU102.md).

The build guide uses `BUILD_DIR` for generated hardware files. The notebook guide uses `NOTEBOOK_RESULTS_DIR` for new measurements. Choose unused output directories. The scripts derive their package paths from their own location, and Vivado uses its project path variables.
