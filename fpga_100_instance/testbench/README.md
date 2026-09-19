# Software and verification

Run these commands from the package root. Generation and input checks require Python 3.9 or later and NumPy. The paired runner uses Python's standard library. Exact certification and independent model checks also require a C11 compiler.

```sh
./run.sh verify --check-exact-solver
./run.sh software --trials 3 --output runs/all100
./run.sh models --smoke runs/all100
./run.sh prepare --output runs/regenerated_cases
./run.sh verify --cases runs/regenerated_cases
```

Use new output directories for software runs and regeneration.

| Folder | Description |
|---|---|
| `software/` | This folder contains the paired IID/EPIX runner and native reference. |
| `tools/` | This folder contains the input generator, exact graph solver and independent C checks. |
| `validation/` | This folder contains saved checks and raw software trials. |

Graphs run 1,024 sweeps. SAT and XOR-SAT stop on a solution or after 1,024 × N flips. Both modes start from the same seed and use one shared serial LFSR.

The saved smoke run contains three pairs per case and reaches the target in 598 of 600 trials. Both misses occur for IID on `chimera_n32_i04`. Model checks compare all 300 native trials with C and replay 24 small reference records from the earlier board runs. The software seeds differ from the original board seed list.

Hardware images and executed notebooks are stored in the `pynq_verification/` folder at the package root. They are not required for these checks.
