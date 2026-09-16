"""Convert a leancodeprover books release (full.jsonl) into the prover-record
jsonl that `dataset.py make-math` consumes.

    python3 tools/books_to_math_jsonl.py \
        /mnt/VerifiableAILab/ziran.yang/shared/datas/leancodeprover/releases/books-v1/full.jsonl \
        data/book-v1-20260731/source/books.jsonl

Mapping per record:
  id       math/books/<h2>/<h16>   (16-hex prefix of the upstream sha256;
                                    verified collision-free for books-v1 —
                                    full ids stay recoverable by prefix)
  kind     "proof"                 (books are prove/show_verify statements)
  domain   first stage_b mathlib area (e.g. "Topology.Basic"), else "books"
  problem  ""                      (the NL statement is already embedded as a
                                    /- ... -/ docstring inside raw_source; an
                                    extra Problem: comment would duplicate it)
  lean_spec.raw_source             passed through byte-identical
"""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    out.parent.mkdir(parents=True, exist_ok=True)

    n = 0
    seen: set[str] = set()
    with open(src, encoding="utf-8") as f, open(out, "w", encoding="utf-8") as w:
        for line in f:
            rec = json.loads(line)
            h = rec["id"].rsplit("/", 1)[-1]
            short = h[:16]
            if short in seen:
                raise SystemExit(f"FATAL: 16-hex prefix collision on {h}")
            seen.add(short)
            areas = (rec.get("notes") or {}).get("books", {}).get(
                "stage_b_mathlib_area_json"
            )
            if isinstance(areas, str):
                areas = json.loads(areas or "[]")
            w.write(
                json.dumps(
                    {
                        "id": f"math/books/{short[:2]}/{short}",
                        "kind": "proof",
                        "domain": (areas or ["books"])[0],
                        "problem": "",
                        "lean_spec": {
                            "raw_source": rec["lean_spec"]["raw_source"]
                        },
                    },
                    ensure_ascii=False,
                )
                + "\n"
            )
            n += 1
    print(f"Wrote {n} record(s) to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
