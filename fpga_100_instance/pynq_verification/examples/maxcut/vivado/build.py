"""Build in a fresh directory using Vivado 2022.2 on PATH."""

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

P = Path(__file__).resolve().parent


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out', required=True)
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--stage', choices=['project', 'synth', 'bit'], default='bit')
    ap.add_argument(
        '--from-rtl',
        action='store_true',
        help='Create a new project from RTL instead of opening the bundled Vivado project',
    )
    a = ap.parse_args()

    # Build into a fresh folder to preserve the supplied image and sources.
    out = Path(a.out).resolve()
    if out.exists():
        raise ValueError('Use a fresh output directory')
    if a.jobs < 1:
        raise ValueError('jobs must be positive')

    exe = shutil.which('vivado')
    if exe is None:
        raise RuntimeError(
            'Source your Vivado 2022.2 settings64.sh so vivado is on PATH'
        )

    # Keep generated files outside the delivered project. The Tcl recipe handles
    # synthesis, implementation, timing checks and BIT/HWH export.
    env = os.environ.copy()
    env['MAXCUT_BUILD_JOBS'] = str(a.jobs)
    subprocess.check_call(
        [
            exe,
            '-mode',
            'batch',
            '-source',
            str(P / 'tcl/build.tcl'),
            '-tclargs',
            a.stage,
            str(out),
            'source' if a.from_rtl else 'bundled',
        ],
        cwd=str(P),
        env=env,
    )
    if a.stage != 'bit':
        return

    # Package the generated image with the metadata required by PYNQ.
    cfg = json.loads((P.parent / 'config.json').read_text())
    stem = cfg['overlay_stem']
    overlay = out / 'overlay'
    shutil.copy2(out / 'design_1.tcl', overlay / (stem + '.vivado.tcl'))

    sys.path.insert(0, str(P / 'scripts'))
    import metadata_adapter
    from validate_hwh_reset import validate

    # Validate PS reset/clock wiring, then derive the plain Tcl that PYNQ 2.1 reads.
    hwh = overlay / (stem + '.hwh')
    reset = validate(hwh)
    content = metadata_adapter.render(
        metadata_adapter.extract(hwh.read_bytes()),
        hashlib.sha256(hwh.read_bytes()).hexdigest(),
    )
    (overlay / (stem + '.tcl')).write_bytes(content)

    receipt = {
        'status': 'PASS',
        'scope': 'Vivado build, synchronous timing, DRC errors, one shared LFSR, HWH reset/clock checks and derived PYNQ metadata',
        'config': cfg['project'],
        'stage': a.stage,
        'reset_validation': reset,
        'files_sha256': {
            f.name: hashlib.sha256(f.read_bytes()).hexdigest()
            for f in overlay.iterdir()
            if f.is_file()
        },
    }

    # Export matching hashes so run.py accepts the newly built deployment files.
    cfg['files_sha256'] = {
        stem + ext: hashlib.sha256((overlay / (stem + ext)).read_bytes()).hexdigest()
        for ext in ['.bit', '.hwh', '.tcl']
    }
    cfg['files_sha256']['problem.json'] = hashlib.sha256(
        (P.parent / 'problem.json').read_bytes()
    ).hexdigest()
    (overlay / 'config.json').write_text(json.dumps(cfg, indent=2) + '\n')
    (out / 'BUILD_RECEIPT.json').write_text(json.dumps(receipt, indent=2))
    print(json.dumps(receipt, indent=2))


if __name__ == '__main__':
    main()
