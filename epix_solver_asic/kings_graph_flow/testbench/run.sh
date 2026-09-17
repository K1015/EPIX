#!/usr/bin/env bash
set -euo pipefail

TESTBENCH_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${TESTBENCH_ROOT}/.." && pwd)"
ROWS="${ROWS:-10}"
COLS="${COLS:-10}"
TRIALS="${TRIALS:-4}"
VISITS="${VISITS:-20000}"
RUN_RTL="${RUN_RTL:-auto}"
RESULTS_DIR="${RESULTS_DIR:-${PROJECT_ROOT}/results}"

if (( ROWS < 2 || COLS < 2 )); then
  echo "ROWS and COLS must both be at least two" >&2
  exit 2
fi

mkdir -p "${RESULTS_DIR}"
PREFIX="kings_${ROWS}x${COLS}"
GRAPH="${RESULTS_DIR}/${PREFIX}.edgelist"
REFERENCE="${RESULTS_DIR}/${PREFIX}_reference_trials.csv"
SUMMARY="${RESULTS_DIR}/${PREFIX}_reference_summary.json"
BASELINE="${RESULTS_DIR}/${PREFIX}_rtl_baseline_trials.csv"
EPIX="${RESULTS_DIR}/${PREFIX}_rtl_epix_trials.csv"

python3 "${TESTBENCH_ROOT}/generate_kings.py" \
  --rows "${ROWS}" --cols "${COLS}" --output "${GRAPH}"
python3 "${TESTBENCH_ROOT}/pbit_reference.py" \
  --rows "${ROWS}" --cols "${COLS}" --graph "${GRAPH}" --mode both \
  --trials "${TRIALS}" --visits "${VISITS}" \
  --output "${REFERENCE}" --summary "${SUMMARY}"

have_rtl_tools=0
if command -v iverilog >/dev/null 2>&1 && command -v vvp >/dev/null 2>&1; then
  have_rtl_tools=1
fi
if [[ "${RUN_RTL}" == "1" && "${have_rtl_tools}" == "0" ]]; then
  echo "RUN_RTL=1 but iverilog/vvp are not on PATH" >&2
  exit 3
fi

if [[ "${RUN_RTL}" == "1" || ("${RUN_RTL}" == "auto" && "${have_rtl_tools}" == "1") ]]; then
  iverilog -g2012 -s tb_kings_graph \
    -Ptb_kings_graph.ROWS="${ROWS}" -Ptb_kings_graph.COLS="${COLS}" \
    -o "${RESULTS_DIR}/${PREFIX}_baseline.vvp" \
    "${PROJECT_ROOT}/rtl/baseline/kings_baseline.sv" \
    "${TESTBENCH_ROOT}/tb_kings_graph.sv"
  vvp "${RESULTS_DIR}/${PREFIX}_baseline.vvp" \
    +GRAPH="${GRAPH}" +TRIALS="${TRIALS}" +VISITS="${VISITS}" \
    +OUT="${BASELINE}" > "${RESULTS_DIR}/${PREFIX}_rtl_baseline.log"

  iverilog -g2012 -DEPIX_DUT -s tb_kings_graph \
    -Ptb_kings_graph.ROWS="${ROWS}" -Ptb_kings_graph.COLS="${COLS}" \
    -o "${RESULTS_DIR}/${PREFIX}_epix.vvp" \
    "${PROJECT_ROOT}/rtl/epix/kings_epix.sv" \
    "${TESTBENCH_ROOT}/tb_kings_graph.sv"
  vvp "${RESULTS_DIR}/${PREFIX}_epix.vvp" \
    +GRAPH="${GRAPH}" +TRIALS="${TRIALS}" +VISITS="${VISITS}" \
    +OUT="${EPIX}" > "${RESULTS_DIR}/${PREFIX}_rtl_epix.log"

  python3 "${TESTBENCH_ROOT}/compare_results.py" \
    --reference "${REFERENCE}" --baseline "${BASELINE}" --epix "${EPIX}"
else
  echo "RTL simulation skipped; Python reference completed"
fi

echo "King's ${ROWS}x${COLS} benchmark complete: ${RESULTS_DIR}"
