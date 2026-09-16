# 26-variable solvers on PYNQ-Z1

Compare IID and EPIX with **one shared LFSR at 100 MHz**. Each family has `lfsr_iid/` and `lfsr_epix/` folders containing a notebook, runner, fixed problem, ready-to-run BIT/HWH/Tcl files, and a portable Vivado project. The two policies within a family use the same FPGA image.

| Folder | Fixed instance | Trial budget |
|---|---|---|
| `maxcut26/` | Weighted Max-Cut, optimum 285 | 1024 full sweeps |
| `chimera26/` | Chimera Ising model, optimum energy −80 | 1024 full sweeps |
| `sat26/` | Planted SAT, 112 ternary clauses | First solution or 26624 variable flips |
| `xorsat26/` | 18 parity constraints, encoded as 72 CNF clauses | First solution or 26624 variable flips |

Every instance uses 26 state variables and no auxiliary variables. SAT and XOR-SAT are the prepared smaller versions of the newer mixed-degree study families; the plotted instances begin at 32 variables. Their native probSAT updates use per-clause residual EPIX with age limit 254. Max-Cut and Chimera use sequential heat-bath updates with field-change threshold 1 and reuse age limit 2.

## Run on PYNQ

Tested with **PYNQ-Z1, PYNQ 2.1 and Python 3.6**. Extract and copy the complete folders:

```sh
tar -xzf pynq_z1_handoff.tar.gz
rsync -av pynq_z1_handoff/ <user>@<board>:~/jupyter_notebooks/epix/
```

Open a folder's `Demo.ipynb` in the board's Jupyter interface and run all cells with the hardware-enabled kernel. Start with `trials = 1`; set `1000` for the full experiment. Run one notebook at a time.

Alternatively, from any policy folder over SSH:

```sh
python3 run.py --check
sudo /opt/python3.6/bin/python3.6 run.py --mode paired --trials 1000
```

Paired mode runs both policies with matching seeds: 2000 trials total. Results appear in `runs/<run-id>/`. `SUMMARY.json` contains averages; `trials.jsonl` contains individual assignments, scores, counters, and timing. Core time comes from the FPGA's 100 MHz counter; host time includes software and polling.

The supplied images passed the paired 1000-trial board runs:

| Family | Policy | Exact hits | Mean RNG words | Mean core time per trial |
|---|---|---:|---:|---:|
| Max-Cut | IID | 1000/1000 | 26650.00 | 23.98 ms |
| Max-Cut | EPIX | 1000/1000 | 18449.91 | 21.28 ms |
| Chimera | IID | 1000/1000 | 26650.00 | 23.98 ms |
| Chimera | EPIX | 997/1000 | 16328.47 | 20.58 ms |
| SAT | IID | 1000/1000 | 87.04 | 0.25 ms |
| SAT | EPIX | 1000/1000 | 55.36 | 0.24 ms |
| XOR-SAT | IID | 1000/1000 | 95.87 | 0.20 ms |
| XOR-SAT | EPIX | 1000/1000 | 54.95 | 0.20 ms |

Mean core time is **per trial**. Ising trials always complete all 1024 sweeps; native SAT/XOR-SAT trials stop at a solution. The Chimera EPIX run uses fewer source words but has three misses in this seed set.

## Rebuild

Install **Vivado 2022.2** with Zynq-7000 support and source `settings64.sh`. From any policy folder:

```sh
python3 vivado/build.py --out /path/to/new/build --jobs 4
```

This opens the portable project. Add `--from-rtl` to recreate it from source. Copy the generated BIT/HWH/plain Tcl and `config.json` from `overlay/` together into a copy of the corresponding demo folder. Keep its notebook, runner, and problem file. Changing a problem requires regenerating its FPGA constants and rebuilding.
