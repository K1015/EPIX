# SKY130 libraries

These files provide the cell timing, power and area data used by the 130 nm flow.

| File | Purpose |
|---|---|
| [sky130_hd.lib](sky130_hd.lib) | Standard-cell timing, power and area. |
| [sram22_128x40.lib](sram22_128x40.lib) | SRAM22 timing, power and area for one 128 × 40-bit macro. |
| [LICENSE.sky130](LICENSE.sky130) | License supplied with the standard-cell library. |

The libraries use 1.8 V and 25 C. The evaluation uses a 200 ns clock period (5 MHz).

SRAM stores coefficients. Spins, LFSRs and EPIX history use registers. SRAM reads take one cycle; output holds during writes and idle time.

Area includes standard cells plus SRAM macros, counted once. The libraries support pre-route analysis; they are not a complete physical-design kit.

The SRAM view is retained from the existing experiments. No additional license grant is asserted for it. See [the evaluation guide](../area_energy/README.md).
