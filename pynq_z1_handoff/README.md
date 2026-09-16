# 26-p-bit Max-Cut on PYNQ-Z1

Compare IID and EPIX using **one shared LFSR at 100 MHz**, with 1024 sweeps per trial. The two folders use the same FPGA image and select different policies:

```text
maxcut26/lfsr_iid/
maxcut26/lfsr_epix/
```

## Run on PYNQ

Tested with **PYNQ-Z1, PYNQ 2.1 and Python 3.6**. Extract the archive and copy the complete demo folders to your board:

```sh
tar -xzf pynq_z1_handoff.tar.gz
rsync -av pynq_z1_handoff/maxcut26/ <user>@<board>:~/jupyter_notebooks/maxcut26/
```

Open either folder's `Demo.ipynb` in the board's Jupyter interface and run all cells. Start with `trials = 1`; use `1000` for the full experiment. Run one notebook at a time with the hardware-enabled kernel.

Alternatively, from either folder over SSH:

```sh
python3 run.py --check
sudo /opt/python3.6/bin/python3.6 run.py --mode paired --trials 1000
```

Paired mode runs both policies with matching seeds: 2000 runs total. Results appear in `runs/<run-id>/`; open `SUMMARY.json` for averages or `trials.jsonl` for individual trials.

Both supplied and freshly rebuilt images passed on the board:

| Policy | Optimum hits | Mean RNG words | Mean core time |
|---|---:|---:|---:|
| IID | 1000/1000 | 26650 | 23.984 ms |
| EPIX | 1000/1000 | 18449.912 | 21.278 ms |

## Rebuild (optional)

The ready-to-run BIT/HWH/Tcl files are beside each notebook. FPGA sources and project files are in `vivado/`.

Install **Vivado 2022.2** with Zynq-7000 support, source `settings64.sh`, then run from either demo folder:

```sh
python3 vivado/build.py --from-rtl --out /path/to/new/build --jobs 4
```

Copy the generated BIT/HWH/plain Tcl and `config.json` from `overlay/` together into a copy of the demo folder. Keep its notebook, runner and problem file. To use a different graph, update the FPGA sources and rebuild the image.
