"""Verified input and sizing adapter for the selected MaxCUT hardware instances.

Importing this module performs no writes. The explicit ``prepare_all`` entry
point writes preparation artifacts only; it launches no solver or ASIC tools.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
from datetime import datetime, timezone
import hashlib
import json
import pathlib
import platform

import numpy as np

SHARED_ROOT = pathlib.Path(__file__).resolve().parent
CAMPAIGN_ROOT = SHARED_ROOT.parents[1]
SIZES = (32, 288, 512, 800)
MANIFEST_SHA256 = "7d0ce929d91e9282e05b90d49b7f1cb39da68021434eb2cedde6bf299419c52d"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def file_sha256(path):
    return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()


def object_sha256(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def unsigned_width(maximum):
    require(isinstance(maximum, int) and maximum >= 0, "Unsigned maximum must be a nonnegative integer")
    return max(1, maximum.bit_length())


def signed_width(lower, upper):
    require(isinstance(lower, int) and isinstance(upper, int) and lower <= upper, "Invalid signed range")
    bits = 1
    while lower < -(1 << (bits - 1)) or upper > (1 << (bits - 1)) - 1:
        bits += 1
    return bits


def physical_seed_namespace(size):
    require(size in (128, *SIZES), "Unsupported physical RNG size")
    return f"corrected{size}"


def seed_words(size, seed, stream, count=None):
    """Match the retained 128-node seed stream; separate larger-size streams."""
    require(stream in (2, 3, 4), "Only local, exchange, and cluster LFSR streams are supported")
    if count is None:
        count = size if stream == 2 else 1
    require(isinstance(count, int) and count >= 0, "Invalid seed-word count")
    namespace = physical_seed_namespace(size)
    words = []
    for index in range(count):
        message = f"{namespace}/{seed}/{stream}/{index}".encode()
        value = int.from_bytes(hashlib.sha256(message).digest()[:4], "little")
        words.append(value if value != 0xffffffff else 1)
    return np.asarray(words, dtype=np.uint64)


@dataclass(frozen=True)
class Graph:
    name: str
    height: int
    width: int
    n: int
    edge_u: np.ndarray
    edge_v: np.ndarray
    edge_w: np.ndarray
    neigh_idx: np.ndarray
    neigh_w: np.ndarray
    colors: np.ndarray
    adjacency: tuple
    degrees: np.ndarray
    digest: str

    @property
    def side(self):
        return self.width

    def kernel_instance(self, kernel):
        return kernel.KingsInstance(self.name, self.width, self.n, self.edge_u, self.edge_v,
            self.edge_w, self.neigh_idx, self.neigh_w, self.colors, self.adjacency)

    def record(self):
        return dict(instance=self.name, n=self.n, height=self.height, width=self.width,
            instance_digest=self.digest,
            edges=np.column_stack((self.edge_u, self.edge_v, self.edge_w)).tolist(),
            colors=self.colors.tolist(), degrees=self.degrees.tolist(),
            adjacency=[list(row) for row in self.adjacency])


def regenerate_graph(spec):
    height, width, n = int(spec["height"]), int(spec["width"]), int(spec["n"])
    require(height > 1 and width > 1 and n == height * width, "Invalid rectangular dimensions")
    edges = [(row * width + col, (row + dr) * width + col + dc)
             for row in range(height) for col in range(width)
             for dr, dc in ((0, 1), (1, -1), (1, 0), (1, 1))
             if row + dr < height and 0 <= col + dc < width]
    # Canonical array byte order is little-endian on the source Mac and compute_host.
    u = np.asarray([a for a, _ in edges], dtype="<i4")
    v = np.asarray([b for _, b in edges], dtype="<i4")
    weights = np.random.default_rng(spec["generator_seed"]).choice(
        np.asarray([-1, 1], dtype=np.int8), len(edges))
    neighbors = np.full((n, 8), n, dtype=np.int32)
    neighbor_weights = np.zeros((n, 8), dtype=np.int8)
    degrees = np.zeros(n, dtype=np.int32)
    adjacency = [[] for _ in range(n)]
    for a, b, weight in zip(u, v, weights):
        for i, j in ((int(a), int(b)), (int(b), int(a))):
            neighbors[i, degrees[i]] = j
            neighbor_weights[i, degrees[i]] = weight
            degrees[i] += 1
            adjacency[i].append(j)
    colors = ((np.arange(n) // width) % 2 * 2 + (np.arange(n) % width) % 2).astype(np.int8)
    expected_edges = height * (width - 1) + (height - 1) * width + 2 * (height - 1) * (width - 1)
    require(len(edges) == expected_edges, "Topology edge-count mismatch")
    require(len(set(edges)) == len(edges), "Duplicate edges")
    require(bool(np.all(colors[u] != colors[v])), "Color classes contain adjacent nodes")
    require(bool(np.all((degrees >= 1) & (degrees <= 8))), "Invalid graph degree")
    digest = hashlib.sha256(u.tobytes() + v.tobytes() + weights.tobytes()).hexdigest()
    for array in (u, v, weights, neighbors, neighbor_weights, colors, degrees):
        array.flags.writeable = False
    return Graph(spec["instance"], height, width, n, u, v, weights, neighbors,
        neighbor_weights, colors, tuple(tuple(sorted(row)) for row in adjacency), degrees, digest)


def verify_target(spec, certificate, graph):
    require(spec["family"] == "kings" and spec["n"] == graph.n, "Incorrect workload specification")
    require(spec["instance"] == certificate["instance"] == graph.name, "Instance-name mismatch")
    require(spec["target_kind"] == "exact_dp", "Target is not the retained exact DP target")
    require(certificate["kind"] == "exact_integer_dp" and certificate["eligible"], "Invalid exact certificate")
    require(certificate["witness_independently_rescored"] is True, "Certificate lacks witness verification")
    require(spec["certificate_kind"] == "exact_integer_dp_with_witness", "Unexpected proof kind")
    require(certificate["n"] == graph.n and certificate["short_side"] == graph.width, "Certificate geometry mismatch")
    calibration = spec["calibration"]
    require(spec["instance_digest"] == certificate["instance_digest"] == calibration["instance_digest"] == graph.digest,
            "Regenerated graph digest disagrees with retained evidence")
    witness_text = certificate["witness_bits"]
    require(len(witness_text) == graph.n and set(witness_text) <= {"0", "1"}, "Malformed witness")
    witness = np.asarray([int(value) for value in witness_text], dtype=np.int8)
    edge_score = int(np.sum(graph.edge_w.astype(np.int64) * (witness[graph.edge_u] != witness[graph.edge_v])))
    adjacency_sum = sum(int(graph.neigh_w[node, slot])
        for node in range(graph.n) for slot in range(int(graph.degrees[node]))
        if witness[node] != witness[int(graph.neigh_idx[node, slot])])
    require(adjacency_sum % 2 == 0, "Adjacency objective is not symmetric")
    adjacency_score = adjacency_sum // 2
    require(edge_score == adjacency_score == spec["target"] == certificate["target"], "Exact witness score mismatch")
    unsigned_spec = dict(spec)
    expected_spec_hash = unsigned_spec.pop("prepared_spec_hash")
    require(object_sha256(unsigned_spec) == expected_spec_hash, "Prepared-specification content hash mismatch")
    require(calibration["schema"] == "iid_thermodynamic_length_ladder_v1", "Unexpected ladder calibration")
    require(calibration["instance"] == graph.name, "Calibration instance mismatch")
    require(spec["betas"] == calibration["betas"], "Prepared and calibration ladders differ")
    require(len(spec["betas"]) == spec["temperatures"], "Temperature count differs from ladder length")
    require(all(np.isfinite(beta) for beta in spec["betas"]), "Non-finite beta")
    require(all(a < b for a, b in zip(spec["betas"], spec["betas"][1:])), "Unordered beta ladder")
    require(spec["betas"][0] == 0.15 and spec["betas"][-1] == 3.0, "Unexpected beta endpoints")
    require(calibration["seed"] == spec["generator_seed"] + 9_000_000_000, "Calibration seed mismatch")
    require(calibration["burn_sweeps"] == 128 and calibration["sample_sweeps"] == 256,
            "Unexpected calibration effort")
    return dict(passed=True, graph_digest=graph.digest, prepared_spec_hash=expected_spec_hash,
        witness_edge_score=edge_score, witness_adjacency_score=adjacency_score,
        retained_exact_proof="Exhaustive integer DP with optimal witness; DP not rerun here",
        certificate_runtime_seconds=certificate["elapsed_seconds"],
        ladder_id=calibration["beta_ladder_id"])


def derive_configuration(spec, graph):
    n, temperatures, copies = graph.n, int(spec["temperatures"]), int(spec["copies_per_temperature"])
    require(n in (128, *SIZES) and copies == 2, "Unsupported selected solver configuration")
    replicas, colors, bits_per_word = temperatures * copies, 4, 32
    color_sizes = np.bincount(graph.colors, minlength=colors).tolist()
    require(n % bits_per_word == 0 and color_sizes == [n // colors] * colors,
            "Selected hardware requires balanced colors and integral initialization words")
    budget, edges = int(spec["maximum_sweeps"]), len(graph.edge_u)
    delta, age_max = (0.05, 2) if n <= 256 else (0.10, 4)
    age_width = unsigned_width(age_max)
    raw_field_bound = int(np.max(graph.degrees))
    raw_width = signed_width(-raw_field_bound, raw_field_bound)
    eligible = [index for index, beta in enumerate(spec["betas"]) if beta >= spec["icm_beta_min"]]
    require(eligible, "No ICM-eligible temperatures")
    require(spec["icm_interval"] == 4 and spec["icm_beta_min"] == 1.2,
            "Unexpected canonical cluster schedule")
    require(spec["max_disagreement_fraction"] == spec["max_cluster_fraction"] == 0.5,
            "Unexpected canonical cluster limits")
    require(min(spec["betas"]) >= delta, "Field-equality reuse simplification is not justified")
    init_words_per_replica = n // bits_per_word
    local_visits_max = replicas * n * budget
    swaps_max = copies * (temperatures // 2) * budget
    icm_words_max = (budget // spec["icm_interval"]) * len(eligible)
    seed_count, init_count = n + 2, replicas * init_words_per_replica
    widths = dict(node_index=unsigned_width(n - 1), node_or_sentinel=unsigned_width(n),
        replica_index=unsigned_width(replicas - 1), temperature_index=unsigned_width(temperatures - 1),
        color_index=unsigned_width(colors - 1), seed_address=unsigned_width(seed_count - 1),
        init_bank=unsigned_width(replicas - 1), init_word=unsigned_width(init_words_per_replica - 1),
        score=signed_width(-edges, edges), score_difference=signed_width(-2 * edges, 2 * edges),
        unsigned_score_gap=unsigned_width(2 * edges), local_raw_field=raw_width,
        age=age_width, population_count=unsigned_width(n),
        fresh_words_per_color=unsigned_width(n // colors), sweeps=unsigned_width(budget),
        local_words=unsigned_width(local_visits_max), node_visits=unsigned_width(local_visits_max),
        swap_words=unsigned_width(swaps_max), icm_words=unsigned_width(icm_words_max))
    return dict(schema="selected_maxcut_hardware_input_v1", instance=graph.name,
        n=n, height=graph.height, width=graph.width, edge_count=edges, exact_target=int(spec["target"]),
        instance_digest=graph.digest, maximum_sweeps=budget, betas=list(spec["betas"]),
        beta_ladder_id=spec["calibration"]["beta_ladder_id"],
        policies=dict(baseline="iid_apt_icm", epix="epic_apt_icm", field_refresh_delta=delta,
                      max_hold_age=age_max, stop_on_exact=True, field_equality_reuse_eligible=True,
                      reuse_equivalence_validation_still_required=True),
        replicas=dict(copies_per_temperature=copies, temperatures=temperatures, total=replicas),
        colors=dict(count=colors, node_counts=color_sizes, node_color_rule="2*(row mod 2)+(column mod 2)",
                    local_and_score_cycles_per_full_sweep=2 * colors * replicas),
        icm=dict(interval_sweeps=spec["icm_interval"], beta_min=spec["icm_beta_min"],
                 eligible_temperature_indices=eligible, max_disagreement_nodes=n // 2, max_cluster_nodes=n // 2),
        rng=dict(local_generators=n, auxiliary_generators=2, word_bits=bits_per_word, steps_per_fresh_word=32,
                 local_state_bits=n * bits_per_word, auxiliary_state_bits=64,
                 seed_namespace=physical_seed_namespace(n), stream_ids=dict(local=2, exchange=3, cluster=4),
                 seed_encoding="SHA256(namespace/seed/stream/index), first four bytes little-endian; all-ones maps to one"),
        trial_seeds=dict(namespace=int(spec["seed_namespace"]), instance_code=int(spec["instance_code"]),
                         stride=int(spec["trial_stride"]),
                         first_trial_seed=int(spec["seed_namespace"] + spec["instance_code"] * spec["trial_stride"])),
        loading=dict(seed_words=seed_count, initialization_words_per_replica=init_words_per_replica,
                     initialization_words_total=init_count, reset_cycles=2, start_cycles=1,
                     setup_cycles=2 + seed_count + init_count + 1,
                     native_initialization_rng_words=init_count),
        clock_gating=dict(storage_color_groups_per_replica=colors,
                          storage_integrated_gates=replicas * colors, local_rng_integrated_gates=n,
                          total_integrated_gates=n + replicas * colors,
                          topology="four independent color storage clocks per replica; one RNG clock per node",
                          nonlocal_events_enable_all_storage_colors=True),
        uncompressed_logical_storage=dict(spin_bits=n * replicas,
            valid_bits=n * replicas, age_bits=n * replicas * age_width,
            saved_field_bits=n * replicas * raw_width,
            epix_metadata_bits=n * replicas * (1 + age_width + raw_width),
            baseline_spin_register_sinks_per_storage_gate=n // colors,
            epix_register_sinks_per_storage_gate=(n // colors) * (2 + age_width + raw_width)),
        bounds=dict(score_lower=-edges, score_upper=edges, signed_difference_lower=-2 * edges,
                    signed_difference_upper=2 * edges, unsigned_gap_max=2 * edges,
                    tighter_objective_lower=-int(np.sum(graph.edge_w < 0)),
                    tighter_objective_upper=int(np.sum(graph.edge_w > 0)),
                    local_raw_field_lower=-raw_field_bound, local_raw_field_upper=raw_field_bound,
                    maximum_local_words=local_visits_max, maximum_node_visits=local_visits_max,
                    maximum_swap_words=swaps_max, maximum_icm_words=icm_words_max),
        widths=widths)


@dataclass(frozen=True)
class PreparedInstance:
    specification: dict
    certificate: dict
    graph: Graph
    configuration: dict
    verification: dict


def load_selected(size, campaign_root=CAMPAIGN_ROOT):
    require(size in SIZES, "Unsupported packaged size")
    directory = pathlib.Path(campaign_root) / "cases" / ("maxcut"+str(size)) / "inputs"
    binding=json.loads((directory/"binding.json").read_text())
    for name,digest in binding["input_sha256"].items():
        require(file_sha256(directory/name)==digest,"Input binding mismatch: "+name)
    spec=json.loads((directory/"software_spec.json").read_text())
    certificate=json.loads((directory/"certificate.json").read_text())
    require(spec["n"]==size and spec["index"]==0 and spec["instance"]==f"krect{size}.18001","Not first canonical instance")
    graph=regenerate_graph(spec)
    verification=verify_target(spec,certificate,graph)
    verification.update(specification_file_sha256=binding["input_sha256"]["software_spec.json"],certificate_file_sha256=binding["input_sha256"]["certificate.json"])
    return PreparedInstance(spec,certificate,graph,derive_configuration(spec,graph),verification)
