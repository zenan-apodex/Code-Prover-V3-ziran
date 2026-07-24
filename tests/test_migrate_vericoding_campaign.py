from __future__ import annotations

import csv
import json
import tempfile
import unittest
from contextlib import contextmanager
from pathlib import Path
from unittest import mock

from tools import dataset as dataset_tool
from tools import migrate_vericoding_campaign as migration


class VericodingCampaignMigrationTest(unittest.TestCase):
    def test_exporter_layout_normalization_is_narrow(self) -> None:
        v2 = """-- <vc-preamble>
import Std.Do.Triple

def answer : Nat := 42
-- </vc-preamble>
"""
        v3 = """import Mathlib
import Std.Do.Triple

-- <vc-preamble>
def answer : Nat := 42
-- </vc-preamble>
"""
        changed = v3.replace("42", "43")

        self.assertEqual(migration._semantic_lines(v2), migration._semantic_lines(v3))
        self.assertNotEqual(
            migration._semantic_lines(v2), migration._semantic_lines(changed)
        )

    def test_v2_spec_wrapper_is_deterministic(self) -> None:
        self.assertEqual(
            migration._v3_source("theorem ok : True := by  \n  sorry"),
            "import Mathlib\n\ntheorem ok : True := by\n  sorry\n",
        )

    def test_materialize_uses_sparse_view_and_preserves_canonical_dataset(self) -> None:
        with self._fixture() as fixture:
            before = self._canonical_specs(fixture["dataset"])
            descriptor = migration.apply_migration(
                fixture["v2_root"],
                fixture["dataset"],
                fixture["descriptor"],
                fixture["source_manifest"],
                fixture["registry"],
            )

            self.assertEqual(before, self._canonical_specs(fixture["dataset"]))
            self.assertFalse(descriptor["leaderboard_comparable"])
            self.assertEqual(
                descriptor["dataset"]["content_sha256"],
                fixture["canonical_manifest"]["content_sha256"],
            )
            migration.verify_descriptor(fixture["descriptor"])
            migration.verify_descriptor(fixture["descriptor"], fixture["dataset"])

            payload, manifest = migration.materialize_campaign(
                fixture["descriptor"],
                fixture["dataset"],
                fixture["v2_root"],
                fixture["output"],
            )

            overlay_name = payload["tasks"]["LA0000"]["task_name"]
            unchanged_name = payload["tasks"]["LA0001"]["task_name"]
            self.assertFalse((fixture["output"] / overlay_name).is_symlink())
            self.assertTrue((fixture["output"] / unchanged_name).is_symlink())
            expected_overlay = migration._v3_source(fixture["overlay_source"])
            self.assertEqual(
                (
                    fixture["output"] / overlay_name / "environment/task.lean"
                ).read_text(),
                expected_overlay,
            )
            self.assertEqual(
                (fixture["output"] / overlay_name / "tests/original.lean").read_text(),
                expected_overlay,
            )
            self.assertEqual(before, self._canonical_specs(fixture["dataset"]))
            self.assertEqual(manifest["task_count"], 2)
            self.assertEqual(
                manifest["content_sha256"],
                descriptor["dataset"]["view_content_sha256"],
            )
            materialization = json.loads(
                (fixture["output"] / "materialization.json").read_text()
            )
            self.assertEqual(materialization["source_root"], str(fixture["v2_root"]))
            self.assertEqual(
                materialization["selected_content_sha256"],
                descriptor["dataset"]["selected_content_sha256"],
            )

    def test_tampered_overlay_fails_before_output_is_published(self) -> None:
        with self._fixture() as fixture:
            migration.apply_migration(
                fixture["v2_root"],
                fixture["dataset"],
                fixture["descriptor"],
                fixture["source_manifest"],
                fixture["registry"],
            )
            fixture["overlay_path"].write_text("theorem tampered : False := by sorry\n")

            with self.assertRaisesRegex(migration.MigrationError, "overlay spec hash"):
                migration.materialize_campaign(
                    fixture["descriptor"],
                    fixture["dataset"],
                    fixture["v2_root"],
                    fixture["output"],
                )

            self.assertFalse(fixture["output"].exists())
            self.assertEqual(list(fixture["output"].parent.glob(".view.*")), [])

    def test_verify_rejects_overlay_written_into_canonical_dataset(self) -> None:
        with self._fixture() as fixture:
            descriptor = migration.apply_migration(
                fixture["v2_root"],
                fixture["dataset"],
                fixture["descriptor"],
                fixture["source_manifest"],
                fixture["registry"],
            )
            task_name = descriptor["tasks"]["LA0000"]["task_name"]
            migrated = migration._v3_source(fixture["overlay_source"])
            task = fixture["dataset"] / task_name
            (task / "environment/task.lean").write_text(migrated)
            (task / "tests/original.lean").write_text(migrated)
            dataset_tool.write_manifest(fixture["dataset"])

            with self.assertRaisesRegex(migration.MigrationError, "pinned pristine"):
                migration.verify_descriptor(fixture["descriptor"], fixture["dataset"])

    @staticmethod
    def _canonical_specs(dataset: Path) -> dict[str, bytes]:
        return {
            task.parent.parent.name: task.read_bytes()
            for task in dataset.glob("*/environment/task.lean")
        }

    @contextmanager
    def _fixture(self):
        with tempfile.TemporaryDirectory() as raw_root:
            root = Path(raw_root)
            dataset = root / "tasks/vericoding_lean"
            v2_root = root / "v2"
            benchmark_root = v2_root / "benchmarks/vericoding-benchmark"
            compatibility_root = (
                v2_root / "benchmarks/compatibility/vericoding-benchmark"
            )
            campaign_root = v2_root / "benchmarks/campaigns"
            migration_root = root / "migration/v2"
            output = root / "tasks/_campaign_views/view"

            original_sources = {
                "LA0000": "theorem first : True := by\n  sorry\n",
                "LA0001": "theorem second : True := by\n  sorry\n",
            }
            overlay_source = "theorem first : True := by\n  trivial\n"
            task_names = {
                "LA0000": "vericoding__LA0000_apps_case_0",
                "LA0001": "vericoding__LA0001_apps_case_1",
            }
            for benchmark_id, task_name in task_names.items():
                self._write_task(
                    dataset / task_name,
                    source_id=f"vericoding/{benchmark_id}_apps_case",
                    source=migration._v3_source(original_sources[benchmark_id]),
                )
                original = benchmark_root / f"specs/{benchmark_id}_specs.lean"
                original.parent.mkdir(parents=True, exist_ok=True)
                original.write_text(original_sources[benchmark_id])

            overlay_path = compatibility_root / "lean428/specs/LA0000_specs.lean"
            overlay_path.parent.mkdir(parents=True, exist_ok=True)
            overlay_path.write_text(overlay_source)
            overlay_manifest = {
                "schema_version": 1,
                "task_count": 1,
                "tasks": {
                    "LA0000": {
                        "original_path": "specs/LA0000_specs.lean",
                        "overlay_path": "lean428/specs/LA0000_specs.lean",
                        "original_sha256": migration.sha256_file(
                            benchmark_root / "specs/LA0000_specs.lean"
                        ),
                        "overlay_sha256": migration.sha256_file(overlay_path),
                    }
                },
            }
            overlay_manifest_path = (
                compatibility_root / "lean428/migration-manifest.json"
            )
            overlay_manifest_path.write_text(
                json.dumps(overlay_manifest, indent=2) + "\n"
            )
            overlay_manifest_sha = migration.sha256_file(overlay_manifest_path)

            csv_path = benchmark_root / "vericoding_benchmark_v1.csv"
            with csv_path.open("w", newline="", encoding="utf-8") as handle:
                writer = csv.DictWriter(
                    handle,
                    fieldnames=["id", "language", "qa-issue", "source", "source-id"],
                )
                writer.writeheader()
                writer.writerow(
                    {
                        "id": "LA0000",
                        "language": "lean",
                        "qa-issue": "0",
                        "source": "apps",
                        "source-id": "case_0",
                    }
                )
                writer.writerow(
                    {
                        "id": "LA0001",
                        "language": "lean",
                        "qa-issue": "0",
                        "source": "apps",
                        "source-id": "case_1",
                    }
                )
            selection_sha = migration.sha256_bytes(b"LA0000\nLA0001\n")
            selection_csv_sha = migration.sha256_file(csv_path)
            revision = "a" * 40
            campaign = {
                "schema_version": 1,
                "name": migration.CAMPAIGN_NAME,
                "benchmarks": {
                    "vericoding": {
                        "upstream_url": "https://example.invalid/vericoding.git",
                        "revision": revision,
                        "record_count": 2,
                        "ordered_ids_sha256": selection_sha,
                        "selection": "fixture selection",
                        "track": "lean-compile-clean-unseen",
                        "lean_tracks": {
                            "aligned-lean428": {
                                "overlay_count": 1,
                                "migration_manifest_sha256": overlay_manifest_sha,
                            }
                        },
                    }
                },
            }
            campaign_root.mkdir(parents=True, exist_ok=True)
            campaign_path = campaign_root / "formal-benchmark-campaign-v1.campaign.json"
            campaign_path.write_text(json.dumps(campaign, indent=2) + "\n")
            canonical_manifest = dataset_tool.write_manifest(dataset)
            canonical_selected_sha = migration.sha256_bytes(
                "".join(
                    f"{benchmark_id} {task_names[benchmark_id]} "
                    f"{canonical_manifest['tasks'][task_names[benchmark_id]]}\n"
                    for benchmark_id in task_names
                ).encode()
            )
            final_hashes = {
                "LA0000": migration.sha256_bytes(
                    migration._v3_source(overlay_source).encode()
                ),
                "LA0001": canonical_manifest["tasks"][task_names["LA0001"]],
            }
            final_selected_sha = migration.sha256_bytes(
                "".join(
                    f"{benchmark_id} {task_names[benchmark_id]} "
                    f"{final_hashes[benchmark_id]}\n"
                    for benchmark_id in task_names
                ).encode()
            )
            view_sha = migration.sha256_bytes(
                "".join(
                    f"{task_name} {final_hashes[benchmark_id]}\n"
                    for benchmark_id, task_name in sorted(
                        task_names.items(), key=lambda item: item[1]
                    )
                ).encode()
            )

            values = {
                "EXPECTED_UPSTREAM_REVISION": revision,
                "EXPECTED_SELECTION_COUNT": 2,
                "EXPECTED_SELECTION_SHA256": selection_sha,
                "EXPECTED_SELECTION_CSV_SHA256": selection_csv_sha,
                "EXPECTED_OVERLAY_COUNT": 1,
                "EXPECTED_OVERLAY_MANIFEST_SHA256": overlay_manifest_sha,
                "EXPECTED_PRE_MIGRATION_DATASET_SHA256": canonical_manifest[
                    "content_sha256"
                ],
                "EXPECTED_CANONICAL_TASK_COUNT": 2,
                "EXPECTED_CANONICAL_SELECTED_CONTENT_SHA256": canonical_selected_sha,
                "EXPECTED_FINAL_SELECTED_CONTENT_SHA256": final_selected_sha,
                "EXPECTED_VIEW_CONTENT_SHA256": view_sha,
            }
            with mock.patch.multiple(migration, **values):
                yield {
                    "v2_root": v2_root,
                    "dataset": dataset,
                    "canonical_manifest": canonical_manifest,
                    "descriptor": migration_root / "descriptor.json",
                    "source_manifest": migration_root / "source-manifest.json",
                    "registry": migration_root / "campaign.json",
                    "output": output,
                    "overlay_path": overlay_path,
                    "overlay_source": overlay_source,
                }

    @staticmethod
    def _write_task(task: Path, *, source_id: str, source: str) -> None:
        (task / "environment").mkdir(parents=True)
        (task / "tests").mkdir()
        (task / "environment/task.lean").write_text(source)
        (task / "tests/original.lean").write_text(source)
        (task / "task.toml").write_text(
            "[metadata]\n"
            f'source_dataset = "{migration.DATASET_NAME}"\n'
            f'source_id = "{source_id}"\n'
        )


if __name__ == "__main__":
    unittest.main()
