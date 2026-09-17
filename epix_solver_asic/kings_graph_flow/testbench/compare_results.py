#!/usr/bin/env python3
"""Require RTL trial CSVs to match the Python reference exactly."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


def rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--epix", type=Path, required=True)
    args = parser.parse_args()

    reference = rows(args.reference)
    actual = rows(args.baseline) + rows(args.epix)
    if len(reference) != len(actual):
        raise SystemExit(
            f"row-count mismatch: reference={len(reference)} RTL={len(actual)}"
        )
    for expected, observed in zip(reference, actual):
        expected = {**expected, "engine": "rtl"}
        if expected != observed:
            differences = {
                key: (expected.get(key), observed.get(key))
                for key in expected.keys() | observed.keys()
                if expected.get(key) != observed.get(key)
            }
            raise SystemExit(
                f"RTL/reference mismatch mode={expected.get('mode')} "
                f"trial={expected.get('trial')}: {differences}"
            )
    print(f"PASS: {len(actual)} RTL trials exactly match the reference")


if __name__ == "__main__":
    main()
