# chimera_maxcut512_instance4: shared solver

The [baseline](../baseline/README.md) and [EPIX](../epix/README.md) wrappers use these files.

| File | Use |
|---|---|
| [solver.sv](solver.sv) | Search controller and temperature schedule. |
| [clusters.sv](clusters.sv) | Field/score lanes, private LFSRs, and EPIX reuse decisions. |
| [memory.sv](memory.sv) | Coefficient SRAM22 cells and their clock gates. |
| [spin_state.svh](spin_state.svh) | Spin and invalidation registers, with clock gates. Included inside the solver. |

Build with [baseline/files.f](../baseline/files.f) or [epix/files.f](../epix/files.f).
Keep `.svh` files inside their containing module. Do not compile them separately.

Each p-bit in each replica owns an LFSR in `replica_bank[r].site_bank[i].state`.
Each lane has its own coefficient SRAM port.
Spins, LFSR state, and EPIX history stay in registers outside coefficient SRAM.

For synthesis, define `SYNTHESIS` and link the [130 nm libraries](../../../tech/README.md).
Use `A2_VERIFY` only for simulation observation ports.

Run commands and budgets are in the [case guide](../README.md).
