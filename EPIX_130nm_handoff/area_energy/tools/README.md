# Tool setup and checks

Install Python 3.9+, make, a C++17 compiler, Yosys with Slang/ABC, Verilator and OpenSTA. CAD executables are not bundled.

Set `YOSYS`, `VERILATOR` and `OPENSTA` if the executables are outside `PATH`.

Energy also needs SAIF-capable Verilator and matching runtime headers. Set `EPIX_VERILATOR_ROOT` (or `VERILATOR_ROOT`) to the folder containing `include/verilated_saif_c.h` and `.cpp`. The original flow used Verilator 5.053. Runtime changes stay in a generated copy.

OpenSTA must preserve explicit pin activity during power reports. If needed, apply [power_activity.patch](power_activity.patch) to revision `d97587f669b4f169be7132346df70e7d634500c3`, then build using that revision's instructions. The checks below establish compatibility.

From the package root:

```bash
python3 area_energy/run.py check --stage energy --work ../EPIX_130nm_results
```

Use `--stage area` to check only mapping/timing requirements. Missing tools or failed checks stop evaluation. Logs go to `../EPIX_130nm_results_checks/`; evaluation runs keep them in `checks/`.

| File | Purpose |
|---|---|
| [verify_opensta.py](verify_opensta.py) | Check 15 pin annotations after two power reports. |
| [test_readback.py](test_readback.py) | Test units and rejection of missing/mismatched activity. |
| [activity.py](activity.py) | Generate and check test activity. |
| [pin_activity.v](pin_activity.v) | Small test circuit. |
| [pin_activity.tcl](pin_activity.tcl) | Annotate the circuit and inspect OpenSTA results. |
| [power_activity.patch](power_activity.patch) | Preserve explicit activity in OpenSTA. |
| [LICENSE.OpenSTA](LICENSE.OpenSTA), [LICENSE.LZ4](LICENSE.LZ4) | Licenses for supplied support material. |

These are tool checks, not experiment results.
