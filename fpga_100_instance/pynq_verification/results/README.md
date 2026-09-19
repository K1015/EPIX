# Hardware results

The `original/` folder contains 1,000 paired trials per family from the original PYNQ-Z1 campaigns. The table reports those measurements.

| Family | IID hits | EPIX hits | Fresh-word saving | Core-time saving |
|---|---:|---:|---:|---:|
| MaxCut | 1000/1000 | 1000/1000 | 30.77% | 11.28% |
| Chimera | 1000/1000 | 997/1000 | 38.73% | 14.20% |
| SAT | 1000/1000 | 1000/1000 | 36.39% | 5.15% |
| XOR-SAT | 1000/1000 | 1000/1000 | 42.68% | 1.84% |

The [September 18 notebook check](board_recheck/README.md) contains one IID/EPIX pair per family. All eight trials reached the target. This check verifies functionality and is not a new performance campaign.

The `board_examples.json` file records the deployment and historical-result checks. The original raw records and receipts are preserved. No additional physical trials were run while separating this package.
