#!/usr/bin/env python3
"""Reference model for the variable-size King's-graph baseline and EPIX RTL."""

from __future__ import annotations

import argparse
import csv
import json
from dataclasses import asdict, dataclass
from pathlib import Path
from statistics import mean


MASK32 = (1 << 32) - 1
FIELD_CYCLES = 1
BASELINE_CYCLES_PER_UPDATE = 2


@dataclass(frozen=True)
class Graph:
    rows: int
    cols: int
    vertices: int
    edges: tuple[tuple[int, int], ...]
    optimum: int
    adjacency: tuple[tuple[int, ...], ...]


@dataclass
class Trial:
    engine: str
    mode: str
    rows: int
    cols: int
    n: int
    edges: int
    optimum: int
    trial: int
    seed_hex: str
    initial_hex: str
    visit_budget: int
    best_cut: int
    success: int
    first_hit_updates: int
    first_hit_cycles: int
    first_hit_fresh_words: int
    final_fresh_words: int
    final_reuse_events: int
    total_cycles: int


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, required=True)
    parser.add_argument("--cols", type=int, required=True)
    parser.add_argument("--graph", type=Path, required=True)
    parser.add_argument("--mode", choices=("baseline", "epix", "both"), default="both")
    parser.add_argument("--trials", type=int, default=4)
    parser.add_argument("--visits", type=int, default=20_000)
    parser.add_argument("--prob-gain", type=int, default=1024)
    parser.add_argument("--delta-field", type=int, default=0)
    parser.add_argument("--max-reuse", type=int, default=2)
    parser.add_argument("--campaign-seed", type=lambda x: int(x, 0), default=0x97128127)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--summary", type=Path, required=True)
    return parser.parse_args()


def expected_edges(rows: int, cols: int) -> set[tuple[int, int]]:
    edges: set[tuple[int, int]] = set()
    for row in range(rows):
        for col in range(cols):
            source = row * cols + col
            for delta_row, delta_col in ((0, 1), (1, -1), (1, 0), (1, 1)):
                other_row = row + delta_row
                other_col = col + delta_col
                if 0 <= other_row < rows and 0 <= other_col < cols:
                    edges.add((source, other_row * cols + other_col))
    return edges


def read_graph(path: Path, rows: int, cols: int) -> Graph:
    vertices = edge_count = optimum = None
    actual: set[tuple[int, int]] = set()
    with path.open(encoding="utf-8") as stream:
        for line_number, raw in enumerate(stream, 1):
            fields = raw.split()
            if not fields or fields[0].startswith("#"):
                continue
            if fields[0:2] == ["p", "edge"] and len(fields) == 5:
                vertices, edge_count, optimum = map(int, fields[2:])
            elif fields[0] == "e" and len(fields) == 4:
                u, v, weight = map(int, fields[1:])
                if weight != 1:
                    raise ValueError(f"{path}:{line_number}: King's weight must be one")
                edge = (min(u, v), max(u, v))
                if edge in actual:
                    raise ValueError(f"{path}:{line_number}: duplicate edge {edge}")
                actual.add(edge)
            else:
                raise ValueError(f"{path}:{line_number}: malformed graph line")

    expected = expected_edges(rows, cols)
    if vertices != rows * cols:
        raise ValueError(f"graph has {vertices} vertices; expected {rows * cols}")
    if edge_count != len(actual):
        raise ValueError(f"header says {edge_count} edges; found {len(actual)}")
    if actual != expected:
        missing = sorted(expected - actual)[:4]
        extra = sorted(actual - expected)[:4]
        raise ValueError(f"not a {rows}x{cols} King's graph: missing={missing}, extra={extra}")

    adjacency: list[list[int]] = [[] for _ in range(vertices)]
    for u, v in sorted(actual):
        adjacency[u].append(v)
        adjacency[v].append(u)
    return Graph(
        rows, cols, vertices, tuple(sorted(actual)), int(optimum),
        tuple(tuple(neighbors) for neighbors in adjacency),
    )


def lcg_step(value: int) -> int:
    return (1_664_525 * value + 1_013_904_223) & MASK32


def lfsr_step(value: int) -> int:
    feedback = ((value >> 31) ^ (value >> 21) ^ (value >> 1) ^ value) & 1
    result = ((value << 1) & MASK32) | feedback
    return result or 1


def pbit_seed(base_seed: int, node: int) -> int:
    salt = (0x9E3779B9 * (node + 1)) & MASK32
    return ((base_seed & MASK32) ^ salt) | 1


def make_campaign(graph: Graph, trials: int, campaign_seed: int) -> list[tuple[int, int]]:
    prng = campaign_seed & MASK32
    campaign: list[tuple[int, int]] = []
    for _ in range(trials):
        prng = lcg_step(prng)
        seed = prng | 1
        initial = 0
        for node in range(graph.vertices):
            prng = lcg_step(prng)
            initial |= ((prng >> 31) & 1) << node
        campaign.append((seed, initial))
    return campaign


def cut_score(graph: Graph, state: list[int]) -> int:
    return sum(1 for u, v in graph.edges if state[u] != state[v])


