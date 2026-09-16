# DATE2027 ROM generation

From the parent directory:

```sh
python3 -m pip install -r hex_generation/requirements.txt
python3 hex_generation/generate.py --output runs/generated_roms
python3 verify.py
```

The fixed default input is `lfsr_iid/problem.json`. The supplied `lut32.json` contains 128 unsigned thresholds. The generator emits signed 4-bit weights, 1024 × 128 quantization entries and 256 thresholds, with the original rounding and comparison conventions. The output directory must be new.

`--input` accepts a JSON graph with 288 variables, zero external fields, a symmetric zero-diagonal `J` matrix or signed-cut `edges`, signed 4-bit couplings and absolute row sums at most 63. New problems require corresponding target constants, configuration, reference data and a rebuilt image; generating tables alone does not update the hardware.
