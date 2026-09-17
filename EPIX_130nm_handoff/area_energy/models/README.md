# Simulation models

The runner copies these models into the work folder. Solver RTL is in [cases/](../../cases/README.md); timing and power libraries are in [tech/](../../tech/README.md).

| File | Purpose |
|---|---|
| [mapping.abc](mapping.abc) | ABC logic-mapping steps. |
| [cells_sim.v](cells_sim.v) | Graph standard-cell simulation models. |
| [graph_models.sv](graph_models.sv) | Graph SRAM and clock-gate models. |
| [graph_power_models.sv](graph_power_models.sv) | Graph models that also record SRAM activity. |
| [hyper_power_models.sv](hyper_power_models.sv) | SAT/XOR-SAT models that record SRAM activity. |
| [sram22_128x40m4w20.sv](sram22_128x40m4w20.sv) | SAT/XOR-SAT SRAM simulation model. |
| [sky130_fd_sc_hd__dlclkp_1.sv](sky130_fd_sc_hd__dlclkp_1.sv) | SAT/XOR-SAT clock-gate simulation model. |

These models provide logic behavior and activity counts. Liberty tables provide physical energy values. The SAT/XOR-SAT flow generates its standard-cell models in the work folder.
