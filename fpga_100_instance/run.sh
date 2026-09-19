#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PYTHON=${PYTHON:-python3}
command=${1:-help}
if [ "$#" -gt 0 ]; then shift; fi
case "$command" in
 list) exec "$PYTHON" -c 'import json,sys; m=json.load(open(sys.argv[1])); print("\n".join(r["id"] for r in m["instances"]))' "$ROOT/cases/manifest.json" ;;
 verify) exec "$PYTHON" "$ROOT/testbench/verify.py" "$@" ;;
 software) exec "$PYTHON" "$ROOT/testbench/software/run.py" "$@" ;;
 models) exec "$PYTHON" "$ROOT/testbench/tools/check_models.py" "$@" ;;
 prepare) exec "$PYTHON" "$ROOT/testbench/tools/prepare.py" "$@" ;;
 hex) exec "$PYTHON" "$ROOT/hex_generation/generate.py" "$@" ;;
 *) echo 'Usage: ./run.sh {list|verify|software|models|prepare|hex} [options]' ;;
esac
