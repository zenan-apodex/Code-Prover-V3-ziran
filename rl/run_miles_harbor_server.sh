#!/usr/bin/env bash
set -euo pipefail

if [[ "${CONFIRM_ALIYUN_E2B_BILLING:-}" != "YES" ]]; then
  echo "Set CONFIRM_ALIYUN_E2B_BILLING=YES to start the billable runner." >&2
  exit 64
fi

required=(
  CODEPROVER_TASKS_DIR
  CODEPROVER_TRIALS_DIR
  CODEPROVER_E2B_IMAGE
  CODEPROVER_MILES_ROUTER_ALLOWED_HOSTS
)
for name in "${required[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    echo "Required environment variable is unset: ${name}" >&2
    exit 64
  fi
done

if [[ ! -d "${CODEPROVER_TASKS_DIR}" ]]; then
  echo "CODEPROVER_TASKS_DIR is not a directory: ${CODEPROVER_TASKS_DIR}" >&2
  exit 66
fi

bind_host="${CODEPROVER_HARBOR_BIND_HOST:-127.0.0.1}"
bind_port="${CODEPROVER_HARBOR_BIND_PORT:-11000}"
if [[ -z "${CODEPROVER_HARBOR_ADMIN_SECRET:-${HARBOR_ADMIN_SECRET:-}}" ]]; then
  if [[ "${CODEPROVER_ALLOW_UNAUTHENTICATED_LOOPBACK:-}" != "1" ]]; then
    echo "Set CODEPROVER_HARBOR_ADMIN_SECRET or explicitly allow loopback-only auth." >&2
    exit 64
  fi
  if [[ "${bind_host}" != "127.0.0.1" && "${bind_host}" != "localhost" && "${bind_host}" != "::1" ]]; then
    echo "Unauthenticated mode may bind only to a loopback address." >&2
    exit 64
  fi
fi

python_bin="${CODEPROVER_PYTHON:-.venv-aliyun/bin/python}"
if [[ ! -x "${python_bin}" ]]; then
  echo "Python executable is missing: ${python_bin}" >&2
  exit 66
fi

exec "${python_bin}" -m uvicorn rl.miles_harbor_server:app \
  --host "${bind_host}" \
  --port "${bind_port}" \
  --log-level "${CODEPROVER_HARBOR_LOG_LEVEL:-info}"
