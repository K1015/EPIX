# EPIX problem instances

This package contains five instances of MaxCut, Chimera, SAT and XOR-SAT at each of 8, 14, 20, 26 and 32 variables. The 100 instances use no auxiliary variables.

## Start here

Run these commands from this folder.

```sh
python3 -m pip install -r requirements.txt
./run.sh list
./run.sh verify
./run.sh software --instance sat_n32_i03 --trials 3 --output runs/sat32
```

## Folders

| Folder | Description |
|---|---|
| [cases/](cases/README.md) | This folder contains the inputs, exact targets and FPGA tables. |
| [hex_generation/](hex_generation/README.md) | This folder contains the table generator. |
| [testbench/](testbench/README.md) | This folder contains the software runners and validation tools. |
| [pynq_verification/](pynq_verification/README.md) | This folder contains the PYNQ-Z1 examples and hardware verification. |

The [PYNQ-Z1 verification folder](pynq_verification/README.md) contains the four board examples, Vivado sources, notebooks and hardware results. It is not required to run this software package.

All 100 inputs pass software checks. Running another instance on an FPGA requires configuring its RTL and building an image. Software results do not measure FPGA execution time.

Python scripts resolve their package root from `__file__`. Shell runners resolve it from their own location. The [board setup](pynq_verification/README.md) defines the configurable connection, interpreter and output path variables.
