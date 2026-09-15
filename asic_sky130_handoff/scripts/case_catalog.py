#!/usr/bin/env python3
"""Check the complete four-family, five-size distribution without CAD tools."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SIZES = (32, 128, 288, 512, 800)
FAMILIES = ("maxcut", "chimera", "sat", "xorsat")
CASE_IDS = tuple(f"{family}{n}" for family in FAMILIES for n in SIZES)
RUN_ORDER = tuple(f"{family}{n}" for n in (128, 288, 512, 800, 32) for family in FAMILIES)


def read(path):
    return json.loads(path.read_text())


def inside(path):
    resolved = path.resolve()
    if not resolved.is_relative_to(ROOT) or not resolved.is_file():
        raise ValueError("Missing or external package dependency: " + str(path))
    return resolved


def verify_catalog():
    catalog = read(ROOT / "CASES.json")
    cases = catalog["cases"]
    ids = [c["case_id"] for c in cases]
    if len(ids) != len(set(ids)) or set(ids) != set(CASE_IDS):
        raise ValueError("Catalog must contain exactly four families at all five sizes")
    for row in cases:
        case = ROOT / "cases" / row["case_id"]
        meta = read(inside(case / "metadata.json"))
        for key in ("case_id", "family", "instance", "logical_variables", "target"):
            if row[key] != meta[key]:
                raise ValueError(f"Catalog/metadata mismatch: {row['case_id']}/{key}")
        expected_id = meta["family"].lower() + str(meta["logical_variables"])
        if expected_id != row["case_id"]:
            raise ValueError("Case name does not match its family and dimension")
        for filename in meta["input_files"]:
            inside(case / filename)
        inside(case / meta.get("certificate_file", "certificate.json"))
        inside(case / "portable.py")
        adapter = read(inside(case / "asic.json"))
        if set(adapter["modes"]) != {"baseline", "epix"}:
            raise ValueError("Every case must provide both hardware modes")
        for mode, design in adapter["modes"].items():
            if not design["rtl"]:
                raise ValueError("Empty RTL source list")
            for source in design["rtl"]:
                inside(case / source)
            if design.get("expected_icg_count", 0) <= 0:
                raise ValueError("Missing clock-gate count: " + row["case_id"] + "/" + mode)
        # Max-Cut128 keeps its driver beside the case inputs.
        simulation = adapter.get("simulation", {})
        driver = simulation.get("driver", "sim_main.cpp" if row["case_id"] == "maxcut128" else "")
        if not driver:
            raise ValueError("Missing simulation adapter: " + row["case_id"])
        inside(case / driver)
    return dict(passed=True, cases=len(cases), hardware_configurations=2 * len(cases),
                sizes=list(SIZES), families=list(FAMILIES))


if __name__ == "__main__":
    print(json.dumps(verify_catalog(), indent=2))
