from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from tools import migrate_vero_campaign as migration
from vero import harbor_grade


REPO_ROOT = Path(__file__).resolve().parents[1]


class VeroCampaignMigrationTest(unittest.TestCase):
    def test_committed_descriptor_preserves_frozen_contract(self) -> None:
        payload = migration.verify_descriptor(
            REPO_ROOT / "migration/v2/vero-proof-44.json"
        )
        self.assertEqual(payload["task_count"], 44)
        self.assertEqual(payload["track"], "proof")
        self.assertEqual(payload["lean_toolchain"], "leanprover/lean4:v4.29.1")
        self.assertEqual(
            migration.ordered_ids_sha256(payload["ordered_ids"]),
            migration.EXPECTED_ORDERED_IDS_SHA256,
        )
        self.assertNotIn("bankledger", payload["ordered_ids"])
        self.assertNotIn("tiny_unsat", payload["ordered_ids"])
        self.assertEqual(
            payload["dataset_identity"]["not_a_substitute_for"],
            "tasks/verobench_124",
        )
        self.assertEqual(
            payload["grader"]["native_lifecycle"],
            [
                "schema_driven_extract",
                "fresh_render_from_frozen_benchmark",
                "fresh_harness_build",
                "per_theorem_axiom_audit",
                "native_spec_aggregation",
            ],
        )

    def test_descriptor_rejects_an_excluded_fixture(self) -> None:
        original = json.loads(
            (REPO_ROOT / "migration/v2/vero-proof-44.json").read_text()
        )
        original["ordered_ids"][-1] = "tiny_unsat"
        original["tasks"]["tiny_unsat"] = original["tasks"].pop("vest")
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "bad.json"
            path.write_text(json.dumps(original))
            with self.assertRaises(migration.MigrationError):
                migration.verify_descriptor(path)

    def test_native_snapshot_hash_fails_on_runtime_tampering(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            runtime = Path(temporary)
            (runtime / "src/vero").mkdir(parents=True)
            (runtime / "templates").mkdir()
            (runtime / "benchmarks/primepy").mkdir(parents=True)
            (runtime / "src/vero/module.py").write_text("VALUE = 1\n")
            (runtime / "templates/proof.j2").write_text("proof\n")
            (runtime / "benchmarks/primepy/manifest.json").write_text("{}\n")
            (runtime / "pyproject.toml").write_text("[project]\nname='vero'\n")
            before = harbor_grade.snapshot_sha256(runtime, "benchmarks/primepy")
            (runtime / "src/vero/module.py").write_text("VALUE = 2\n")
            after = harbor_grade.snapshot_sha256(runtime, "benchmarks/primepy")
            self.assertNotEqual(before, after)

    def test_materializer_emits_thin_harbor_native_view(self) -> None:
        descriptor_path = REPO_ROOT / "migration/v2/vero-proof-44.json"
        descriptor = migration.verify_descriptor(descriptor_path)
        sources = [
            migration.SourceTask(**descriptor["tasks"][source_id])
            for source_id in descriptor["ordered_ids"]
        ]
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "vero-proof-44"
            with mock.patch.object(migration, "audit_upstream", return_value=sources):
                migration.materialize(descriptor_path, Path(temporary), output)
            task_dirs = sorted(
                path for path in output.iterdir() if (path / "task.toml").is_file()
            )
            self.assertEqual(len(task_dirs), 44)
            self.assertFalse((output / "bankledger").exists())
            self.assertFalse((output / "tiny_unsat").exists())
            primepy = output / "primepy"
            dockerfile = (primepy / "environment/Dockerfile").read_text()
            test_shell = (primepy / "tests/test.sh").read_text()
            self.assertTrue((primepy / "tests/test.sh").stat().st_mode & 0o111)
            self.assertIn(migration.UPSTREAM_REVISION, dockerfile)
            self.assertIn("leanprover/lean4:v4.29.1", dockerfile)
            self.assertIn("mode='proof'", dockerfile)
            self.assertIn("/tests/grade.py", test_shell)
            self.assertIn("--expected-snapshot-sha256", test_shell)
            grader = (primepy / "tests/grade.py").read_text()
            self.assertIn("run_evaluation", grader)
            self.assertIn('extract(sandbox_dir, bench, mode="proof")', grader)


if __name__ == "__main__":
    unittest.main()
