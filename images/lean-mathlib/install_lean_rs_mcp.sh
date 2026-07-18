#!/usr/bin/env bash
#
# Install the lean-rs-mcp server — the Rust port of lean-lsp-mcp
# (https://github.com/Lizn-zn/lean-rs-mcp). The Rust port targets full
# feature parity with the Python original: same binary name
# (`lean-lsp-mcp`), same MCP tool names, same CLI flags (`--repl`,
# `--repl-timeout`, ...), and the same `LEAN_*` environment variables. So
# it is a drop-in replacement — only the *install + launch mechanism*
# changes (a compiled binary on PATH instead of `uvx lean-lsp-mcp`).
#
# This script is the single source of truth for the pinned upstream
# revision. It is invoked both on the host (developer setup) and inside the
# Docker images (docker/worker.Dockerfile, docker/lean4.Dockerfile).
#
# Usage:
#   scripts/install_lean_rs_mcp.sh            # install into ~/.cargo/bin
#   scripts/install_lean_rs_mcp.sh /usr/local # install into <root>/bin
#
# Requires a Rust toolchain (cargo) on PATH. Needs network access to fetch
# the git source + crates.
set -euo pipefail

# Pinned upstream source. Bump REV deliberately (and re-test) when adopting
# a new lean-rs-mcp release.
LEAN_RS_MCP_GIT="${LEAN_RS_MCP_GIT:-https://github.com/Lizn-zn/lean-rs-mcp}"
LEAN_RS_MCP_REV="${LEAN_RS_MCP_REV:-f46c40b950d5b9fee08099d85521fc3eede3ea4c}"

install_root="${1:-}"

if ! command -v cargo >/dev/null 2>&1; then
  echo "Error: 'cargo' (Rust toolchain) not found on PATH." >&2
  echo "Install Rust 1.75+ first: https://rustup.rs" >&2
  exit 1
fi

# `cargo install` builds the [[bin]] named `lean-lsp-mcp` from the pinned
# revision and drops it at <root>/bin/lean-lsp-mcp. --locked uses the repo's
# committed Cargo.lock for reproducible dependency versions.
cargo_args=(
  install
  --git "$LEAN_RS_MCP_GIT"
  --rev "$LEAN_RS_MCP_REV"
  --locked
  --force
  lean-lsp-mcp
)
if [[ -n "$install_root" ]]; then
  cargo_args+=( --root "$install_root" )
fi

echo "Installing lean-lsp-mcp (Rust port) @ ${LEAN_RS_MCP_REV}..."
cargo "${cargo_args[@]}"

# Confirm the binary is runnable. `cargo install` drops it at <root>/bin
# when --root is given, otherwise at $CARGO_INSTALL_ROOT/bin, else
# $CARGO_HOME/bin, else ~/.cargo/bin — none of which are guaranteed to be on
# PATH yet, so check the concrete path rather than relying on `command -v`.
if [[ -n "$install_root" ]]; then
  bin_dir="$install_root/bin"
else
  bin_dir="${CARGO_INSTALL_ROOT:-${CARGO_HOME:-$HOME/.cargo}}/bin"
fi
bin="$bin_dir/lean-lsp-mcp"
if [[ ! -x "$bin" ]]; then
  # Fall back to PATH in case of a non-standard cargo layout.
  bin="$(command -v lean-lsp-mcp || true)"
fi
if [[ -z "$bin" || ! -x "$bin" ]]; then
  echo "Error: lean-lsp-mcp was not installed where expected." >&2
  exit 1
fi
"$bin" --help >/dev/null 2>&1 || true
echo "lean-lsp-mcp installed: $bin"

# The prover launches the MCP server by the bare name `lean-lsp-mcp`, so the
# install dir must be on PATH. Warn loudly if it is not — install succeeded
# but the prover's preflight (scripts/ensure_lean_lsp_mcp.sh) would still fail.
if ! command -v lean-lsp-mcp >/dev/null 2>&1; then
  echo "Note: $(dirname "$bin") is not on PATH. Add it, e.g.:" >&2
  echo "  export PATH=\"$(dirname "$bin"):\$PATH\"" >&2
fi
