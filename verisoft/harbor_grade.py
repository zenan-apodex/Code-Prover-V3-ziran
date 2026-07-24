#!/usr/bin/env python3
"""Harbor verifier for the frozen VeriSoftBench filtered-context track.

The environment image supplies the frozen upstream Python package and the 23
pre-built Lean repositories.  This adapter only bridges Harbor's answer-file
contract to VeriSoftBench's native proof extraction and ``LeanREPL`` compile
checker.  It intentionally does not use Code-Prover-V3's single-file grader.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _json(path: Path) -> dict:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"expected JSON object: {path}")
    return value


def _clean_thm_stmt(thm_stmt: str, ground_truth: str = "", native_utils=None) -> str:
    """Frozen ``core.evaluator._clean_thm_stmt`` separator semantics."""
    # Importing core.evaluator would also import every model-provider client.
    # Keep this small adapter local while attesting the source evaluator hash.
    body_patterns = {
        r":=\s+by\b",
        r":=\s+match\b",
        r":=\s+calc\b",
        r":=\s+fun\b",
        r":=\s+λ\b",
        r":=\s+begin\b",
        r"\bwhere\b",
        r"(?<!<)\|\s+(?!<)\S",
    }
    if native_utils is not None:
        separator, pattern = native_utils.find_decl_body_separator(thm_stmt)
        if separator > 0 and pattern in body_patterns:
            thm_stmt = thm_stmt[:separator].rstrip()
        elif separator > 0 and thm_stmt[separator : separator + 2] == ":=":
            thm_stmt = thm_stmt[:separator].rstrip()
    else:
        body = re.search("|".join(f"(?:{item})" for item in body_patterns), thm_stmt)
        if body:
            thm_stmt = thm_stmt[: body.start()].rstrip()
    stripped = thm_stmt.rstrip()
    if stripped.endswith(":="):
        stripped = stripped[:-2].rstrip()
    elif stripped.endswith("where"):
        stripped = stripped[:-5].rstrip()
    gt = ground_truth.strip()
    return stripped if gt.startswith(("where", "|")) else stripped + " :="


def _verification_context(entry: dict, repos_root: Path, native_utils) -> str:
    """Frozen filtered-track verification context construction."""
    lean_root = entry["lean_root"]
    rel_path = entry["rel_path"]
    imports = list(entry["imports"])
    if lean_root == "iris-lean":
        imports = [item.replace("import src.", "import ") for item in imports]
    local_ctx = entry.get("local_ctxs") or entry.get("local_ctx")
    if local_ctx is None:
        raise KeyError("entry has neither local_ctxs nor local_ctx")
    fallback = "\n".join(imports) + "\n" + local_ctx
    source = repos_root / lean_root / rel_path
    full = source.read_text(encoding="utf-8")
    statement = entry["thm_stmt"]
    context = native_utils.get_content_before_theorem(
        full, statement, thm_name=entry["thm_name"]
    )
    if context is None:
        namespace = entry["thm_name"].rsplit(".", 1)
        if len(namespace) > 1:
            full_name = namespace[0]
            last = full_name.rsplit(".", 1)[-1]
            pattern = re.compile(
                rf"^end\s+{re.escape(full_name)}\s*$|^end\s+{re.escape(last)}\s*$",
                re.MULTILINE,
            )
            matches = list(pattern.finditer(full))
            context = full[: matches[-1].start()] if matches else fallback
        else:
            context = fallback
    context = re.sub(
        r"^noncomputable\s+(theorem|lemma)\b",
        r"\1",
        context,
        flags=re.MULTILINE,
    )
    context = re.sub(
        r"(prove_correct\??\s+\w+)\s+by\n.*?(?=\n\n|\n(?:prove_correct|theorem|lemma|def|--[^\n]*\n\n))",
        r"\1 by sorry",
        context,
        flags=re.DOTALL,
    )
    lines = statement.splitlines()
    if lines and lines[0].strip().startswith("@[") and lines[0].strip().endswith("]"):
        attr = lines[0].strip()
        context_lines = context.rstrip().splitlines()
        if context_lines and context_lines[-1].strip() == attr:
            context = "\n".join(context_lines[:-1]) + "\n"
    if "BLAKE3/ApplyRounds" in rel_path or "BLAKE3.ApplyRounds" in entry["thm_name"]:
        lines = context.splitlines()
        last_import = max(
            (i for i, line in enumerate(lines) if line.strip().startswith("import ")),
            default=-1,
        )
        lines.insert(
            last_import + 1 if last_import >= 0 else 0,
            "\nset_option maxRecDepth 16384\nset_option maxHeartbeats 0",
        )
        context = "\n".join(lines)
        context = re.sub(r"\(by\b\n.*?\)", "(by sorry)", context, flags=re.DOTALL)
    return context


def _attest(
    entry_path: Path,
    attestation_path: Path,
    repo_pins_path: Path,
    release_root: Path,
    repos_root: Path,
) -> tuple[dict, dict]:
    attestation = _json(attestation_path)
    raw_entry = entry_path.read_bytes().rstrip(b"\r\n")
    expected = attestation["task"]
    if hashlib.sha256(raw_entry).hexdigest() != expected["record_sha256"]:
        raise ValueError("task record hash mismatch")
    entry = json.loads(raw_entry)
    for key in ("id", "thm_name", "lean_root", "rel_path"):
        if entry.get(key) != expected.get(key):
            raise ValueError(f"task identity mismatch: {key}")

    if _sha256(repo_pins_path) != attestation["repos_sha256"]:
        raise ValueError("task repo pins hash mismatch")
    image_repos = Path("/workspace/repos.json")
    if _sha256(image_repos) != attestation["repos_sha256"]:
        raise ValueError("image repo pins hash mismatch")

    for rel, digest in attestation["native_files"].items():
        path = release_root / rel
        if not path.is_file() or _sha256(path) != digest:
            raise ValueError(f"native evaluator file mismatch: {rel}")

    pins = _json(repo_pins_path)["repos"]
    repo = entry["lean_root"]
    pin = pins[repo]
    repo_root = repos_root / repo
    revision_file = repo_root / ".verisoftbench-source-revision"
    if revision_file.read_text(encoding="utf-8").strip() != pin["commit"]:
        raise ValueError(f"repository revision mismatch: {repo}")
    if (repo_root / "lean-toolchain").read_text(encoding="utf-8").strip() != pin[
        "lean_toolchain"
    ]:
        raise ValueError(f"repository toolchain mismatch: {repo}")
    if not (repo_root / entry["rel_path"]).is_file():
        raise ValueError("task source file missing from pinned repository")
    return entry, attestation


def _write_result(out_dir: Path, reward: dict, details: dict) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "reward.json").write_text(
        json.dumps(reward, sort_keys=True) + "\n", encoding="utf-8"
    )
    (out_dir / "grade_details.json").write_text(
        json.dumps(details, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def grade(args: argparse.Namespace) -> tuple[dict, dict]:
    entry, attestation = _attest(
        args.entry,
        args.attestation,
        args.repo_pins,
        args.release_root,
        args.repos_root,
    )
    answer = args.answer.read_text(encoding="utf-8")

    sys.path.insert(0, str(args.release_root))
    from core.lean_interface import LeanREPL  # type: ignore
    import utils.utils as native_utils  # type: ignore

    # Native utility globals otherwise point at release/data, while the image
    # intentionally stores the compiled repositories under /workspace.
    native_utils.LEAN_SRC_DIR = args.repos_root
    native_utils.REPO_INDEX_DIR = Path("/workspace/repo_index")

    entry = dict(entry)
    entry["thm_stmt"] = _clean_thm_stmt(
        entry["thm_stmt"], entry.get("ground_truth_proof", ""), native_utils
    )
    proof = native_utils.get_proof_from_llm_output(answer)
    lemmas = native_utils.get_lemmas_from_llm_output(answer)
    parsed = bool(proof.strip())
    incomplete = native_utils.check_generated_content_for_incomplete_proofs(
        entry["thm_name"], proof, lemmas
    )
    if not parsed:
        incomplete.append("missing <lean4_proof> response")

    context = _verification_context(entry, args.repos_root, native_utils)
    mapping = native_utils.find_conflicting_names_from_local_context(context, lemmas)
    lemmas, proof = native_utils.apply_name_replacements(lemmas, proof, mapping)
    while "axiom " in lemmas:
        lemmas = lemmas.replace("axiom ", "theorem ")
    proof, lemmas = native_utils.clean_leaked_identifiers(entry, proof, lemmas)

    success = False
    error = "; ".join(incomplete)
    if not incomplete:
        repl = LeanREPL(args.repos_root)
        success, error = repl.verify_proof(
            thm_name=entry["thm_name"],
            repo_name=entry["lean_root"],
            rel_path=entry["rel_path"],
            local_context=context,
            theorem_stmt=entry["thm_stmt"],
            theorem_proof=proof,
            proof_id="harbor",
            aux_lemmas=lemmas,
            suffix=entry.get("suffix", ""),
        )
        if not success and error and "has already been declared" in error:
            retry_mapping = native_utils.find_conflicting_names_from_error(
                error, lemmas
            )
            if retry_mapping:
                lemmas, proof = native_utils.apply_name_replacements(
                    lemmas, proof, retry_mapping
                )
                proof, lemmas = native_utils.clean_leaked_identifiers(
                    entry, proof, lemmas
                )
                success, error = repl.verify_proof(
                    thm_name=entry["thm_name"],
                    repo_name=entry["lean_root"],
                    rel_path=entry["rel_path"],
                    local_context=context,
                    theorem_stmt=entry["thm_stmt"],
                    theorem_proof=proof,
                    proof_id="harbor_retry",
                    aux_lemmas=lemmas,
                    suffix=entry.get("suffix", ""),
                )

    value = 1.0 if success else 0.0
    # The five compatibility fields let the shared V3 audit tool score this
    # custom campaign.  ``axioms_ok`` mirrors native acceptance: VeriSoftBench
    # is a compile-check track, not an axiom-audit track.
    reward = {
        "reward": value,
        "sorry_free": 1.0 if not incomplete else 0.0,
        "spec_intact": 1.0,
        "forbidden_free": 1.0 if not incomplete else 0.0,
        "compiled": value,
        "axioms_ok": value,
    }
    details = {
        "schema_version": 1,
        "campaign": attestation["campaign"],
        "track": "filtered_context",
        "native_compile_checker": True,
        "axioms_ok_metric": "native-compile-track compatibility mirror",
        "task_id": entry["id"],
        "repository": entry["lean_root"],
        "response_parsed": parsed,
        "incomplete_errors": incomplete,
        "success": success,
        "error": error or None,
    }
    return reward, details


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--entry", type=Path, default=Path("/tests/entry.json"))
    parser.add_argument(
        "--attestation", type=Path, default=Path("/tests/attestation.json")
    )
    parser.add_argument("--repo-pins", type=Path, default=Path("/tests/repos.json"))
    parser.add_argument("--answer", type=Path, default=Path("/task/answer.txt"))
    parser.add_argument("--release-root", type=Path, default=Path("/opt/verisoftbench"))
    parser.add_argument(
        "--repos-root", type=Path, default=Path("/workspace/lean_repos")
    )
    parser.add_argument("--out-dir", type=Path, default=Path("/logs/verifier"))
    args = parser.parse_args()
    try:
        reward, details = grade(args)
    except Exception as exc:  # fail closed, but always satisfy Harbor's output contract
        reward = {
            "reward": 0.0,
            "sorry_free": 0.0,
            "spec_intact": 0.0,
            "forbidden_free": 0.0,
            "compiled": 0.0,
            "axioms_ok": 0.0,
        }
        details = {"schema_version": 1, "success": False, "fatal": str(exc)}
    _write_result(args.out_dir, reward, details)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
