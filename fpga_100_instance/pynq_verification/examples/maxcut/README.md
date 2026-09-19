# MaxCut on PYNQ-Z1

This example solves a fixed 26-variable instance with one shared LFSR at 100 MHz. IID and EPIX use the same image.

Run these commands from this folder on the board.

Set `PYNQ_PYTHON` as described in the [board setup](../../README.md) before using the board commands.

```sh
python3 run.py --check
sudo "$PYNQ_PYTHON" run.py --mode paired --trials 1
```

You can also open `Demo.ipynb` to run one pair. Set `--trials 1000` to repeat the original campaign. New measurements are written to `runs/`.

The `vivado/` folder contains the complete project, RTL, ROMs and rebuild scripts. The `problem.json` and `config.json` files describe the fixed input and deployment. This input corresponds to `maxcut/n26/instance01` in the 100-instance collection.

Read the [build guide](../README.md) for rebuilding. The [results folder](../../results/README.md) contains the original measurements and the latest executed notebook.
