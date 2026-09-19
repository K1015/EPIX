# Generate FPGA tables

Run these commands from the package root and choose new output directories.

```sh
./run.sh hex --family maxcut --input cases/maxcut/n32/instance01/problem.json --output runs/maxcut32_roms
./run.sh hex --family sat --input cases/sat/n32/instance03/problem.cnf --break-bits 5 --output runs/sat32_roms
```

The graph exporter produces weights, quantization and threshold ROMs. The SAT and XOR-SAT exporter produces a mass ROM and clause definitions. The `parameters.json` file records dimensions and address widths. All packaged XOR-SAT inputs already include their CNF expansion.

The `sat_n32_i03` case requires `--break-bits 5`. Other native cases use the default four bits. Update the RTL constants, memory dimensions and host settings before rebuilding hardware. This command produces data files and does not build a bitstream.
