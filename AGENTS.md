# Code-Prover-V3 Agent Notes

This repository is the canonical target for the staged retirement of
`Code-Prover-V2`.

## Migration Rules

- Put new CodeProver product work in V3 unless a task explicitly targets V2
  preservation or inventory.
- Treat `/mnt/VerifiableAILab/ziran.yang/formal-code/Code-Prover-V2` as a
  read-only migration source. Do not switch, stash, reset, or clean its active
  checkout or worktrees while doing V3 work.
- Port user-visible behavior and contracts into the V3 architecture. Do not
  merge the unrelated Git histories or copy the V2 runner, vendored harness,
  pipeline, or generated workspaces wholesale.
- Use `ziran/v2-migration` as the staged integration branch requested by the
  repository owner. Keep each migrated feature in an atomic commit and record
  the V2 source commit/path, V3 replacement, verification, and status in
  `MIGRATION.md`.
- Never cherry-pick V2 commit `8c208c1` as a unit. Its subject hides a mixed
  100-file change containing unrelated runtime, agent, E2B, evaluation, and
  generated-workspace changes.

## Verification

- Add focused tests or deterministic fixtures for each migrated behavior.
- Run `python3 tools/dataset.py validate` for every affected dataset.
- For verifier or task-contract changes, run both the oracle-positive and
  no-op-negative Harbor smoke configurations when Docker/Harbor are available.
- Preserve the declared Lean/Mathlib profile. Do not silently mix V2 pipeline
  4.29 artifacts with V3's 4.28 task profile.

## Artifacts

Do not commit `jobs/`, `.venv/`, generated task workspaces, model weights,
credentials, local image contents, or per-machine settings. Dataset migrations
must include their manifest and validation evidence.
