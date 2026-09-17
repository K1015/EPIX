# SKY130 area and energy

This folder evaluates baseline and EPIX using the supplied 130 nm libraries.

**Flow:** Yosys maps the RTL → Verilator records mapped activity → OpenSTA estimates power. Simulation cycles give latency. Library cell areas give area.

Run from the package root:

```bash
python3 area_energy/run.py check --stage energy --work ../EPIX_130nm_results
python3 area_energy/run.py energy --cases chimera_maxcut128_instance1 --work ../EPIX_130nm_results
```

This relative work path creates a results folder beside the package. Keep source and work paths free of spaces. See [tool setup](tools/README.md) first.

Use `area` instead of `energy` for area only. Use `prepare` to copy sources without CAD tools. Add more names after `--cases`; use `--jobs 2` to limit compilation. Choose a new work folder after changing source files.

| File or folder | Purpose |
|---|---|
| [run.py](run.py) | Check tools, prepare cases and run evaluation. |
| [report.py](report.py) | Collect paired results into `report.json` and `report.csv`. |
| [case_config.json](case_config.json) | Case names, run budgets and hardware counts. |
| [graph/](graph/README.md) | King's MaxCut and Chimera evaluation. |
| [hyper/](hyper/README.md) | SAT and XOR-SAT evaluation. |
| [models/](models/README.md) | Cell models and mapping recipe. |
| [tools/](tools/README.md) | Tool setup, checks and licenses. |
| [example/](example/README.md) | Waveforms and a worked energy/area calculation. |

The operating point is **1.8 V, 25 °C, 5 MHz**. The runner checks timing and uses three paired trials at each case's native budget. Large cases can take substantial time and memory.

**Energy = average power × latency.** Reports separate dynamic and leakage energy. Their sum includes standard cells and SRAM. The explicit SRAM calculation replaces its OpenSTA internal-power term so it is counted once.

`with_setup` covers on-chip coefficient loading, initialization and search. `setup_only` and `search` show the two intervals separately. Each window uses its own activity average, so their chip estimates can differ slightly from the combined estimate.

**Area = standard-cell area + SRAM area.** These are pre-route estimates. They exclude host energy, routed-wire/glitch effects, placement whitespace and die area.

Generated sources, netlists, logs and results stay in the work folder. Reports retain target hits and flag missing or incomplete trials. Only matching completed trials are compared.

Source staging and functional checks passed. New physical evaluation still needs the tools in [tools/](tools/README.md); Yosys and OpenSTA were unavailable on this machine.
