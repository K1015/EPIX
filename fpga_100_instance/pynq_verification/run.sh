#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PYTHON=${PYTHON:-python3}
command=${1:-help}
if [ "$#" -gt 0 ]; then shift; fi
case "$command" in
 verify) exec "$PYTHON" "$ROOT/verification/check_board_examples.py" "$@" ;;
 compare) exec "$PYTHON" "$ROOT/verification/check_board_recheck.py" "$@" ;;
 notebooks) exec "$PYTHON" "$ROOT/verification/run_board_notebooks.py" "$@" ;;
 board)
   family=${1:-all}
   if [ "$#" -gt 0 ]; then shift; fi
   case "$family" in
     all) for f in maxcut chimera sat xorsat; do "$PYTHON" "$ROOT/examples/$f/run.py" --mode paired --trials 1 "$@"; done ;;
     maxcut|chimera|sat|xorsat) exec "$PYTHON" "$ROOT/examples/$family/run.py" --mode paired --trials 1 "$@" ;;
     *) echo "Unknown family: $family" >&2; exit 2 ;;
   esac ;;
 *) echo 'Usage: ./run.sh {verify|compare|notebooks|board [all|maxcut|chimera|sat|xorsat]} [options]' ;;
esac
