# Cases

These 16 cases compare baseline and EPIX at 130 nm. Chimera512 uses instance 4.

Choose a case below for its command, inputs, and hardware layout.

| Case | Family | Variables |
|---|---|---:|
| [3hypergraph_sat128_instance1](3hypergraph_sat128_instance1/README.md) | 3-SAT | 128 |
| [3hypergraph_sat288_instance1](3hypergraph_sat288_instance1/README.md) | 3-SAT | 288 |
| [3hypergraph_sat512_instance1](3hypergraph_sat512_instance1/README.md) | 3-SAT | 512 |
| [3hypergraph_sat800_instance1](3hypergraph_sat800_instance1/README.md) | 3-SAT | 800 |
| [3hypergraph_xorsat128_instance1](3hypergraph_xorsat128_instance1/README.md) | 3-XOR-SAT | 128 |
| [3hypergraph_xorsat288_instance1](3hypergraph_xorsat288_instance1/README.md) | 3-XOR-SAT | 288 |
| [3hypergraph_xorsat512_instance1](3hypergraph_xorsat512_instance1/README.md) | 3-XOR-SAT | 512 |
| [3hypergraph_xorsat800_instance1](3hypergraph_xorsat800_instance1/README.md) | 3-XOR-SAT | 800 |
| [chimera_maxcut128_instance1](chimera_maxcut128_instance1/README.md) | Chimera MaxCut | 128 |
| [chimera_maxcut288_instance1](chimera_maxcut288_instance1/README.md) | Chimera MaxCut | 288 |
| [chimera_maxcut512_instance4](chimera_maxcut512_instance4/README.md) | Chimera MaxCut | 512 |
| [chimera_maxcut800_instance1](chimera_maxcut800_instance1/README.md) | Chimera MaxCut | 800 |
| [kings_maxcut128_instance1](kings_maxcut128_instance1/README.md) | King's MaxCut | 128 |
| [kings_maxcut288_instance1](kings_maxcut288_instance1/README.md) | King's MaxCut | 288 |
| [kings_maxcut512_instance1](kings_maxcut512_instance1/README.md) | King's MaxCut | 512 |
| [kings_maxcut800_instance1](kings_maxcut800_instance1/README.md) | King's MaxCut | 800 |

Every case contains:

| File or folder | Use |
|---|---|
| `baseline/` | IID top and source list. |
| `epix/` | EPIX top and source list. |
| `src/` | Shared solver code. |
| `coefficients.hex` | Coefficient SRAM contents. |
| `instance.json` | Problem data and run settings. |
| `reference.h` | C++ reference constants. |

Run commands from the [package root](../README.md). Use the exact case name with `--cases`.
