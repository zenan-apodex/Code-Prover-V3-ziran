import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace

from rl.evaluate import summarize_results, trial_plan
from rl.make_eval_data import reserve
from rl.metrics import EpisodeMetrics
from rl.provenance import prompt_record


def sample(reward, status='COMPLETED', **metadata):
    return SimpleNamespace(reward=reward, status=SimpleNamespace(name=status), metadata=metadata)


class MetricsEvaluationTests(unittest.TestCase):
    def test_raw_metrics_retain_all_wrong_and_all_right_groups(self):
        raw, accepted = EpisodeMetrics(), EpisodeMetrics()
        groups = [[sample(0), sample(0)], [sample(1), sample(1)], [sample(0), sample(1)]]
        for group in groups:
            raw.add_group(group)
        accepted.add_group(groups[-1])
        self.assertAlmostEqual(raw.summarize('raw')['raw/pass@2'], 2/3)
        self.assertEqual(accepted.summarize('accepted')['accepted/pass@2'], 1)
        self.assertAlmostEqual(raw.summarize('raw')['raw/mixed_group_ratio'], 1/3)

    def test_truncated_success_and_failed_episode_are_separate(self):
        metrics = EpisodeMetrics()
        metrics.add_group([sample(1, 'TRUNCATED', stop_detail='token_budget'), sample(0, 'FAILED')])
        out = metrics.summarize('raw')
        self.assertEqual(out['raw/truncated_ratio'], .5)
        self.assertEqual(out['raw/infra_failure_ratio'], .5)
        self.assertEqual(out['raw/stop/token_budget/pass_rate'], 1)

    def test_token_fractions_account_for_full_context_and_old_samples(self):
        metrics = EpisodeMetrics()
        metrics.add_group([sample(0, prompt_tokens=10, model_generated_tokens=20,
                                  tool_and_feedback_tokens=9, synthetic_tokens=1), sample(1)])
        out = metrics.summarize('raw')
        self.assertEqual(out['raw/token_accounting_coverage'], .5)
        self.assertEqual(out['raw/model_generated_tokens_fraction'], .5)
        self.assertEqual(out['raw/tool_and_feedback_tokens_fraction'], 9/40)
        self.assertAlmostEqual(sum(v for k,v in out.items() if k.endswith('_tokens_fraction')), 1)

    def test_budget_arms_share_prompts_and_seeds(self):
        records = [{'metadata': {'task_name': 'a'}}, {'metadata': {'task_name': 'b'}}]
        plan = list(trial_plan(records, [2048, 4096], 8, 17))
        self.assertEqual(len(plan), 32)
        for a,b in zip(plan[::2], plan[1::2]):
            self.assertEqual(a[:3], b[:3])
            self.assertEqual(a[4], b[4])
            self.assertEqual((a[3],b[3]), (2048,4096))

    def test_incomplete_eval_group_is_not_reported_as_pass_at_eight(self):
        row = {'task_name': 'a', 'turn_budget': 2048, 'group_index': 0, 'sample_index': 0,
               'reward': 1, 'status': 'COMPLETED', 'metadata': {}, 'domain': 'math'}
        with self.assertRaises(ValueError):
            summarize_results([row], 8)

    def test_split_is_reproducible_and_excludes_content_duplicates(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            pool = []
            for domain in ['coding', 'math']:
                for i in range(7):
                    name = f'{domain}-{i}'
                    task = root / domain / 'tasks' / name
                    (task/'environment').mkdir(parents=True)
                    (task/'tests').mkdir()
                    (task/'instruction.md').write_text(name)
                    (task/'environment/task.lean').write_text(f'{domain}-{max(0,i-1)}')
                    (task/'tests/test.sh').write_text('true')
                    pool.append({'domain': domain, 'root_pool': domain, 'task_name': name, 'status': 'unsolved'})
            excluded = [prompt_record(root/'coding/tasks/coding-0')]
            validation, tuning = reserve(pool, root, excluded, count=4, tuning_count=2)
            self.assertEqual((validation,tuning), reserve(pool, root, excluded, count=4, tuning_count=2))
            names = {r['metadata']['task_name'] for r in validation+tuning}
            self.assertNotIn('coding-0', names)
            self.assertNotIn('coding-1', names)
            self.assertEqual(len(names), 6)
            self.assertEqual(len({r['metadata']['task_sha256'] for r in validation+tuning}), 6)


    def test_periodic_eval_uses_sampler_loop_and_stops_on_error(self):
        import asyncio
        import sys
        import threading
        from unittest.mock import patch
        from rl import evaluate
        loop = asyncio.new_event_loop()
        thread = threading.Thread(target=loop.run_forever, daemon=True)
        thread.start()
        worker = SimpleNamespace(event_loop=loop, paused=False, resumed=False)
        worker.pause = lambda **kw: setattr(worker, "paused", True)
        worker.resume = lambda: setattr(worker, "resumed", True)
        worker.stop = lambda: setattr(worker, "stopped", True)
        async def failed_eval(*args, **kwargs):
            self.assertIs(asyncio.get_running_loop(), loop)
            self.assertTrue(worker.paused)
            raise RuntimeError("evaluation failed")
        fake = {
            "rl.fully_async_rollout": SimpleNamespace(get_global_worker=lambda *a: worker, stop_global_worker=lambda: worker.stop()),
            "miles.rollout.base_types": SimpleNamespace(RolloutFnEvalOutput=lambda **kw: SimpleNamespace(**kw)),
        }
        args = SimpleNamespace(prover_eval_prompt_data="reserved", prover_task_root="tasks",
            prover_async_pause_timeout_sec=1, prover_sandbox_concurrency=512,
            sglang_server_concurrency=16, rollout_num_gpus=32, rollout_num_gpus_per_engine=1,
            save="/tmp", prover_max_tokens_per_turn=2048, n_samples_per_eval_prompt=8, num_rollout=30)
        try:
            with patch.dict(sys.modules, fake), patch.object(evaluate, "load_records", return_value=[{}]), \
                    patch.object(evaluate, "evaluate_records", failed_eval):
                with self.assertRaisesRegex(RuntimeError, "evaluation failed"):
                    evaluate.generate_rollout_eval(args, 9, object(), evaluation=True)
            self.assertFalse(worker.resumed)
            self.assertTrue(worker.stopped)
        finally:
            loop.call_soon_threadsafe(loop.stop)
            thread.join(timeout=2)
            loop.close()


    def test_full_eval_pass_at_two_matches_all_pairs(self):
        from itertools import combinations

        for successes in range(9):
            with self.subTest(successes=successes):
                outcomes = [1] * successes + [0] * (8 - successes)
                rows = [
                    dict(task_name="a", turn_budget=2048, sample_index=i,
                         reward=reward, status="COMPLETED", metadata={}, domain="math")
                    for i, reward in enumerate(outcomes)
                ]
                out = summarize_results(rows, 8)
                pairs = list(combinations(outcomes, 2))
                expected = sum(any(pair) for pair in pairs) / len(pairs)
                self.assertAlmostEqual(out["turn_2048/pass@1"], successes / 8)
                self.assertAlmostEqual(out["turn_2048/pass@2"], expected)
                self.assertEqual(out["turn_2048/pass@8"], int(successes > 0))
                self.assertAlmostEqual(out["turn_2048/math/pass@2"], expected)

    def test_small_eval_reports_only_supported_pass_metrics(self):
        rows = [
            dict(task_name="a", turn_budget=2048, sample_index=i,
                 reward=reward, status="COMPLETED", metadata={}, domain="coding")
            for i, reward in enumerate([0, 1])
        ]
        out = summarize_results(rows, 2)
        self.assertEqual(out["turn_2048/pass@1"], .5)
        self.assertEqual(out["turn_2048/pass@2"], 1)
        self.assertNotIn("turn_2048/pass@8", out)

    def test_pass_at_two_excludes_failed_rewards_and_averages_tasks(self):
        metrics = EpisodeMetrics()
        metrics.add_group([sample(1, "FAILED"), sample(1, "ABORTED")] + [sample(0)] * 6)
        metrics.add_group([sample(1)] + [sample(0)] * 7)
        out = metrics.summarize("eval")
        self.assertEqual(out["eval/pass@1"], 1 / 16)
        self.assertEqual(out["eval/pass@2"], .125)
        self.assertEqual(out["eval/pass@8"], .5)

    def test_periodic_and_final_eval_keep_all_tasks(self):
        import asyncio
        import sys
        import threading
        from unittest.mock import Mock, patch
        from rl import evaluate

        loop = asyncio.new_event_loop()
        thread = threading.Thread(target=loop.run_forever, daemon=True)
        thread.start()
        worker = SimpleNamespace(event_loop=loop, pause=Mock(), resume=Mock(), stop=Mock())
        records = [{"metadata": {"task_name": f"task-{i}"}} for i in range(256)]
        fake = {
            "rl.fully_async_rollout": SimpleNamespace(get_global_worker=lambda *a: worker, stop_global_worker=lambda: worker.stop()),
            "miles.rollout.base_types": SimpleNamespace(RolloutFnEvalOutput=lambda **kw: SimpleNamespace(**kw)),
        }
        args = SimpleNamespace(prover_eval_prompt_data="reserved", prover_task_root="tasks",
            prover_async_pause_timeout_sec=1, prover_sandbox_concurrency=384,
            sglang_server_concurrency=8, rollout_num_gpus=48, rollout_num_gpus_per_engine=1,
            save="/tmp", prover_max_tokens_per_turn=2048, n_samples_per_eval_prompt=2,
            prover_full_eval_samples_per_prompt=8, num_rollout=60)
        seen = []

        async def capture_eval(local_args, actual_records, *, budgets, samples_per_prompt, output):
            self.assertIs(asyncio.get_running_loop(), loop)
            self.assertIs(actual_records, records)
            plan = list(trial_plan(actual_records, budgets, samples_per_prompt, 17))
            self.assertEqual(len({p[4]["metadata"]["task_name"] for p in plan}), 256)
            seen.append((samples_per_prompt, len(plan), Path(output).name))
            return [], {"turn_2048/samples": len(plan)}

        try:
            with patch.dict(sys.modules, fake), patch.object(evaluate, "load_records", return_value=records), \
                    patch.object(evaluate, "evaluate_records", capture_eval):
                # Includes evaluation of the previous checkpoint before stage 2 resumes.
                for rollout_id in (29, 39, 49):
                    evaluate.generate_rollout_eval(args, rollout_id, object(), evaluation=True)
                self.assertEqual(worker.resume.call_count, 3)
                worker.stop.assert_not_called()
                result = evaluate.generate_rollout_eval(args, 59, object(), evaluation=True)
                self.assertEqual(worker.resume.call_count, 3)
                worker.stop.assert_called_once()
                self.assertEqual(result.metrics["eval/d3_hard/turn_2048/samples"], 2048)
                # A shorter stage still uses eight trials at its final step.
                args.num_rollout = 55
                evaluate.generate_rollout_eval(args, 54, object(), evaluation=True)
            self.assertEqual(seen, [
                (2, 512, "rollout_29.jsonl"), (2, 512, "rollout_39.jsonl"),
                (2, 512, "rollout_49.jsonl"), (8, 2048, "rollout_59.jsonl"),
                (8, 2048, "rollout_54.jsonl"),
            ])
            self.assertEqual(args.n_samples_per_eval_prompt, 2)
        finally:
            loop.call_soon_threadsafe(loop.stop)
            thread.join(timeout=2)
            loop.close()


if __name__ == '__main__':
    unittest.main()
