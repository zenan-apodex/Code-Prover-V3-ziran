from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest import mock

from tools import migrate_putnam_campaign as migration


REPO_ROOT = Path(__file__).resolve().parents[1]


class PutnamCampaignMigrationTest(unittest.TestCase):
    @staticmethod
    def _synthetic_campaign() -> tuple[list[tuple[str, bytes, bytes, bytes]], dict]:
        source = b"theorem demo : True :=\n  sorry\n"
        rewritten = source
        task_spec = migration.add_proof_markers(rewritten.decode()).encode()
        task_id = "demo"
        spec_hash = migration.sha256_bytes(task_spec)
        tasks = {
            task_id: {
                "task_name": task_id,
                "source_id": f"putnambench/{task_id}",
                "official_source_sha256": migration.sha256_bytes(source),
                "rewritten_source_sha256": migration.sha256_bytes(rewritten),
                "readonly_projection_sha256": migration.sha256_bytes(
                    migration.readonly_projection(task_spec.decode()).encode()
                ),
                "spec_sha256": spec_hash,
            }
        }
        descriptor = {
            "name": migration.DESCRIPTOR_NAME,
            "task_count": 1,
            "statement_overlay_count": 0,
            "dataset": {
                "default_materialized_view": (
                    migration.DEFAULT_MATERIALIZED_VIEW.as_posix()
                ),
                "content_sha256": migration.sha256_bytes(
                    f"{task_id} {spec_hash}\n".encode()
                ),
            },
            "tasks": tasks,
        }
        return [(task_id, source, rewritten, task_spec)], descriptor

    def test_numeric_answer_rewrite_is_narrow(self) -> None:
        source = """import Mathlib

noncomputable abbrev answer : ℝ := sorry
-- Real.pi / 15
/-- statement -/
theorem demo : answer = answer :=
  sorry
"""
        self.assertEqual(
            migration.rewrite_numeric_answer(source),
            """import Mathlib

-- Real.pi / 15
/-- statement -/
theorem demo : ((Real.pi / 15) : ℝ ) = ((Real.pi / 15) : ℝ ) :=
  sorry
""",
        )

    def test_standalone_proof_hole_gets_one_editable_region(self) -> None:
        source = "theorem demo : True :=\n  sorry\n"
        migrated = migration.add_proof_markers(source)

        self.assertEqual(
            migrated,
            """theorem demo : True :=
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
""",
        )
        projection = migration.readonly_projection(migrated)
        self.assertIn("theorem demo : True :=", projection)
        self.assertNotIn("sorry", projection)

    def test_inline_proof_hole_keeps_theorem_proposition(self) -> None:
        source = "theorem demo (A B : Set Nat) : A = B := sorry\n"
        migrated = migration.add_proof_markers(source)

        self.assertEqual(
            migrated,
            """theorem demo (A B : Set Nat) : A = B :=
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
""",
        )
        original_prefix = source.split(":=", 1)[0]
        migrated_prefix = migrated.split(":=", 1)[0]
        self.assertEqual(original_prefix, migrated_prefix)

    def test_marker_transform_fails_closed_on_extra_hole(self) -> None:
        with self.assertRaises(migration.MigrationError):
            migration.add_proof_markers(
                "theorem a : True := sorry\ntheorem b : True := sorry\n"
            )

    def test_committed_campaign_descriptor(self) -> None:
        descriptor = REPO_ROOT / "migration/v2/putnambench-aligned-lean428-672.json"
        payload = migration.verify_descriptor(descriptor)

        self.assertEqual(payload["task_count"], 672)
        self.assertEqual(payload["statement_overlay_count"], 0)
        self.assertEqual(payload["lean_profile"], "lean4.28-mathlib4.28")
        self.assertEqual(
            payload["dataset"]["default_materialized_view"],
            "tasks/_campaign_views/putnambench-672",
        )

    def test_materialize_audits_before_writing(self) -> None:
        _records, descriptor = self._synthetic_campaign()
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "views/putnambench-672"
            with (
                mock.patch.object(
                    migration, "verify_descriptor", return_value=descriptor
                ),
                mock.patch.object(
                    migration,
                    "_validate_v2",
                    side_effect=migration.MigrationError("source hash mismatch"),
                ),
            ):
                with self.assertRaisesRegex(
                    migration.MigrationError, "source hash mismatch"
                ):
                    migration.materialize_campaign(
                        Path(temporary) / "v2",
                        Path(temporary) / "descriptor.json",
                        output,
                    )
            self.assertFalse(output.exists())
            self.assertFalse(output.parent.exists())

    def test_materialize_is_atomic_and_validates_local_view(self) -> None:
        records, descriptor = self._synthetic_campaign()
        expected_content = descriptor["dataset"]["content_sha256"]
        real_write_task = migration.dataset_tool.write_task
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "views/putnambench-672"

            def guarded_write(*args, **kwargs) -> None:
                self.assertFalse(output.exists())
                real_write_task(*args, **kwargs)

            with (
                mock.patch.object(migration, "EXPECTED_TASK_COUNT", 1),
                mock.patch.object(
                    migration, "EXPECTED_DATASET_CONTENT_SHA256", expected_content
                ),
                mock.patch.object(
                    migration, "verify_descriptor", return_value=descriptor
                ),
                mock.patch.object(
                    migration, "_validate_v2", return_value=(records, {}, {})
                ),
                mock.patch.object(
                    migration.dataset_tool, "write_task", side_effect=guarded_write
                ),
            ):
                payload, manifest = migration.materialize_campaign(
                    Path(temporary) / "v2", Path(temporary) / "descriptor.json", output
                )

            self.assertIs(payload, descriptor)
            self.assertEqual(manifest["task_count"], 1)
            self.assertEqual(manifest["content_sha256"], expected_content)
            self.assertEqual(manifest["name"], output.name)
            self.assertTrue((output / "demo/environment/task.lean").is_file())
            self.assertEqual(
                (output / "demo/environment/task.lean").read_bytes(),
                (output / "demo/tests/original.lean").read_bytes(),
            )

            (output / "demo/tests/original.lean").write_text(
                "tampered\n", encoding="utf-8"
            )
            with mock.patch.object(migration, "EXPECTED_TASK_COUNT", 1):
                with self.assertRaisesRegex(
                    migration.MigrationError, "verifier mirror mismatch"
                ):
                    migration.verify_materialized_dataset(descriptor, output)


if __name__ == "__main__":
    unittest.main()
