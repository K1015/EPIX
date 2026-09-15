#!/usr/bin/env python3
"""Check the declared RNG supply for every case and both hardware modes."""
import json
from case_catalog import ROOT, CASE_IDS, verify_catalog


def verify():
    verify_catalog()
    rows = []
    for case_id in CASE_IDS:
        case = ROOT / 'cases' / case_id
        metadata = json.loads((case / 'metadata.json').read_text())
        adapter = json.loads((case / 'asic.json').read_text())
        supply = adapter['rng_sharing']
        n = metadata['logical_variables']
        binary = case_id.startswith(('maxcut', 'chimera'))
        expected = dict(stored_variables=n, variables_per_engine=32 if binary else n,
                        local_engines=n // 32 if binary else 1,
                        stream_states=n if binary else 1,
                        auxiliary_engines=2 if case_id.startswith('maxcut') else 0,
                        words_per_engine_per_cycle=1,
                        kind='banked' if binary else 'sequential_categorical')
        for key, value in expected.items():
            if supply.get(key) != value:
                raise ValueError(f'{case_id}: {key} differs from the selected architecture')
        if set(adapter['modes']) != {'baseline', 'epix'}:
            raise ValueError('Missing paired mode: ' + case_id)
        rows.append(dict(case_id=case_id, **supply))
    return dict(passed=True, cases=rows, configurations=2 * len(rows),
                scope='Architecture declarations and paired source presence; functional and mapped validation are separate.')


if __name__ == '__main__':
    print(json.dumps(verify(), indent=2))
