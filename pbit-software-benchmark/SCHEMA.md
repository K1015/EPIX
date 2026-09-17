# Problem JSON format

Every instance folder has two files: `problem.json` and `certificate.json`. All node IDs in `problem.json` are **zero-based**, from 0 through `n_variables - 1`. All assignments use values 0 and 1.

## problem.json

| Field | Meaning |
|---|---|
| `schema_version` | `epix.problem.v1` |
| `instance_id`, `group` | Public folder name and family/size group |
| `original_instance_id`, `original_cohort_key` | Original identifiers, preserved through the rename |
| `source_family` | `kings`, `chimera`, `sat` or `xor` |
| `problem_type` | `signed_weighted_maxcut`, `3sat` or `3xorsat` |
| `n_variables`, `node_index_base`, `variable_domain` | Logical variable count and indexing/domain conventions |
| `objective` | Objective name, optimization direction, target or `null`, and energy convention |
| `topology` | Topology name, dimensions, actual degree histogram and edge/factor counts |
| `construction` | Generation method, seed, parameters and original generator-file hash |
| `mathematical_problem_sha256` | Canonical digest of the exact signed edges or constraints; stable under the new folder naming |
| `asic_case_id` | Matching ASIC case ID, or `null` for an input not selected for hardware |

**Signed weighted Max-Cut:** `edges` contains `[source, destination, weight]` rows. Each undirected edge appears once. The objective is `sum(weight * (x[source] != x[destination]))`, maximized. Positive weights favor different groups; negative weights favor the same group. The reference runner minimizes the negative of this objective.

King's graphs include every horizontal, vertical and diagonal edge on the recorded open grid. `rows` and `columns` retain the original orientation for node numbering. The short-by-long dimensions are 4 by 8, 8 by 16, 12 by 24, 16 by 32, 20 by 40, and 32 by 32.

Chimera uses an R by C array of K_4,4 cells, with `N = 8 R C`. The original five sizes use square arrays (`R = C`). The 1,024-variable case uses `R = 8`, `C = 16`; a square array cannot have exactly 1,024 variables. Signed frustrated-loop couplings are aggregated and zero sums omitted. Its stored graph is therefore a subgraph of the full lattice. Some declared variables can have zero nonzero-weight degree; they remain part of the generated input.

**3-SAT:** each entry in `constraints` has `variables: [a,b,c]` and `signs: [s_a,s_b,s_c]`. A sign of +1 means the positive literal and -1 means negation. For example, variables `[0,2,6]` and signs `[1,-1,1]` represent `x0 OR NOT x2 OR x6`. The objective counts unsatisfied clauses. Clauses remain separate even if multiple clauses use the same variable triple.

**3-XORSAT:** each constraint has `variables: [a,b,c]` and `parity: z`. Its rule is `x[a] XOR x[b] XOR x[c] == z`. The objective counts violated parity constraints. There are 22, 86, 193, 342, 534 and 683 constraints at the six sizes. Each variable occurs twice or three times. The exact CNF conversion uses four clauses per parity constraint and adds no variables; the stored representation uses the native parity constraints.

“3-uniform” means that every constraint contains exactly three distinct variables. A factor-graph drawing would add constraint nodes for visualization; those nodes are not extra stochastic variables.

## certificate.json

The file binds its witness assignment and scalar target to the mathematical input hash. For SAT/XOR, a satisfying witness reaches the lower bound of zero violated constraints. For King's Max-Cut, the retained original DP record supplies the optimum claim, with its source hash and witness. For Chimera, signed cycle data show that the witness reaches every loop upper bound and that the loop sum reconstructs the exported graph.

The new King's 1,024-variable input has `target: null`, `witness: null`, and evidence kind `target_not_computed`. These values mean the optimum was not computed. They do not imply a zero target or an unsuccessful solver run. The other three new inputs have construction-derived witnesses; no optimizer was used to obtain them. Each new problem's `construction` records `optimization_run: false`.

In a Chimera loop, `edge_weights[k]` belongs to the edge from `cycle_nodes[k]` to the next node, wrapping back to the first node at the end. Zero aggregate couplings are removed only after all loops have been summed.

## Mathematical identity

The mathematical digest retains the original audit convention: sort each factor's one-based signed variable tuple, pair it with its edge weight or XOR parity (zero for SAT), sort the records, and hash compact JSON `[source_family, records]` with SHA-256. SAT signs and XOR parities therefore remain part of the identity. Source paths and hashes identify the original construction or certificate; they are not runtime dependencies.
