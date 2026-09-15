# SKY130 operating point

The default [configuration](sky130_hd/config_200ns.json) selects the bundled SKY130 high-density TT Liberty file and the same conditions for IID and EPIX.

| Setting | Value |
|---|---|
| Supply / temperature | 1.8 V / 25 °C |
| Clock period | 200 ns (5 MHz) |
| Root clock | Ideal, 0.1 ns transition, 0 ns uncertainty |
| Input transition | 0.1 ns |
| Input / output delay | 0 ns |
| Output load | 0.01 pF per bit |
| Clock gate | `sky130_fd_sc_hd__dlclkp_1` |
| Buffer / input driver | `sky130_fd_sc_hd__buf_4` |
| Maximum clock fanout | 16 |

The flow maps cells, inserts balanced gated-clock buffers and applies the same output-load repair policy to both modes. OpenSTA then checks setup, hold, capacitance, transition and constraint coverage. All retained cells contribute to area and power.

Configuration times use ns and capacitances use pF. The flow reads Liberty units and converts constraints for each tool. These estimates cover mapped cells and explicit pin loads before layout with an ideal root clock.

The configuration records the Liberty and license hashes. Keep [LICENSE.sky130](sky130_hd/LICENSE.sky130) with the library. Upstream source: [SKY130 HD](https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd). Follow the [run instructions](../flow/README.md) to produce the paired reports.
