# DATE2027 — IID

Open `Demo.ipynb` on PYNQ-Z1 or run:

```sh
python3 run.py --check
sudo /opt/python3.6/bin/python3.6 run.py --trials 1
```

This folder defaults to IID. Use `--mode paired --trials 100` for the full paired experiment. Each trial performs 1024 full sweeps. Results use a new `runs/` directory. Copy this whole folder so BIT/HWH/Tcl, config and problem hashes stay matched.

Rebuild with Vivado 2022.2 on PATH: `python3 vivado/build.py --out /absolute/fresh/build --jobs 4`. The helper creates the project from RTL.

See the [full guide](../README.md) for software reproduction, recorded results, trace layout and problem definition.
