# Shared 10-pbit SystemVerilog RTL

All synthesizable SystemVerilog for the legacy programmable 10-pbit baseline
and EPIX designs is kept in this directory. The numbered filenames follow the
signal flow and make the intended compile order visible:

| File | Purpose | Used by |
|---|---|---|
| `1_PSL_pkg.sv` | Shared widths and constants | Both |
| `2_local_field_unit.sv` | 15-lane signed local-field adder and saturation | Both |
| `3_rng_lfsr.sv` | 32-bit pseudo-random generator | Both |
| `4_threshold_lut.sv` | Field-magnitude to probability threshold ROM | Both |
| `5_pbit_sampler_baseline.sv` | Fresh random word on every visit | Baseline |
| `5_pbit_sampler_epix.sv` | EPIX word-selection wrapper and sampler | EPIX |
| `6_epix_reuse.sv` | Per-logical-pbit history and refresh policy | EPIX |
| `7_baseline_solver.sv` | Baseline configuration, memory, and run controller | Baseline |
| `8_epix_solver.sv` | EPIX configuration, memory, and run controller | EPIX |

The two sampler modules intentionally have unique names. This permits all nine
SystemVerilog files to be parsed together without duplicate module definitions,
although synthesis should still select only the desired top and its source list.
The canonical source lists are `../baseline/files.f` and `../epix/files.f`.

## Architecture at a glance

Both tops hold `N` logical state bits and update them serially using one physical
local-field/sampler datapath. During RUN, `active_node` advances round-robin and
exactly one state bit is committed per clock. One sweep takes `N` update clocks.
Graph topology is programmed through coefficient rows; zero weights encode
missing edges, so the schedule is the same for all-to-all and King's graphs.

Baseline advances the LFSR and consumes a fresh 32-bit word on every visit.
EPIX may reuse the word previously saved for the active logical p-bit. With the
default `A_MAX=2`, each EPIX history entry contains 32 word bits, 8 stored-field
bits, 2 age bits, and 1 valid bit, or 43 bits per logical p-bit.

Files 5 through 8 contain detailed comments describing the cycle schedule,
coefficient packing, stochastic comparison, EPIX storage, and refresh rules.
