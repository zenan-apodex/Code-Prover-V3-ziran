# Official Miles + V3 Harbor adapter

This adapter keeps ownership boundaries explicit:

- official Miles owns session-scoped TITO token IDs, masks and rollout log
  probabilities;
- `rl.miles_harbor_agent` forwards only an allowlisted task identity, sampling
  parameters and the Miles session URL;
- `rl.miles_harbor_server` resolves the canonical task locally and lets a normal
  Harbor `SingleStepTrial` own the Aliyun E2B sandbox, agent and verifier
  lifecycle;
- datasets, checkpoints, credentials, run logs and generated trials remain in
  local ignored paths. They are not committed to Git.

## Install

Use Python 3.12 for the internal Aliyun endpoint:

```bash
uv venv --python 3.12 .venv-aliyun
uv pip install --python .venv-aliyun/bin/python -r requirements-miles-harbor.txt
```

The Aliyun deployment currently pins `e2b==2.23.0`. Apply the Harbor
`SandboxNetworkUpdate` compatibility step documented in the repository's
"internal Aliyun sandbox" README section when creating a fresh environment.

## Start the Harbor service

Load credentials from a gitignored file or secret manager, then set deployment
values in the shell. The router allowlist contains hostnames or IP addresses,
without ports, that may appear in Miles' session `base_url`:

```bash
export CODEPROVER_TASKS_DIR=/absolute/local/path/to/materialized/tasks
export CODEPROVER_TRIALS_DIR=/absolute/local/path/to/ignored/trials
export CODEPROVER_E2B_IMAGE=registry.example/code-prover-lean:immutable-tag
export CODEPROVER_MILES_ROUTER_ALLOWED_HOSTS=10.0.0.2,router.internal
export CODEPROVER_HARBOR_ADMIN_SECRET="$(openssl rand -hex 32)"
export CONFIRM_ALIYUN_E2B_BILLING=YES

bash rl/run_miles_harbor_server.sh
curl --fail http://127.0.0.1:11000/ready
```

Pass the same `CODEPROVER_HARBOR_ADMIN_SECRET` to Miles workers. For a service
and workers confined to the same host, an explicit
`CODEPROVER_ALLOW_UNAUTHENTICATED_LOOPBACK=1` is supported; the launcher refuses
to combine that mode with a non-loopback bind address.

The default lease is 7,800 seconds: 5,400 seconds for the agent, 1,800 for the
verifier and a 300-second teardown margin. Override the corresponding
`CODEPROVER_*_TIMEOUT_SEC` variables together; readiness fails if the sandbox
lease cannot cover the configured agent, verifier and cleanup budgets.

## Miles plugin contract

The official Miles launch must use these hooks together:

```text
--custom-generate-function-path miles.rollout.generate_hub.agentic_tool_call.generate
--custom-agent-function-path rl.miles_harbor_agent.run
--custom-rm-path rl.miles_harbor_agent.reward_func
--group-rm
--dynamic-sampling-filter-path rl.miles_harbor_agent.fail_on_infrastructure
--use-session-server
--use-miles-router
--tito-model qwen35
--tito-allowed-append-roles user tool
```

Keep `--over-sampling-batch-size` equal to `--rollout-batch-size`. The dynamic
filter treats infrastructure failures and strict TITO mismatches as fatal so
Miles cannot turn a persistent, billable outage into an unlimited replacement
loop. Official Miles discovers the sibling `rl.miles_harbor_agent.abort` hook
and calls it during rollout teardown.

## Verification

The adapter unit suite does not create a sandbox:

```bash
.venv-aliyun/bin/python -m unittest discover \
  -s tests -p 'test_miles_harbor_adapter.py' -v
ruff check rl/miles_harbor_agent.py rl/miles_harbor_server.py \
  tests/test_miles_harbor_adapter.py
```

Run artifacts belong under the configured ignored trials/run directory. Record
model/checkpoint identifiers, both repository SHAs and the immutable image tag
in the local run manifest before a billable smoke or training run.
