# kings_maxcut128_instance1: shared solver

The [baseline](../baseline/README.md) and [EPIX](../epix/README.md) wrappers use these files.

| File | Use |
|---|---|
| [solver.sv](solver.sv) | Search controller, replica exchanges, and cluster moves. |
| [clusters.sv](clusters.sv) | Field/score lanes, private LFSRs, and EPIX reuse decisions. |
| [memory.sv](memory.sv) | Coefficient SRAM22 cells and their clock gates. |
| [spin_state.svh](spin_state.svh) | Spin and invalidation registers, with clock gates. Included inside the solver. |
| [graph_functions.svh](graph_functions.svh) | Exchange thresholds and graph expansion. Included inside `corrected_solver`. |
| [aux_rng.sv](aux_rng.sv) | Separate RNGs for replica exchanges and cluster moves. |

Build with [baseline/files.f](../baseline/files.f) or [epix/files.f](../epix/files.f).
Keep `.svh` files inside their containing module. Do not compile them separately.

Each p-bit in each replica owns an LFSR in `replica_bank[r].site_bank[i].state`.
Each lane has its own coefficient SRAM port.
Spins, LFSR state, and EPIX history stay in registers outside coefficient SRAM.

For synthesis, define `SYNTHESIS` and link the [130 nm libraries](../../../tech/README.md).
Use `A2_VERIFY` only for simulation observation ports.

Run commands and budgets are in the [case guide](../README.md).
