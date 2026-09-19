# Event-skipping EPIX v2 validation

For the interpretation of the measured energy increase and a comparison with
the GitHub handoffs, see [ENERGY_ANALYSIS.md](../../ENERGY_ANALYSIS.md).
The compact, path-independent numbers are in [energy_summary.csv](energy_summary.csv).
The full simulator VCDs, mapped netlists, P&R workspaces, and raw tool logs
are retained in the local workspace and are not included in the compact
`Tong` source handoff. Paths to those local-only artifacts below are provenance,
not portable links.

These results correspond to the active parallel-field RTL with
`DELTA_FIELD=0` and `MAX_REUSE=2`. Baseline uses two clocks per logical visit
(`CALCULATE`, `UPDATE`). EPIX uses one clock when it reuses and two when it
refreshes, so `epix_cycles = visits + fresh_words`.

## Exact RTL/reference checks

- 4x4: eight paired trials, 2,048 visits each; all 16 RTL trial rows exactly
  matched the Python reference.
- 10x10: four paired trials, 20,000 visits each; all eight RTL trial rows
  exactly matched the Python reference.
- At 10x10, EPIX averaged 16,921.25 fresh words and 36,921.25 clocks versus
  40,000 baseline clocks, a 7.70% cycle reduction for equal visits.

The `rtl_equivalence_*` directories contain the reference rows, RTL rows, and
simulation logs. Compiled simulator binaries are deliberately omitted.

## Fixed-work convergence check

The `convergence` directory contains 64 paired trials per mode and size, with
256 complete sweeps per trial and identical initial states/seeds. `Cut ratio`
below is EPIX mean best cut divided by baseline mean best cut. `Cycle ratio`
is `(1 + EPIX fresh fraction) / 2`.

| P-bits | Grid | Baseline mean best cut | EPIX mean best cut | Cut ratio | EPIX fresh | Cycle ratio |
|---:|:---:|---:|---:|---:|---:|---:|
| 16 | 4x4 | 29.921875 | 29.953125 | 1.00104 | 0.812996 | 0.906498 |
| 64 | 8x8 | 138.093750 | 138.000000 | 0.99932 | 0.839891 | 0.919946 |
| 256 | 16x16 | 650.656250 | 582.125000 | 0.89468 | 0.850671 | 0.925336 |

Exact-field reuse preserves mean fixed-work quality at 16 and 64 p-bits in
this campaign, but it does not preserve quality at 256 p-bits. Therefore a
physical energy reduction at N=16 is an architectural proof point, not yet a
general King’s-graph convergence claim. The GitHub handoff likewise reports a
measured energy benefit for Chimera128 but does not report one for its King’s
case; its King’s solver adds parallel tempering and ICM beyond this local
single-state implementation.

## TSMC28 N=16 physical check (2 ns)

The first complete Innovus run is archived under `pnr_remote/`. Both variants
route with zero DRC markers and meet setup/hold timing. Vectorless power is
reported here only as a P&R sanity check; the energy comparison below uses
mapped-gate VCD activity with 98.9% net annotation coverage.

| Variant | Cell area (um^2) | Setup slack (ns) | Vectorless power (mW) | Gate-VCD power (mW) | Solve cycles | Energy (nJ) |
|:---|---:|---:|---:|---:|---:|---:|
| Baseline | 3224.592 | 0.296 | 1.574188 | 0.693814 | 1024 | 1.420931 |
| EPIX | 3511.536 | 0.305 | 1.820139 | 1.035060 | 916 | 1.896230 |

For this 4x4 workload, EPIX reuses 108 of 512 visits (21.09%) and removes 108
clocks (10.55%), but its average activity-based power is 49.2% higher, so
energy is 33.4% worse. The tiny implicit-unit-weight datapath makes the EPIX
comparison/history logic and clock tree a much larger fraction of the design
than in the handoff's coefficient-SRAM architecture.

The mapped EPIX netlist contains exactly 80 `stored_fields` flops and 32
`stored_tags` flops: `16*(5+2)`. It has no age or valid array. Its other compact
history state is one two-bit global sweep tag and one global history-valid bit.
The total physical register counts (669 baseline, 817 EPIX) also include common
solver/control/statistics registers; EPIX's 32-bit `reuse_events` measurement
counter is instrumentation, not per-p-bit metadata.

The first EPIX mapping used 46 post-route clock gates versus 25 for baseline.
A controlled second P&R run set `lp_clock_gating_max_flops=64` to test whether
the default gate-size limit caused this difference. Genus accepted the setting
but still produced 41 synthesis ICGs and 46 post-route ICGs; area, timing,
vectorless power, mapped activity power, and energy were unchanged to the
reported precision. The ineffective override was therefore removed from the
active flow. The completed negative experiment and reports remain archived in
`pnr_remote/kings-n16-eventskip-icg64-v2-20260918T171319Z-16468-15814/` and
`vector_power_tsmc28p_n16_icg64.csv`.
