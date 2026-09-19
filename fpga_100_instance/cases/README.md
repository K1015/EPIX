# Problem instances

Each case is stored in `<family>/n<size>/instance<index>/`. The sizes are 08, 14, 20, 26 and 32. Each size contains instances 01 through 05 for every family.

| File | Description |
|---|---|
| `problem.json` | This file defines the graph or native constraints. |
| `certificate.json` | This file provides the exact target and a validating witness. |
| `provenance.json` | This file records the original source or generation seed. |
| `fpga/` | This folder contains the ROMs, clause definitions and required RTL widths. |
| `problem.cnf` | This file represents a native SAT or XOR-SAT case in DIMACS format. |
| `source/` | This folder preserves the original input and certificate for retained cases. |

The `manifest.json` file lists every case and its hashes. The `protocol.json` file records generation rules and solver settings. Witnesses are used only for verification.

The collection retains 58 inputs and generates 42 inputs with fixed seeds. The new 32-variable graphs continue the smaller structural families. Their historical sampling distribution was not reconstructed.

The `sat_n32_i03` case requires five-bit break indices and a 32,768-entry mass ROM. Other native cases use four bits. Read each case's `fpga/parameters.json` before configuring RTL. These tables are not FPGA images.