def run_trial(
    graph: Graph,
    mode: str,
    trial_index: int,
    seed: int,
    initial: int,
    visits: int,
    prob_gain: int,
    delta_field: int,
    max_reuse: int,
) -> Trial:
    n = graph.vertices
    state = [(initial >> node) & 1 for node in range(n)]
    current_cut = cut_score(graph, state)
    best_cut = current_cut
    hit_update = 0 if graph.optimum >= 0 and current_cut == graph.optimum else -1
    hit_cycles = 0 if hit_update == 0 else -1
    hit_fresh = 0 if hit_update == 0 else -1
    pbit_rngs = [pbit_seed(seed, node) for node in range(n)]
    stored_fields = [0] * n
    tag_width = max(1, (max_reuse + 1).bit_length())
    tag_mask = (1 << tag_width) - 1
    stored_tags = [0] * n
    sweep_tag = 0
    history_ready = False
    fresh_words = 0
    reuse_events = 0
    total_cycles = 0

    for update in range(visits):
        node = update % n
        field = sum(-1 if state[neighbor] else 1 for neighbor in graph.adjacency[node])
        refresh = True
        if mode == "epix":
            expected_state = 1 if field >= 0 else 0
            age = (sweep_tag - stored_tags[node]) & tag_mask
            refresh = (
                not history_ready
                or state[node] != expected_state
                or abs(field - stored_fields[node]) > delta_field
                or age > max_reuse
            )

        old_state = state[node]
        new_state = old_state
        total_cycles += FIELD_CYCLES

        if refresh:
            total_cycles += 1
            fresh_words += 1
            sample_word = pbit_rngs[node]
            if mode == "epix":
                if history_ready:
                    sample_word = lfsr_step(sample_word)
                pbit_rngs[node] = sample_word
                stored_fields[node] = field
                stored_tags[node] = sweep_tag
            else:
                pbit_rngs[node] = lfsr_step(sample_word)
            threshold = max(0, min(65_535, 32_768 + field * prob_gain))
            new_state = int((sample_word & 0xFFFF) < threshold)
        else:
            reuse_events += 1

        if new_state != old_state:
            for neighbor in graph.adjacency[node]:
                current_cut += 1 if old_state == state[neighbor] else -1
            state[node] = new_state
        best_cut = max(best_cut, current_cut)
        if graph.optimum >= 0 and hit_update < 0 and current_cut == graph.optimum:
            hit_update = update + 1
            hit_cycles = total_cycles
            hit_fresh = fresh_words
        if node == n - 1:
            sweep_tag = (sweep_tag + 1) & tag_mask
            history_ready = True

    return Trial(
        engine="python_reference",
        mode=mode,
        rows=graph.rows,
        cols=graph.cols,
        n=n,
        edges=len(graph.edges),
        optimum=graph.optimum,
        trial=trial_index,
        seed_hex=f"0x{seed:08x}",
        initial_hex=f"0x{initial:0{(n + 3) // 4}x}",
        visit_budget=visits,
        best_cut=best_cut,
        success=int(hit_update >= 0),
        first_hit_updates=hit_update,
        first_hit_cycles=hit_cycles,
        first_hit_fresh_words=hit_fresh,
        final_fresh_words=fresh_words,
        final_reuse_events=reuse_events,
        total_cycles=total_cycles,
    )


def main() -> None:
    args = parse_args()
    if args.rows < 2 or args.cols < 2 or args.trials <= 0 or args.visits <= 0:
        raise SystemExit("dimensions, trials, and visits must be positive (dimensions >= 2)")
    graph = read_graph(args.graph, args.rows, args.cols)
    campaign = make_campaign(graph, args.trials, args.campaign_seed)
    modes = ("baseline", "epix") if args.mode == "both" else (args.mode,)
    results = [
        run_trial(
            graph, mode, trial_index, seed, initial, args.visits,
            args.prob_gain, args.delta_field, args.max_reuse,
        )
        for mode in modes
        for trial_index, (seed, initial) in enumerate(campaign)
    ]

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(asdict(results[0])))
        writer.writeheader()
        writer.writerows(asdict(result) for result in results)

    summary: dict[str, object] = {
        "graph": f"kings_{args.rows}x{args.cols}",
        "rows": args.rows,
        "cols": args.cols,
        "vertices": graph.vertices,
        "edges": len(graph.edges),
        "known_exact_maxcut": graph.optimum if graph.optimum >= 0 else None,
        "trials_per_mode": args.trials,
        "visit_budget": args.visits,
        "baseline_cycles_per_update": BASELINE_CYCLES_PER_UPDATE,
        "epix_cycle_formula": "visits + fresh_words",
        "modes": {},
    }
    for mode in modes:
        selected = [result for result in results if result.mode == mode]
        hits = [result for result in selected if result.success]
        summary["modes"][mode] = {
            "successes": len(hits),
            "trials": len(selected),
            "mean_first_hit_updates_successes": (
                mean(result.first_hit_updates for result in hits) if hits else None
            ),
            "mean_final_fresh_words": mean(
                result.final_fresh_words for result in selected
            ),
        }
    args.summary.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    for result in results:
        print(
            f"{result.mode:8s} trial={result.trial:02d} best={result.best_cut} "
            f"hit={result.first_hit_updates} fresh={result.final_fresh_words}"
        )


if __name__ == "__main__":
    main()
