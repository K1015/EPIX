# Generate FPGA hex files

Convert software problem inputs into the lookup tables used by the PYNQ RTL. The examples cover Max-Cut, Chimera, SAT and XOR-SAT with 26 variables. IID and EPIX use the same tables.

## Run

Use Python 3.11 or newer. Open a terminal in this directory and run:

```sh
python3 -m pip install -r requirements.txt
python3 generate.py --family maxcut --input examples/maxcut26.json --output generated/maxcut26
```

For the other examples:

```sh
python3 generate.py --family chimera --input examples/chimera26.json --output generated/chimera26
python3 generate.py --family sat --input examples/sat26.cnf --output generated/sat26
python3 generate.py --family xorsat --input examples/xorsat26.json --output generated/xorsat26
```

## Outputs

- **Max-Cut and Chimera:** `weights.hex` stores graph couplings, `quantization_rom.hex` maps local fields to sampling values, and `threshold_rom.hex` stores probability thresholds.
- **SAT and XOR-SAT:** `masses.hex` stores variable-selection weights, and `clauses.svh` contains the problem's clause constants.
- **All examples:** `parameters.json` records the dimensions and settings needed by the RTL.

## Check the results

The check uses the repository's `pynq_z1_handoff` examples. From this directory, run:

```sh
python3 -B verify.py
```

This regenerates the examples and compares all 16 hex files and the clause constants with the existing RTL package.

**Using another problem:** Generate its tables, update the RTL dimensions, clause definitions and target constants as needed, then rebuild the FPGA image.
