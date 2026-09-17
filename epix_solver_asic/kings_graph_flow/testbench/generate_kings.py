#!/usr/bin/env python3
"""Generate an open-boundary rectangular unit-weight King's graph."""

from __future__ import annotations

import argparse
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, default=10)
    parser.add_argument("--cols", type=int, default=10)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def exact_maxcut(rows: int, cols: int) -> int | None:
    """Return the exact cut using row-state DP when the narrow side <= 12.

    The RTL accepts any dimensions >= 2. Exact scoring is deliberately kept
    optional because row-state DP scales as O(long_side * 4**short_side).
    """

    if cols > rows:
        rows, cols = cols, rows
    if cols > 12:
        return None

    states = 1 << cols
    row_edge_mask = (1 << (cols - 1)) - 1
    horizontal = [
        ((mask ^ (mask >> 1)) & row_edge_mask).bit_count()
        for mask in range(states)
    ]
    scores = horizontal[:]
    for _row in range(1, rows):
        next_scores = [-1] * states
        for current in range(states):
            current_right = current >> 1
            best = -1
            for previous in range(states):
                vertical = (previous ^ current).bit_count()
                diagonal_right = (
                    (previous ^ current_right) & row_edge_mask
                ).bit_count()
                diagonal_left = (
                    ((previous >> 1) ^ current) & row_edge_mask
                ).bit_count()
                best = max(
                    best,
                    scores[previous]
                    + vertical
                    + diagonal_right
                    + diagonal_left,
                )
            next_scores[current] = best + horizontal[current]
        scores = next_scores
    return max(scores)


def kings_edges(rows: int, cols: int) -> list[tuple[int, int]]:
    edges: list[tuple[int, int]] = []
    # Four forward directions enumerate every undirected King move once.
    for row in range(rows):
        for col in range(cols):
            source = row * cols + col
            for delta_row, delta_col in ((0, 1), (1, -1), (1, 0), (1, 1)):
                other_row = row + delta_row
                other_col = col + delta_col
                if 0 <= other_row < rows and 0 <= other_col < cols:
                    edges.append((source, other_row * cols + other_col))
    return edges


def main() -> None:
    args = parse_args()
    if args.rows < 2 or args.cols < 2:
        raise SystemExit("--rows and --cols must both be at least two")

    vertices = args.rows * args.cols
    edges = kings_edges(args.rows, args.cols)
    optimum = exact_maxcut(args.rows, args.cols)
    optimum_field = -1 if optimum is None else optimum
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8") as stream:
        stream.write(f"p edge {vertices} {len(edges)} {optimum_field}\n")
        for source, destination in edges:
            stream.write(f"e {source} {destination} 1\n")

    status = "unknown" if optimum is None else str(optimum)
    print(
        f"wrote King's {args.rows}x{args.cols}: vertices={vertices} "
        f"edges={len(edges)} max_degree=8 exact_maxcut={status} "
        f"path={args.output}"
    )


if __name__ == "__main__":
    main()
