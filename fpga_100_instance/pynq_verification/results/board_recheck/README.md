# Notebook verification on September 18, 2026

All four 26-variable notebooks executed on the real PYNQ-Z1 at 100 MHz. Each notebook ran one IID/EPIX pair, and all eight trials reached their exact target. The images and fixed inputs were reused without rebuilding.

The executed notebooks are [MaxCut](maxcut.ipynb), [Chimera](chimera.ipynb), [SAT](sat.ipynb) and [XOR-SAT](xorsat.ipynb). Each family folder contains its raw trial records and summary.

Every logged trial field matches its original same-seed board record except host polling duration. The `REFERENCE_COMPARISON.json` file records this comparison. The `NOTEBOOK_VALIDATION.json` file records notebook hashes and outcomes.

The `HOST_RECEIPT.json` file records the actual date because the board clock is stale. The `IDENTITY.json` file records the driver identity from the hardware check. The current driver under `verification/` uses the new package layout.

Published notebooks use relative output paths. The verification receipt retains the original notebook hashes and records the hashes of the sanitized copies. Connection details are represented by named variables in the host receipt. The hardware cells and measured results are unchanged.
