# Variable-size King's-graph baseline and EPIX RTL

This is the active scalable ASIC design. It is a true open-boundary King's
graph, not an all-to-all solver loaded with zero weights. `ROWS` and `COLS`
are compile-time parameters, and the logical p-bit count is `ROWS*COLS`.

The measured 4x4 TSMC28 implementation does **not** save energy with EPIX:
10.55% fewer search clocks were outweighed by 49.2% higher activity-based
power, giving 33.45% higher search energy. Scope, evidence, and comparison
with the GitHub SKY130 handoffs are in [ENERGY_ANALYSIS.md](ENERGY_ANALYSIS.md).

## Directory layout

- `rtl/baseline/`: self-contained baseline solver and physical top.
- `rtl/epix/`: self-contained EPIX solver and physical top.
- `testbench/`: the one shared SystemVerilog testbench, graph generator,
  Python reference, result checker, and run script.
- `flow/`: local constraints and mflowgen invocation notes (not part of the
  compact `Tong` source handoff).
- `results/`: compact measured evidence for the new King's-specific RTL;
  generated netlists, waveforms, and full P&R workspaces stay outside Git.

The simulation tops are `kings_baseline_top` and `kings_epix_top`; their
default size is 10x10. P&R uses `kings_baseline_pnr_top` and
`kings_epix_pnr_top`. The physical wrappers expose indexed state read/write
ports instead of an N-bit chip-level state bus, which keeps the package-level
pin count practical without adding a shadow state bank.

Both modes contain one independently seeded 32-bit LFSR and one state bit per
p-bit: 33 persistent bits per p-bit. EPIX adds exactly one signed 5-bit saved
field and one 2-bit saved sweep tag per p-bit, for 40 persistent bits per
p-bit. It does **not** contain a per-p-bit age counter or per-p-bit valid bit.
Age is reconstructed as the modulo difference between one shared 2-bit sweep
tag and the selected p-bit's saved tag. One shared `history_ready` bit validates
all entries after the mandatory-fresh first sweep. Thus the EPIX-only overhead
is 7 bits per p-bit plus 3 global bits at the default `MAX_REUSE=2`, excluding
shared controller/index registers.

The phrase "2 bits of metadata" refers specifically to the saved age
timestamp; it does not include the 5-bit saved field. The current RTL's
`reuse_age` is a 2-bit combinational wire, so synthesis creates no age-register
array. If `MAX_REUSE` is increased, `TAG_W=$clog2(MAX_REUSE+2)` deliberately
widens the timestamp to avoid ambiguous modulo wraparound.

The older generic module at `../rtl/6_epix_reuse.sv` belongs only to the
legacy 10-p-bit all-to-all `mode=epix` flow. It has a different history
organization and is not compiled or instantiated by `mode=kings_epix`.

Five saved-field bits are lossless for this graph: eight unit-weight King's
neighbors give an inclusive local-field range of -8 through +8, while a signed
4-bit value cannot represent +8. The probability datapath remains 8 bits in
both variants. The selected p-bit's LFSR, saved field, and saved tag share one
clock-enable condition, and all three hold their state on a reuse event.

This follows the compact metadata scheme in the 130-nm handoff. Its `TW=2`
value is a per-p-bit *timestamp*, not a counter: a two-bit subtraction from the
low bits of the global sweep count reconstructs ages 0, 1, 2, or 3, and age 3
forces a refresh before modulo wrap can become ambiguous. The handoff reuses
its existing `dirty` state to force the first sample, so it adds no per-p-bit
valid flag. This implementation instead uses one shared `history_ready` bit.
Although an unweighted degree-six Chimera field would fit in signed four bits
(-6 through +6), the handoff's weighted Chimera128 instance checks a -10
through +10 bound and therefore also needs its signed `FW=5` saved field.

## King's-specific datapath

The local-field engine visits NW, N, NE, W, E, SW, S, and SE. Out-of-boundary
directions contribute zero. Unit antiferromagnetic weights are implicit, so
there is no coefficient programming interface, dense `N x N` register array,
or weight SRAM. One p-bit is updated at a time in row-major order.

All eight directions are reduced in parallel in one `CALCULATE` clock. A
baseline visit then takes one `UPDATE` clock, for two clocks per logical visit.
An EPIX reuse completes directly from `CALCULATE` (one clock); a fresh EPIX
visit proceeds to `UPDATE` (two clocks). With `DELTA_FIELD=0`, reuse is allowed
only for an exactly unchanged local field, the expected deterministic state,
and an age no greater than `MAX_REUSE`.

## Run a variable-size graph

```bash
cd epix_solver_asic/kings_graph_flow
ROWS=10 COLS=10 TRIALS=4 VISITS=20000 ./testbench/run.sh
ROWS=3 COLS=4 TRIALS=2 VISITS=1000 ./testbench/run.sh
```

The script generates and validates the exact rectangular King's topology,
runs the Python model, and runs both RTL variants when Icarus Verilog is on
`PATH`. The RTL/testbench parameters must match the generated dimensions.
For grids whose narrower dimension is at most 12, the generator also computes
the exact MaxCut by row-state dynamic programming. Larger grids still run, but
their graph header records an unknown optimum (`-1`).

The historical dense all-to-all implementation and old K50,50 measurements
are separate from this King's-specific design. Their PPA numbers do not
describe the RTL in this directory.
