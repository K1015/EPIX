"""Match current files to the source identities recorded during board runs."""

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def check_recorded_file(path, expected_digest):
    actual_digest = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual_digest == expected_digest:
        return

    # Formatting changes file bytes. Only explicitly audited runner revisions
    # may differ from the original source hash in a saved board receipt.
    records = json.loads((ROOT / 'verification/COMPLETION.json').read_text())
    relative = str(path.relative_to(ROOT))
    revision = records.get('formatted_sources', {}).get(relative)
    assert revision is not None, ('Unrecognized source change', relative)
    assert revision['ast_equivalent'] is True, relative
    assert revision['before_sha256'] == expected_digest, relative
    assert revision['after_sha256'] == actual_digest, relative
