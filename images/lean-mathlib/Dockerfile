# code-prover-lean — shared base image for Code-Prover-V3 Harbor tasks.
#
# One image serves every task: the Lean 4 toolchain (elan, pinned by
# lean-toolchain), the pre-built Mathlib package tree (baked so a cold
# `import Mathlib` loads oleans from the container overlay in seconds instead
# of cold-compiling), and the lean-rs-mcp LSP/REPL server. Per-task images
# are one COPY layer on top of this.
#
# Build:  images/lean-mathlib/build.sh     # -> code-prover-lean:latest
# The build context is this directory; the ~7 GB prebuilt package tree lives
# at lean-packages/ (V3-owned, gitignored — see build.sh for how to seed it).
#
# NOTE: V3 deliberately ships NO agent skill (V2's lean4-codeprover skill was
# claude-code-specific and mostly superseded: discipline rules are enforced by
# the verifier, and the generated instruction.md is self-contained). To A/B
# the old skill, COPY it to /root/.claude/skills/lean4-codeprover/ (source:
# Code-Prover-V2/prover/agents/standard).

# --- Stage 1: build lean-rs-mcp (Rust port of lean-lsp-mcp) so the final
# image carries only the compiled binary.
FROM ubuntu:24.04 AS lean-mcp-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git ca-certificates build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/*
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"
COPY install_lean_rs_mcp.sh /tmp/install_lean_rs_mcp.sh
RUN bash /tmp/install_lean_rs_mcp.sh /usr/local   # -> /usr/local/bin/lean-lsp-mcp

# --- Stage 2: the task environment image.
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git ca-certificates build-essential python3 ripgrep jq procps \
    && rm -rf /var/lib/apt/lists/*

# uv — general-purpose Python tooling inside the container.
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

# Node.js + Claude Code CLI preinstalled so Harbor's installed-agent setup is
# a fast no-op instead of an npm install per trial. Other agent CLIs (codex,
# gemini, ...) are installed by their Harbor agents on demand.
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g @anthropic-ai/claude-code \
    && rm -rf /var/lib/apt/lists/*

COPY --from=lean-mcp-builder /usr/local/bin/lean-lsp-mcp /usr/local/bin/lean-lsp-mcp
COPY lean-mcp /usr/local/bin/lean-mcp
RUN chmod +x /usr/local/bin/lean-mcp

# Lean via elan, pinned to the project toolchain. Everything runs as root —
# Harbor's default agent/verifier user.
COPY lean-toolchain /tmp/lean-toolchain
RUN curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
    | bash -s -- -y --default-toolchain "$(cat /tmp/lean-toolchain)"
ENV ELAN_HOME="/root/.elan"
ENV PATH="/root/.elan/bin:/root/.local/bin:${PATH}"
RUN lean --version && lake --version

# --- The Lean project every task lives in (WORKDIR /task) ---
# A plain Mathlib project; the pre-built package tree (Mathlib + deps + repl
# oleans) is baked so no Mathlib compile ever happens at task time.
COPY lakefile.toml lean-toolchain lake-manifest.json /task/
COPY lean-packages/ /task/.lake/packages/
WORKDIR /task

# Refuse to ship an image whose baked Mathlib is incomplete (a half-built
# tree would make every Mathlib symbol "unknown constant" at runtime).
RUN test -f /task/.lake/packages/mathlib/.lake/build/lib/lean/Mathlib.olean || { \
      echo "FATAL: baked Mathlib is INCOMPLETE (Mathlib.olean missing)." >&2; \
      echo "  Re-seed images/lean-mathlib/lean-packages (see build.sh)." >&2; \
      exit 1; \
    }

# The repl binary powers lean-mcp's warm REPL mode.
RUN if [ ! -x /task/.lake/packages/repl/.lake/build/bin/repl ]; then \
      cd /task/.lake/packages/repl && lake build; \
    fi

# Sanity: a Mathlib import must elaborate from the baked oleans (seconds, not
# minutes). This also materializes /task/.lake build metadata at image-build
# time instead of first use.
RUN printf 'import Mathlib\nexample : 1 + 1 = 2 := by norm_num\n' > /tmp/sanity.lean \
    && lake env lean /tmp/sanity.lean && rm /tmp/sanity.lean

# Headless performance knobs.
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
ENV DISABLE_AUTOUPDATER=1
