from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch

REPO_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO_ROOT))

from tools import harbor_results  # noqa: E402


AGENT = {
    "name": "fixture-agent",
    "import_path": None,
    "model_name": "fixture-model",
    "skills": [],
    "resume_trajectory": False,
    "kwargs": {},
}


class HarborFixture:
    def __init__(self, root: Path, *, tasks: tuple[str, ...], k: int) -> None:
        self.root = root
        self.repo = root / "repo"
        self.tasks_root = self.repo / "tasks"
        self.dataset = self.tasks_root / "fixture"
        self.job = root / "job"
        self.out = root / "out"
        self.job.mkdir(parents=True)
        self.dataset.mkdir(parents=True)
        hashes: dict[str, str] = {}
        for task_name in tasks:
            task_dir = self.dataset / task_name
            (task_dir / "environment").mkdir(parents=True)
            source = f"theorem {task_name.replace('-', '_')} : True := by\n  sorry\n"
            (task_dir / "environment" / "task.lean").write_text(
                source, encoding="utf-8"
            )
            (task_dir / "task.toml").write_text(
                'schema_version = "1.3"\n\n'
                "[metadata]\n"
                f'source_id = "{task_name}"\n'
                'source_dataset = "fixture"\n',
                encoding="utf-8",
            )
            hashes[task_name] = hashlib.sha256(source.encode()).hexdigest()
        manifest = {
            "schema_version": 1,
            "name": "fixture",
            "task_count": len(tasks),
            "content_sha256": hashlib.sha256(
                json.dumps(hashes, sort_keys=True).encode()
            ).hexdigest(),
            "lean_profile": "lean4.28-mathlib4.28",
            "tasks": hashes,
        }
        (self.dataset / "manifest.json").write_text(
            json.dumps(manifest), encoding="utf-8"
        )
        trials = []
        for task_name in tasks:
            for _ in range(k):
                trials.append(
                    {
                        "schema_version": 1,
                        "task": {
                            "name": task_name,
                            "type": "local",
                            "digest": f"sha256:lock-{task_name}",
                            "source": "fixture",
                            "path": f"tasks/fixture/{task_name}",
                        },
                        "agent": AGENT,
                    }
                )
        self._write_json(
            self.job / "config.json",
            {"job_name": "fixture-job", "datasets": [{"path": "tasks/fixture"}]},
        )
        self._write_json(
            self.job / "lock.json",
            {
                "schema_version": 2,
                "harbor": {"version": "0.20.0"},
                "trials": trials,
            },
        )
        self._write_job_result(total=len(trials), completed=0, pending=len(trials))

    @staticmethod
    def _write_json(path: Path, payload: object) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    def _write_job_result(self, *, total: int, completed: int, pending: int) -> None:
        self._write_json(
            self.job / "result.json",
            {
                "id": "job-id",
                "started_at": "2026-07-21T00:00:00Z",
                "finished_at": "2026-07-21T00:10:00Z" if pending == 0 else None,
                "n_total_trials": total,
                "stats": {
                    "n_completed_trials": completed,
                    "n_errored_trials": 0,
                    "n_running_trials": 0,
                    "n_pending_trials": pending,
                },
            },
        )

    def add_trial(
        self,
        task_name: str,
        index: int,
        *,
        reward: float | None,
        raw_reward: float | None = None,
        exception: dict | None = None,
        input_tokens: int | None = 100,
        cache_tokens: int | None = 20,
        output_tokens: int | None = 10,
    ) -> Path:
        trial_name = f"{task_name}__{index}"
        trial_dir = self.job / trial_name
        rewards = None
        if reward is not None:
            rewards = {
                "reward": reward,
                "sorry_free": reward,
                "spec_intact": 1.0,
                "forbidden_free": 1.0,
                "compiled": reward,
                "axioms_ok": reward,
            }
        result = {
            "id": f"id-{trial_name}",
            "task_name": f"codeprover/{task_name}",
            "trial_name": trial_name,
            "task_id": {"path": f"tasks/fixture/{task_name}"},
            "source": "fixture",
            "task_checksum": f"checksum-{task_name}",
            "config": {
                "task": {"path": f"tasks/fixture/{task_name}", "source": "fixture"},
                "trial_name": trial_name,
                "agent": AGENT,
                "job_id": "job-id",
            },
            "agent_info": {
                "name": "fixture-agent",
                "version": "1.0",
                "model_info": {"name": "fixture-model", "provider": "fixture"},
            },
            "agent_result": {
                "n_input_tokens": input_tokens,
                "n_cache_tokens": cache_tokens,
                "n_output_tokens": output_tokens,
                "cost_usd": None,
                "metadata": {"protocol": "fixture-v1"},
            },
            "verifier_result": {"rewards": rewards} if rewards is not None else None,
            "exception_info": exception,
            "started_at": f"2026-07-21T00:0{index}:00Z",
            "finished_at": f"2026-07-21T00:0{index}:10Z",
            "environment_setup": None,
            "agent_setup": None,
            "agent_execution": None,
            "verifier": None,
            "step_results": None,
        }
        self._write_json(trial_dir / "result.json", result)
        self._write_json(
            trial_dir / "config.json",
            {
                "task": result["config"]["task"],
                "trial_name": trial_name,
                "job_id": "job-id",
            },
        )
        self._write_json(
            trial_dir / "lock.json",
            {
                "schema_version": 1,
                "task": {
                    "name": task_name,
                    "type": "local",
                    "digest": f"sha256:lock-{task_name}",
                    "source": "fixture",
                    "path": f"tasks/fixture/{task_name}",
                },
                "agent": AGENT,
            },
        )
        if rewards is not None:
            raw = dict(rewards)
            if raw_reward is not None:
                raw["reward"] = raw_reward
            self._write_json(trial_dir / "verifier" / "reward.json", raw)
            self._write_json(
                trial_dir / "verifier" / "grade_details.json", {"fixture": True}
            )
        return trial_dir

    def finish(self, completed: int) -> None:
        plan = json.loads((self.job / "lock.json").read_text())
        self._write_job_result(
            total=len(plan["trials"]), completed=completed, pending=0
        )


class HarborResultsTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.source_state = {
            "commit": "a" * 40,
            "dirty": False,
            "root": str(self.root / "repo"),
        }

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def _summarize(self, fixture: HarborFixture):
        with patch.object(
            harbor_results, "_source_git_state", return_value=self.source_state
        ):
            return harbor_results.summarize(
                fixture.job, fixture.tasks_root, fixture.out
            )

    def test_complete_observed_pass_at_two_and_usage(self) -> None:
        fixture = HarborFixture(self.root, tasks=("alpha", "beta"), k=2)
        fixture.add_trial(
            "alpha", 1, reward=1.0, input_tokens=100, cache_tokens=20, output_tokens=10
        )
        fixture.add_trial(
            "alpha", 2, reward=0.0, input_tokens=200, cache_tokens=50, output_tokens=20
        )
        fixture.add_trial("beta", 1, reward=0.0)
        fixture.add_trial("beta", 2, reward=0.0)
        fixture.finish(completed=4)

        summary, exit_code = self._summarize(fixture)

        self.assertEqual(exit_code, 0)
        self.assertTrue(summary["complete"])
        self.assertEqual(len(summary["arms"]), 1)
        arm = summary["arms"][0]
        self.assertEqual(arm["k"], 2)
        self.assertEqual(arm["pass_at_k"], 0.5)
        self.assertEqual(arm["provisional_pass_at_k_lower_bound"], 0.5)
        self.assertEqual(
            arm["distributions"]["input_tokens_excluding_cache"]["p50"],
            80.0,
        )
        self.assertEqual(harbor_results.verify(fixture.out / "summary.json"), [])

    def test_non_attempt_and_missing_keep_official_metric_null(self) -> None:
        fixture = HarborFixture(self.root, tasks=("alpha",), k=2)
        fixture.add_trial("alpha", 1, reward=1.0)

        summary, exit_code = self._summarize(fixture)

        self.assertEqual(exit_code, 2)
        arm = summary["arms"][0]
        self.assertFalse(arm["complete"])
        self.assertIsNone(arm["pass_at_k"])
        self.assertEqual(arm["provisional_pass_at_k_lower_bound"], 1.0)
        problem = arm["problems"][0]
        self.assertEqual(
            problem["attempt_states"],
            {"alpha__1": "verified_solved", "missing:fixture/alpha:1": "missing"},
        )

    def test_raw_and_embedded_reward_mismatch_fails_closed(self) -> None:
        fixture = HarborFixture(self.root, tasks=("alpha",), k=1)
        fixture.add_trial("alpha", 1, reward=1.0, raw_reward=0.0)
        fixture.finish(completed=1)

        summary, exit_code = self._summarize(fixture)

        self.assertEqual(exit_code, 2)
        self.assertFalse(summary["complete"])
        self.assertIsNone(summary["arms"][0]["pass_at_k"])
        issues = (fixture.out / "issues.jsonl").read_text()
        self.assertIn("embedded_raw_reward_mismatch", issues)

    def test_unknown_harbor_persistence_schema_fails_closed(self) -> None:
        fixture = HarborFixture(self.root, tasks=("alpha",), k=1)
        fixture.add_trial("alpha", 1, reward=1.0)
        fixture.finish(completed=1)
        lock_path = fixture.job / "lock.json"
        lock = json.loads(lock_path.read_text())
        lock["harbor"]["version"] = "99.0.0"
        fixture._write_json(lock_path, lock)

        summary, exit_code = self._summarize(fixture)

        self.assertEqual(exit_code, 2)
        self.assertFalse(summary["complete"])
        self.assertIn(
            "unsupported_harbor_version", (fixture.out / "issues.jsonl").read_text()
        )

    def test_verify_detects_input_tamper(self) -> None:
        fixture = HarborFixture(self.root, tasks=("alpha",), k=1)
        trial = fixture.add_trial("alpha", 1, reward=1.0)
        fixture.finish(completed=1)
        summary, exit_code = self._summarize(fixture)
        self.assertEqual(exit_code, 0)
        self.assertTrue(summary["complete"])

        reward_path = trial / "verifier" / "reward.json"
        payload = json.loads(reward_path.read_text())
        payload["reward"] = 0.0
        reward_path.write_text(json.dumps(payload), encoding="utf-8")

        errors = harbor_results.verify(fixture.out / "summary.json")
        self.assertTrue(any("input changed" in error for error in errors))

    def test_grader_error_and_incomplete_reward_contract_are_non_attempts(self) -> None:
        grader_error = {"reward": 0.0, "grader_error": 1.0}
        self.assertEqual(
            harbor_results._classify_rewards(grader_error, grader_error, None, None)[
                :2
            ],
            ("infra_error", "non_attempt"),
        )
        incomplete = {"reward": 0.0}
        self.assertEqual(
            harbor_results._classify_rewards(incomplete, incomplete, None, None)[:2],
            ("inconsistent", "non_attempt"),
        )

    def test_paired_outcomes_require_same_task_spec_identity(self) -> None:
        def arm(arm_id: str, passed: dict[str, bool]) -> dict:
            return {
                "arm_id": arm_id,
                "identity": {"source": "fixture"},
                "complete": True,
                "pass_at_k": sum(passed.values()) / len(passed),
                "problems": [
                    {"task_key": task_key, "strict_pass_at_k": value}
                    for task_key, value in sorted(passed.items())
                ],
            }

        left = arm("left", {"fixture/a": True, "fixture/b": False})
        right = arm("right", {"fixture/a": True, "fixture/b": True})
        rows = {
            "left": [
                {"task": {"key": "fixture/a", "spec_sha256": "a"}},
                {"task": {"key": "fixture/b", "spec_sha256": "b"}},
            ],
            "right": [
                {"task": {"key": "fixture/a", "spec_sha256": "a"}},
                {"task": {"key": "fixture/b", "spec_sha256": "b"}},
            ],
        }

        comparison = harbor_results._paired([left, right], rows)[0]
        self.assertTrue(comparison["complete"])
        self.assertEqual(
            comparison["outcomes"],
            {"both": 1, "left_only": 0, "right_only": 1, "neither": 0},
        )
        self.assertEqual(comparison["pass_at_k_delta_right_minus_left"], 0.5)

        rows["right"][1]["task"]["spec_sha256"] = "changed"
        comparison = harbor_results._paired([left, right], rows)[0]
        self.assertFalse(comparison["comparable"])
        self.assertIsNone(comparison["pass_at_k_delta_right_minus_left"])

    def test_source_attestation_ignores_foreign_cwd(self) -> None:
        source_repo = self.root / "source"
        source_repo.mkdir()
        module = source_repo / "tool.py"
        module.write_text("value = 1\n", encoding="utf-8")
        subprocess.run(["git", "init", "-q"], cwd=source_repo, check=True)
        subprocess.run(["git", "add", "tool.py"], cwd=source_repo, check=True)
        subprocess.run(
            [
                "git",
                "-c",
                "user.email=test@example.com",
                "-c",
                "user.name=test",
                "commit",
                "-qm",
                "fixture",
            ],
            cwd=source_repo,
            check=True,
        )
        expected = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=source_repo,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        foreign = self.root / "foreign"
        foreign.mkdir()
        old_cwd = Path.cwd()
        try:
            os.chdir(foreign)
            state = harbor_results._source_git_state(module)
        finally:
            os.chdir(old_cwd)
        self.assertEqual(state["commit"], expected)
        self.assertEqual(state["root"], str(source_repo))


if __name__ == "__main__":
    unittest.main()
