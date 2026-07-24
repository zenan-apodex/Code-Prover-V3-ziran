from __future__ import annotations

import argparse
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from tools import migrate_verisoft_campaign as migration
from verisoft import harbor_grade


REPO_ROOT = Path(__file__).resolve().parents[1]
LOCAL_RELEASE = REPO_ROOT.parent / "Code-Prover-V2/benchmarks/VeriSoftBench"


class VeriSoftCampaignMigrationTest(unittest.TestCase):
    def test_committed_descriptor_binds_all_500_ids_and_23_repos(self) -> None:
        payload = migration.verify_descriptor()

        self.assertEqual(payload["task_count"], 500)
        self.assertEqual(list(payload["tasks"]), [str(i) for i in range(1, 501)])
        self.assertEqual(payload["repository_count"], 23)
        self.assertEqual(payload["track"], "filtered_context")
        self.assertFalse(payload["native_fix_enabled"])

    def test_repo_pin_tamper_fails_closed(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            pins = Path(tmp) / "repos.json"
            value = json.loads(migration.REPO_PINS.read_text(encoding="utf-8"))
            value["repos"]["ArkLib"]["commit"] = "0" * 40
            pins.write_text(json.dumps(value), encoding="utf-8")

            with self.assertRaisesRegex(migration.MigrationError, "repo pins hash"):
                migration.verify_descriptor(repo_pins_path=pins)

    def test_native_separator_semantics(self) -> None:
        self.assertEqual(
            harbor_grade._clean_thm_stmt(
                "theorem x : True := by trivial", "by trivial"
            ),
            "theorem x : True :=",
        )
        self.assertEqual(
            harbor_grade._clean_thm_stmt("theorem x : True :=", "where\n  x := 1"),
            "theorem x : True",
        )

    def test_default_runtime_view_is_not_a_canonical_dataset(self) -> None:
        self.assertIn("tasks/_campaign_views/", str(migration.DEFAULT_OUT))

    @unittest.skipUnless(LOCAL_RELEASE.is_dir(), "local frozen V2 release unavailable")
    def test_one_task_materialization_preserves_native_prompt_and_oracle(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "view"
            args = argparse.Namespace(
                descriptor=migration.DESCRIPTOR,
                repo_pins=migration.REPO_PINS,
                source_release=LOCAL_RELEASE,
                out=out,
                image=migration.DEFAULT_IMAGE,
                limit=1,
                force=False,
            )
            self.assertEqual(migration.cmd_materialize(args), 0)
            task = next(path for path in out.iterdir() if path.is_dir())
            instruction = (task / "instruction.md").read_text(encoding="utf-8")
            self.assertIn("<used_lib_defs>", instruction)
            self.assertIn("<target_theorem>", instruction)
            self.assertIn("/task/answer.txt", instruction)
            self.assertEqual(
                (task / "environment/Dockerfile").read_text(encoding="utf-8"),
                f"FROM {migration.DEFAULT_IMAGE}\nWORKDIR /task\n",
            )
            answer = Path(tmp) / "answer.txt"
            script = (task / "solution/solve.sh").read_text(encoding="utf-8")
            script = script.replace("/task/answer.txt", str(answer))
            local_script = Path(tmp) / "solve.sh"
            local_script.write_text(script, encoding="utf-8")
            local_script.chmod(0o755)
            subprocess.run([str(local_script)], check=True)
            oracle = answer.read_text(encoding="utf-8")
            self.assertIn("<lean4_proof>\nby", oracle)
            self.assertNotIn(":= by", oracle.split("<lean4_proof>", 1)[1][:10])


if __name__ == "__main__":
    unittest.main()
