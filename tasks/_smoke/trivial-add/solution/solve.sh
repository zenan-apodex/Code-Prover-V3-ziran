#!/bin/bash
# Oracle solution for the trivial-add smoke task: fills the code and proof
# sorries via marker-region replacement, exactly as an agent would.
set -euo pipefail

python3 - <<'EOF'
import re

path = "/task/trivial-add.lean"
src = open(path, encoding="utf-8").read()

def fill(src: str, region: str, body: str) -> str:
    pattern = re.compile(
        rf"(--\s*!benchmark\s+@start\s+{region}\n).*?(\s*--\s*!benchmark\s+@end\s+{region})",
        re.DOTALL,
    )
    return pattern.sub(lambda m: m.group(1) + body + m.group(2), src, count=1)

src = fill(src, "code", "  a + b")
src = fill(src, "proof", "  unfold myAdd\n  simp")
open(path, "w", encoding="utf-8").write(src)
print("solution applied")
EOF

export PATH="/root/.elan/bin:$PATH"
cd /task && lake env lean trivial-add.lean && echo "solution compiles"
