# P-bit software benchmarks

504 binary optimization problems, organized into four topology families and six variable counts. The original five sizes contain 25 inputs per family/size group (500 total). The 1,024-variable extension adds one new input per family (four total). Twenty original inputs are identified as the selections used in the EPIX ASIC cases.

| Family | Directory prefix | Problem and connectivity |
|---|---|---|
| King's Max-Cut | `kings_maxcut` | Signed weighted Max-Cut on an open rectangular King's graph |
| Chimera Max-Cut | `chimera_maxcut` | Signed weighted Max-Cut on a planted frustrated-loop subgraph of Chimera |
| 3-SAT | `3hypergraph_sat` | Planted 3-SAT on a random 3-uniform hypergraph |
| 3-XORSAT | `3hypergraph_xorsat` | Planted parity constraints on a connected 3-uniform hypergraph with variable degrees two and three |

All four families use **32, 128, 288, 512, 800 and 1,024 variables**. A variable is one logical binary p-bit. Constraints introduce no additional logical p-bits.

The new inputs are `kings_maxcut1024_instance1`, `chimera_maxcut1024_instance1`, `3hypergraph_sat1024_instance1` and `3hypergraph_xorsat1024_instance1`. They were generated without solver runs. King's uses a 32 by 32 grid; Chimera uses an 8 by 16 array of K_4,4 cells, giving exactly 1,024 variables. SAT has 4,403 clauses and XOR has 683 parity constraints. The new King's target is `null` because its optimum has not been computed. The other three construction records include planted witnesses and bounds.

## Quick start

Python 3.10 or newer is sufficient. The runner and verifier use the Python standard library; no installation or compiler is needed.

```sh
python3 pbit-software-benchmark/run.py --list --group kings_maxcut32
python3 pbit-software-benchmark/run.py --instance kings_maxcut32_instance1 --describe
python3 pbit-software-benchmark/run.py --instance kings_maxcut32_instance1 --seed 1 --sweeps 25
python3 pbit-software-benchmark/run.py --instance 3hypergraph_xorsat32_instance1 --seed 1 --sweeps 25
```

Inspect a new input without starting a solver:

```sh
python3 pbit-software-benchmark/run.py --instance kings_maxcut1024_instance1 --describe
```

The runner uses sequential binary heat-bath updates. Each visit computes `Q = E(x_i=0) - E(x_i=1)` and samples the bit with probability `sigmoid(beta * Q)` using a fresh software random draw. Graph energy is negative signed cut; SAT and XOR energy count violated constraints. SAT/XOR factors are evaluated directly, without extra variables or a pairwise reduction.

This is a portable reference sampler with demonstration settings. Reproducing historical solver performance or EPIX hardware behavior is outside its scope. A run reports `target_reached` explicitly and may finish before finding the optimum. When the optimum is uncomputed, both `target_objective` and `target_reached` are `null`.

To save a run, supply a new output filename:

```sh
python3 pbit-software-benchmark/run.py --instance chimera_maxcut32_instance1 --betas 0.25 0.5 1 2 --sweeps 25 --output pbit-software-benchmark/runs/chimera32_seed1.json
```

The solver reads the problem input and scalar target. Certificate assignments are used only by the verifier, and are never supplied to the sampler.

## Browse the inputs

See the [software index](INDEX.md) and [JSON schema guide](SCHEMA.md). ASIC selections are recorded in each selected input's `asic_case_id` field.

```text
pbit-software-benchmark/
  run.py
  validate.py
  solvers/
  generate_1024.py
  kings_maxcut32/
    kings_maxcut32_instance1/
      problem.json
      certificate.json
    ... kings_maxcut32_instance25/
  ... 23 more family/size groups
```

Each instance folder contains only `problem.json` (connectivity, weights or constraints, topology and construction parameters) and `certificate.json` (available target and witness evidence). Python code is shared across folders. The runner discovers inputs directly from their folder names. Loading an input does not depend on rerunning a generator or accessing the source workspace.

Folder numbering is one-based and follows sorted original cohort keys within each original group. For Chimera, the five original `aadit1000` inputs precede the twenty `uniform25` inputs. All existing ASIC cases select `instance1`, except `chimera_maxcut512`, which selects `instance4`. The four new 1,024-variable inputs have no ASIC selection.

## Validate

```sh
python3 pbit-software-benchmark/validate.py --skip-sampler
```

Validation checks all 504 problem/certificate pairs, topology definitions, mathematical input identities, available witnesses and ASIC-selection mappings. It verifies all Chimera loop bounds against the actual graph and compares local conditional fields with independent full-objective changes. `--skip-sampler` performs no solver runs; omitting this option enables bounded reference-sampler checks. Original King's optimality records retain their integer-DP bounds; the portable check rescores their witnesses without repeating the DP computation. The uncomputed target of the new King's input remains explicitly marked.

The standard-library [1024 generator](generate_1024.py) can reproduce the four new input definitions into a fresh directory without solving them:

```sh
python3 pbit-software-benchmark/generate_1024.py --output /tmp/epix-1024-inputs
```

The original 500 inputs come from the EPIX mixed-problem software cohort; their original IDs and construction details remain in the problem files. The new 1,024-variable groups are generated separately with the recorded seeds.
