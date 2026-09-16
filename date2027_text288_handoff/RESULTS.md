# Recorded PYNQ-Z1 results

The physical experiment on 2026-09-16 used 100 paired seeds, 288 variables, 1024 full sweeps and a 100 MHz clock. All 200 campaign trials and six smoke trials matched the independent software reference, including every captured frame.

| Policy | Exact-target hits | Mean RNG words | Mean full-run core time |
|---|---:|---:|---:|
| IID | 78/100 | 295200.00 | 1812.5165 ms |
| EPIX | 100/100 | 149798.97 | 1764.5342 ms |

EPIX used 49.26% fewer RNG words and 2.65% less core time for this fixed instance. Full-run time is derived from FPGA cycle counts at 100 MHz. It is not time to first solution, host elapsed time or a power measurement. No energy savings are established.

The connected signed grid has 540 edges, certified energy −540 and maximum cut 167. This planted image is an unfrustrated demonstration; arbitrary hard Max-Cut performance is outside the scope of these results. The target and its global inverse are equivalent solutions.

| Routed resource or timing | Result |
|---|---:|
| Slice LUTs | 9730 |
| Slice registers | 15230 |
| Block RAM tiles | 45 |
| DSPs | 0 |
| Setup slack | +0.273 ns |
| Hold slack | +0.030 ns |

The DRC error gate passed. Warnings remain in the [build reports](recorded/build/reports/). The observational trace buffer maps to one RAMB18; the total BRAM count also includes solver storage.

The [animation](figures/fpga_text_convergence.gif) and [hardware figure](figures/hardware_convergence.png) use the first preselected seed, 1560381426. One fixed inversion is applied to all frames in each trajectory. Curves show sampled current energy, which need not decrease monotonically. These pixels are binary states, not analog-voltage measurements.

Evidence: [campaign summary](recorded/board/text288_100/SUMMARY.json), [raw trials](recorded/board/text288_100/trials.jsonl), [software comparison](recorded/board/text288_100/REFERENCE_COMPARISON.json), and [build audit](recorded/build/BUILD_AUDIT.json).
