# 3hypergraph_sat128_instance1: shared solver

The [baseline](../baseline/README.md) and [EPIX](../epix/README.md) wrappers use these files.

| File | Use |
|---|---|
| [a2_core.sv](a2_core.sv) | SAT solver, private LFSRs, reuse logic, and best assignment. |
| [a2_coeff_sram.sv](a2_coeff_sram.sv) | One logical coefficient memory port. |
| [a2_icg.sv](a2_icg.sv) | Clock-gate interface. |
| [technology.sv](technology.sv) | SKY130 clock gates and 19 SRAM22 banks. |
| [threshold.svh](threshold.svh) | Sampling thresholds. Included inside `a2_core`. |

Build with [baseline/files.f](../baseline/files.f) or [epix/files.f](../epix/files.f).
`A2_PHYSICAL` selects the SKY130 gates and SRAMs. Both source lists define it.
Do not compile `threshold.svh` separately.

Each p-bit owns an LFSR in `private_rng[p].state_q`.
SRAM reads take one cycle. Read data holds during writes and idle cycles.
Spins, LFSR state, and EPIX history stay in registers outside coefficient SRAM.

For synthesis, define `SYNTHESIS` and link the [130 nm libraries](../../../tech/README.md).
Use `A2_VERIFY` only for simulation observation ports.

Run commands and budgets are in the [case guide](../README.md).
