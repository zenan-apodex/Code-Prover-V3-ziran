#!/usr/bin/env bash
# Build the code-prover-lean base image (tag: code-prover-lean:latest).
#
# Usage:
#   images/lean-mathlib/build.sh
#
# The build context is this directory. The prebuilt Lean package tree
# (Mathlib + deps + repl oleans, ~7 GB) must exist at lean-packages/ —
# it is V3-owned and gitignored. To (re)seed it from any fully-built Lean
# project with the same toolchain/manifest:
#
#   cp -al <some-project>/.lake/packages images/lean-mathlib/lean-packages
#
# (hardlinks are cheap on the same filesystem and stay valid even if the
# source tree is later deleted). Or build from scratch — slow, ~hours:
#
#   cd images/lean-mathlib && lake build   # then move .lake/packages
#
# Env overrides:
#   IMAGE_NAME      — default: code-prover-lean:latest
#   DOCKER_BUILDKIT — default 0 (DSW/Lingjun requires the legacy builder and
#                     --network=host; set to 1 on an unrestricted host)
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
image="${IMAGE_NAME:-code-prover-lean:latest}"

if [[ ! -f "$here/lean-packages/mathlib/.lake/build/lib/lean/Mathlib.olean" ]]; then
  echo "FATAL: $here/lean-packages has no fully-built Mathlib (Mathlib.olean missing)." >&2
  echo "Seed it first — see the header of this script." >&2
  exit 1
fi

echo "==> docker build $image"
DOCKER_BUILDKIT="${DOCKER_BUILDKIT:-0}" docker build \
  --network=host \
  -t "$image" \
  -f "$here/Dockerfile" \
  "$here"

echo "==> Built $image"
