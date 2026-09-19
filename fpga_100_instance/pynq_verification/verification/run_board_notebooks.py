#!/usr/bin/env python3
"""Execute the four paired one-trial notebooks on PYNQ-Z1, sequentially."""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BOARD_LOCK = Path(
    os.environ.get(
        'PYNQ_BOARD_LOCK',
        str(Path(tempfile.gettempdir()) / 'date2027-pynq-board.lock'),
    )
)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    root = ROOT
    out = Path(os.path.abspath(str(args.output)))
    out.mkdir(parents=True, exist_ok=False)
    import nbformat
    from nbconvert.preprocessors import ExecutePreprocessor
    import pynq
    import pkg_resources

    # Use the same advisory lock as the existing 128-variable board runner.
    with BOARD_LOCK.open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        identity = {
            'platform': platform.system(),
            'architecture': platform.machine(),
            'board_environment': os.environ.get('BOARD'),
            'python': platform.python_version(),
            'executable': '${PYNQ_PYTHON}',
            'pynq_version': pkg_resources.get_distribution('pynq').version,
            'driver_sha256': sha(Path(__file__)),
            'date_note': 'Use local host UTC receipt; board wall clock may be stale.',
        }
        save(out / 'IDENTITY.json', identity)
        results = {}
        try:
            for family in ('maxcut', 'chimera', 'sat', 'xorsat'):
                folder = root / 'examples' / family
                notebook = nbformat.read(str(folder / 'Demo.ipynb'), as_version=4)
                before = set((folder / 'runs').glob('*'))
                executor = ExecutePreprocessor(timeout=180, kernel_name='python3')
                try:
                    executor.preprocess(notebook, {'metadata': {'path': str(folder)}})
                finally:
                    nbformat.write(notebook, str(out / (family + '.ipynb')))
                new = set((folder / 'runs').glob('*')) - before
                assert len(new) == 1, (family, 'Expected one notebook run')
                run = new.pop()
                complete = json.loads((run / 'COMPLETE.json').read_text())
                provenance = json.loads((run / 'PROVENANCE.json').read_text())
                assert complete['status'] == 'PASS' and complete['trials'] == 2
                assert complete['trials_sha256'] == sha(run / 'trials.jsonl')
                assert (
                    provenance['mode'] == 'paired'
                    and provenance['trials_per_mode'] == 1
                )
                assert all(
                    sha(folder / name) == digest
                    for name, digest in provenance['files_sha256'].items()
                )
                shutil.copytree(str(run), str(out / family))
                results[family] = {
                    'summary': json.loads((run / 'SUMMARY.json').read_text()),
                    'source_notebook_sha256': sha(folder / 'Demo.ipynb'),
                    'executed_notebook_sha256': sha(out / (family + '.ipynb')),
                    'trials_sha256': sha(run / 'trials.jsonl'),
                }
                print('NOTEBOOK_PASS', family, flush=True)
            save(
                out / 'NOTEBOOK_VALIDATION.json',
                {
                    'status': 'PASS',
                    'physical_trials': 8,
                    'trials_per_mode_per_family': 1,
                    'notebooks': results,
                },
            )
        except BaseException as error:
            save(
                out / 'FAILED.json',
                {'error': repr(error), 'completed_families': sorted(results)},
            )
            raise


if __name__ == '__main__':
    main()
