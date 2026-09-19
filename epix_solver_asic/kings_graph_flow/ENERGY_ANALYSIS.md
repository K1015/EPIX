# Why this King's-graph EPIX design has no measured energy saving

This conclusion applies to the completed **16-p-bit (4x4), TSMC28, 500 MHz**
comparison below. It is not a claim that EPIX cannot save energy on a larger
King's graph, another workload, or another PDK. The paired run used the same
initial state, seed, 512 logical visits (32 sweeps), and an exact-field reuse
rule (`DELTA_FIELD=0`, `MAX_REUSE=2`). Both implementations passed the RTL
reference checks and finished P&R with zero DRC markers and timing closure.

| Metric | Baseline | EPIX | EPIX change |
|---|---:|---:|---:|
| Logical visits | 512 | 512 | equal work |
| Fresh RNG words | 512 | 404 | 108 fewer |
| Reused visits | 0 | 108 | 21.09% of visits |
| Search clocks | 1,024 | 916 | 10.55% fewer |
| Cell area (um^2) | 3,224.592 | 3,511.536 | 8.90% larger |
| Post-route clock gates | 25 | 46 | 21 more |
| Post-route registers | 669 | 817 | 148 more |
| Activity-based internal power (mW) | 0.449366 | 0.661331 | 47.2% higher |
| Activity-based switching power (mW) | 0.224447 | 0.351692 | 56.7% higher |
| Activity-based leakage power (mW) | 0.020001 | 0.022037 | 10.2% higher |
| Activity-based total power (mW) | 0.693814 | 1.035060 | 49.2% higher |
| Search time at 2 ns/clock (us) | 2.048 | 1.832 | 10.55% shorter |
| Search energy (nJ) | 1.420931 | 1.896230 | 33.45% higher |

Energy is average power multiplied by search time. For EPIX to break even at
916 clocks, its average power would have to be below **0.775617 mW**; the
measured value is **1.035060 mW**. The clock reduction therefore does not
compensate for its higher power. Vectorless power is not used in this energy
calculation. The activity comes from a zero-delay gate-level VCD annotated on
the post-route checkpoint, with about 99% matched nets. It does not model
wire-delay glitches or prove an on-silicon power value.

## Architectural explanation and limits of attribution

Both variants have one 32-bit LFSR and one spin bit per p-bit, and only the
selected LFSR bank advances on a fresh update. On reuse, EPIX holds that bank
and completes a visit in `CALCULATE`, bypassing the `UPDATE` clock. This is a
**stage bypass, not an overlapped pipeline**. It saves 108 clocks in this run.

EPIX also stores a 5-bit field and 2-bit sweep tag per p-bit: 112 history
flops at N=16. It needs the field comparison, age subtraction, reuse control,
and a 32-bit `reuse_events` instrumentation counter that the baseline can
optimize away. Its post-route implementation has more clock gates and higher
measured internal and switching power. These are plausible sources of the
overhead; the current power reports do **not** isolate a precise per-block
energy contribution, so the table should not be read as proving which single
block dominates. Changing the ICG maximum-flop setting from its default to
64 produced the same mapped gate count and PPA, so that particular setting
did not resolve the difference.

The graph has implicit unit weights and only eight possible neighbors. Its
field computation is small and has no coefficient SRAM. Consequently the
reuse machinery is a relatively large fraction of this 16-p-bit design. The
RTL stores fewer EPIX metadata bits per node than the Chimera128 example in
`asic_sky130_handoff` (7 versus 18), so an oversized saved-word register is
**not** the explanation here.

## Why the GitHub result is not an apples-to-apples comparison

The current [asic_sky130_handoff README](https://github.com/K1015/EPIX/blob/main/asic_sky130_handoff/README.md)
explicitly says its SKY130 PPA estimates are pending. Its Chimera RTL uses a
64-node color update and four RNG service banks; each bank serves only nodes
requiring a fresh word, and the color commits when the banks finish. That
architecture can save RNG-service activity and sometimes whole service
clocks. Our King implementation visits one node at a time. SAT and XOR-SAT in
that package use yet another retained-randomness mechanism.

The reported Chimera128 benefit is in the separate
[EPIX_130nm_handoff](https://github.com/K1015/EPIX/blob/main/EPIX_130nm_handoff/README.md):
an archived, **pre-route 5 MHz SKY130** estimate of 101.277 to 88.031 uW
average power, 8,474,751 to 7,599,610 clocks, and 171,659.906 to
133,799.840 nJ total energy (22.06% saving), including coefficient SRAM and
setup. Its different workload, architecture, operating point, and power
model cannot be used to infer savings for this TSMC28 King RTL. The archived
breakdown shows lower standard-cell internal and output-switching energy;
SRAM internal energy is essentially unchanged. Attributing those reductions
to a specific RTL block would require a matched block-level power study.

## Reproduction evidence and next measurement

The portable [paired summary](results/event_skip_v2/energy_summary.csv) and
[validation notes](results/event_skip_v2/README.md) record the completed run.
The larger-size convergence check in those notes is also important: at N=256,
the current exact-field reuse rule reduced mean fixed-work cut quality, so a
future energy-per-solution comparison must enforce a matched target quality,
not just equal visit counts. The next useful experiment is a matched,
activity-based per-block power report at a larger King size, with production
instrumentation removed from both variants and convergence checked at the
same target. No such larger post-route result is claimed here.
