#!/usr/bin/env python3
"""Verify input hashes, target witnesses, and independently regenerated graphs."""
import hashlib
import json
import sys

from case_catalog import ROOT, CASE_IDS, inside, read, verify_catalog


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition, message):
    if not condition:
        raise ValueError(message)


def cnf(path):
    variables = None
    clauses = []
    pending = []
    declared = None
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("c"):
            continue
        if line.startswith("p "):
            _, kind, n, m = line.split()
            require(kind == "cnf", "CNF header required")
            variables, declared = int(n), int(m)
            continue
        for item in map(int, line.split()):
            if item:
                pending.append(item)
            else:
                clauses.append(pending)
                pending = []
    require(not pending and len(clauses) == declared, "CNF clause count mismatch")
    require(all(len(c) == 3 for c in clauses), "Native solver expects 3-SAT")
    require(all(1 <= abs(v) <= variables for c in clauses for v in c), "Invalid literal")
    return variables, clauses


def verifies_cnf(bits, clauses):
    return all(any(bool(bits[abs(v)-1]) == (v > 0) for v in c) for c in clauses)


def verifies_xor(bits, formula):
    return all(sum(bits[v] for v in c) % 2 == z
               for c, z in zip(formula["clauses"], formula["parity"]))


def native_chimera(case):
    sys.path.insert(0, str(ROOT / "software/chimera_native"))
    from frustrated_loop_instances import make_frustrated_loop_instance
    from apt_icm import instance_digest
    spec = read(case / "software_spec.json")
    generated = make_frustrated_loop_instance(
        name=spec["instance"], side=spec["side"], alpha=spec["alpha"],
        min_loop_length=spec["min_loop_length"], max_loop_length=spec["max_loop_length"],
        seed=spec["generator_seed"])
    require(instance_digest(generated.instance) == spec["instance_digest"],
            "Regenerated Chimera graph digest mismatch")
    require(generated.target == spec["target"], "Regenerated target mismatch")
    return generated


def verify_case(case_id):
    if case_id.startswith("maxcut"):
        return verify_maxcut(case_id)
    case = ROOT / "cases" / case_id
    meta = read(case / "metadata.json")
    for filename, expected in meta["input_files"].items():
        require(sha(inside(case / filename)) == expected, f"Input hash mismatch: {case_id}/{filename}")
    cert = read(case / "certificate.json")
    witness = cert["witness"]
    require(len(witness) == meta["logical_variables"] and all(x in (0, 1) for x in witness),
            "Invalid witness bits")
    if meta["family"].lower() == "chimera":
        graph = read(case / "graph.json")
        # Direct Python sum is separate from both native scoring functions.
        score = sum(w * (witness[u] != witness[v]) for u, v, w in graph["edges"])
        bound = cert.get("target", cert["certificate"]["sum_clause_maximum_signed_cut"])
        require(score == meta["target"] == bound, "Chimera witness score mismatch")
        require(all(graph["colors"][u] != graph["colors"][v] for u, v, _ in graph["edges"]),
                "Invalid parallel color schedule")
        generated = native_chimera(case)
        materialized = [[int(u), int(v), int(w)] for u, v, w in zip(
            generated.instance.edge_u, generated.instance.edge_v, generated.instance.edge_w)]
        require(materialized == graph["edges"], "Materialized graph differs from original generator")
        require(generated.certificate == cert["certificate"], "Planted bound certificate mismatch")
        require(generated.planted_bits.tolist() == witness, "Planted witness mismatch")
    else:
        n, clauses = cnf(case / "input.cnf")
        require(n == meta["logical_variables"], "CNF dimension mismatch")
        require(sha(case / "input.cnf") == cert.get("input_sha256", cert.get("cnf_sha256")),
                "Original certificate hash mismatch")
        require(verifies_cnf(witness, clauses), "Witness fails original CNF")
        if meta["family"].lower() == "xorsat":
            formula = read(case / "input_xor.json")
            require(sha(case / "input_xor.json") == cert["xor_sha256"], "Original XOR hash mismatch")
            require(verifies_xor(witness, formula), "Witness fails original XOR constraints")
            # Independently check the four CNF clauses for every parity constraint.
            from itertools import product
            expected = []
            for variables, parity in zip(formula["clauses"], formula["parity"]):
                for bits in product((0, 1), repeat=3):
                    if sum(bits) % 2 != parity:
                        expected.append(tuple(sorted((v+1) if bit == 0 else -(v+1)
                                                     for v, bit in zip(variables, bits))))
            require(sorted(expected) == sorted(tuple(sorted(c)) for c in clauses),
                    "XOR-to-CNF encoding mismatch")
    return {"case": case_id, "input_hashes": "pass", "witness": "pass", "target": meta["target"]}


def verify_maxcut(case_id):
    case = ROOT / "cases" / case_id
    meta = read(case / "metadata.json")
    for filename, expected in meta["input_files"].items():
        actual = hashlib.sha256(inside(case / filename).read_bytes()).hexdigest()
        require(actual == expected, f"Input hash mismatch: {case_id}/{filename}")
    cert = read(inside(case / meta["certificate_file"]))
    witness = cert.get("witness_bits", cert.get("witness"))
    bits = [int(bit) for bit in witness]
    n = meta["logical_variables"]
    require(len(bits) == n and all(bit in (0, 1) for bit in bits), "Invalid cut witness")
    graph = read(case / "inputs/graph.json")
    edges = graph["edges"]
    require(all(0 <= u < n and 0 <= v < n and u != v for u, v, _ in edges),
                   "Invalid graph endpoint")
    require(len({tuple(sorted((u, v))) for u, v, _ in edges}) == len(edges),
                   "Duplicate undirected graph edge")
    score = sum(w for u, v, w in edges if bits[u] != bits[v])
    require(score == cert["target"] == meta["target"], "Cut target mismatch")
    if "target" in graph:
        require(score == graph["target"], "Graph target mismatch")
    require(graph.get("name", graph.get("instance")) == meta["instance"] == cert["instance"],
                   "Instance identity mismatch")
    if "instance_digest" in graph:
        require(graph["instance_digest"] == cert["instance_digest"], "Graph digest identity mismatch")
    return dict(case=case_id, input_hashes="pass", witness="pass", target=score,
                optimal_bound="retained certificate; not recomputed by this input check")


def main():
    result = verify_catalog()
    result["inputs"] = [verify_case(case_id) for case_id in CASE_IDS]
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
