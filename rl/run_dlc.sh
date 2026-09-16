#!/usr/bin/env bash
# Per-pod PAI-DLC entrypoint. It forms one external Ray cluster, runs the
# launcher on rank 0, and propagates its terminal status to all worker pods.
set -euo pipefail

: "${RUN_ID:?set RUN_ID}"
: "${CODEPROVER_ROOT:?set CODEPROVER_ROOT to the staged V3 checkout}"
: "${MILES_ROOT:?set MILES_ROOT to the staged official Miles checkout}"
: "${RUN_ROOT:?set RUN_ROOT to a shared BMCPFS run directory}"
: "${ATTEMPT_ID:?set ATTEMPT_ID to a unique value for this DLC submission}"
if [[ ! "${ATTEMPT_ID}" =~ ^[A-Za-z0-9_.-]+$ ]]; then
  echo "ATTEMPT_ID contains unsupported characters" >&2
  exit 2
fi

NODE_RANK="${MLP_WORKER_RACK_RANK_INDEX:-${RANK:-0}}"
NNODES="${MLP_WORKER_NUM:-${NNODES:-1}}"
GPUS_PER_NODE="${MLP_WORKER_GPU:-${GPUS_PER_NODE:-8}}"
HEAD_NODE_IP="${MLP_WORKER_0_PRIMARY_HOST:-${MLP_WORKER_0_HOST:-${MASTER_ADDR:-127.0.0.1}}}"
RAY_PORT="${RAY_PORT:-6379}"
RAY_DASHBOARD_PORT="${RAY_DASHBOARD_PORT:-8265}"
RUN_DIR="${RUN_ROOT}/${RUN_ID}"
DONE_FILE="${RUN_DIR}/cluster.done.${ATTEMPT_ID}"
LOG_DIR="${RUN_DIR}/attempt-logs"
MASTER_LOG="${LOG_DIR}/${ATTEMPT_ID}.master.log"
mkdir -p "${RUN_DIR}" "${LOG_DIR}"

finalize() {
  rc=$?
  trap - EXIT INT TERM
  ray stop --force >/dev/null 2>&1 || true
  if (( NODE_RANK == 0 )) && [[ "${E2B_WARM_POOL_SIZE:-0}" != "0" ]]; then
    PYTHONPATH="${CODEPROVER_ROOT}${PYTHONPATH:+:${PYTHONPATH}}" \
      timeout "${E2B_WARM_POOL_CLEANUP_TIMEOUT_SEC:-600}" python3 -m rl.warm_pool --cleanup || \
      echo "warm-pool exit cleanup incomplete; remaining instances retain provider TTL" >&2
  fi
  if (( NODE_RANK == 0 )) && [[ ! -f "${DONE_FILE}" ]]; then
    tmp_done="${DONE_FILE}.tmp.$$"
    printf '%s\n' "${rc}" >"${tmp_done}"
    mv "${tmp_done}" "${DONE_FILE}"
  fi
  exit "${rc}"
}
trap finalize EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

python3 - <<'PY'
import importlib.metadata
import json

expected = {"e2b": "2.34.0", "openai": "2.6.1"}
actual = {}
for distribution, version in expected.items():
    try:
        actual[distribution] = importlib.metadata.version(distribution)
    except importlib.metadata.PackageNotFoundError as exc:
        raise SystemExit(f"missing required main-environment package: {distribution}=={version}") from exc
    if actual[distribution] != version:
        raise SystemExit(
            f"main-environment version mismatch: {distribution}=={actual[distribution]} "
            f"(required {version})"
        )
try:
    harbor_version = importlib.metadata.version("harbor")
except importlib.metadata.PackageNotFoundError:
    harbor_version = None
if harbor_version is not None:
    raise SystemExit(
        f"harbor=={harbor_version} is installed in the main environment; "
        "use /opt/harbor-0.20.0/bin/python instead"
    )
print(json.dumps({"main_environment": actual, "harbor_isolated": True}, sort_keys=True))
PY

if (( NODE_RANK == 0 )); then
  ray start --head --node-ip-address "${HEAD_NODE_IP}" --port "${RAY_PORT}" \
    --num-cpus "${RAY_NUM_CPUS_PER_NODE:-176}" --num-gpus "${GPUS_PER_NODE}" \
    --disable-usage-stats --dashboard-host=0.0.0.0 --dashboard-port "${RAY_DASHBOARD_PORT}"
else
  deadline=$((SECONDS + ${CLUSTER_WAIT_SECONDS:-900}))
  until ray start --address="${HEAD_NODE_IP}:${RAY_PORT}" \
      --num-cpus "${RAY_NUM_CPUS_PER_NODE:-176}" --num-gpus "${GPUS_PER_NODE}" \
      --disable-usage-stats; do
    if (( SECONDS >= deadline )); then
      echo "timed out joining Ray head ${HEAD_NODE_IP}:${RAY_PORT}" >&2
      exit 2
    fi
    sleep 10
  done
fi

if (( NODE_RANK == 0 )); then
  deadline=$((SECONDS + ${CLUSTER_WAIT_SECONDS:-900}))
  while true; do
    available="$(python3 -c 'import ray; ray.init(address="auto"); print(int(ray.cluster_resources().get("GPU", 0))); ray.shutdown()' 2>/dev/null || echo 0)"
    if (( available >= NNODES * GPUS_PER_NODE )); then
      break
    fi
    if (( SECONDS >= deadline )); then
      echo "timed out waiting for Ray GPUs: ${available}/$((NNODES * GPUS_PER_NODE))" >&2
      exit 2
    fi
    sleep 10
  done
  export NNODES GPUS_PER_NODE RUN_DIR
  export RAY_DASHBOARD_ADDRESS="http://127.0.0.1:${RAY_DASHBOARD_PORT}"
  set +e
  bash "${CODEPROVER_ROOT}/rl/run_prover_rl.sh" 2>&1 | tee -a "${MASTER_LOG}"
  rc=${PIPESTATUS[0]}
  set -e
  exit "${rc}"
fi

deadline=$((SECONDS + ${WORKER_WAIT_SECONDS:-43200}))
until [[ -f "${DONE_FILE}" ]]; do
  if (( SECONDS >= deadline )); then
    echo "timed out waiting for head completion" >&2
    exit 2
  fi
  sleep 20
done
rc="$(tr -d '[:space:]' <"${DONE_FILE}")"
if [[ ! "${rc}" =~ ^[0-9]+$ ]]; then
  echo "invalid head completion status" >&2
  exit 2
fi
exit "${rc}"
