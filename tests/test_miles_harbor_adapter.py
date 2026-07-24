from __future__ import annotations

import asyncio
import os
import hashlib
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import AsyncMock, patch

from rl.miles_harbor_agent import (
    InfrastructureError,
    build_run_request,
    fail_on_infrastructure,
    reward_func,
    run,
)
from rl.miles_message_fidelity import restore_miles_assistant_messages
from rl.miles_qwen_session_agent import MilesSessionQwenNativeAgent
from rl.miles_harbor_server import (
    RunRequest,
    ServerSettings,
    _result_payload,
    build_agent_kwargs,
    build_environment_kwargs,
    resolve_task_dir,
    run_harbor_trial,
    verify_instruction_sha256,
)


def _settings(root: Path) -> ServerSettings:
    return ServerSettings(
        tasks_dir=root,
        trials_dir=root / "jobs",
        e2b_cluster="sg",
        e2b_template="zenan-allow-internet",
        e2b_image="registry.example/code-prover-lean:latest",
        sandbox_timeout_sec=7200,
        claim_timeout_sec=540,
        wait_ready_timeout_sec=540,
        agent_timeout_sec=5400,
        model_request_timeout_sec=1800,
        verifier_timeout_sec=1800,
        max_api_calls=64,
        context_soft_limit_tokens=100000,
        save_transcript=True,
        max_concurrent=8,
    )


class TaskPathSafetyTest(unittest.TestCase):
    def test_nested_task_inside_root_is_allowed(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "tasks"
            task = root / "dataset" / "example"
            task.mkdir(parents=True)
            self.assertEqual(resolve_task_dir(root, "dataset/example"), task.resolve())

    def test_parent_absolute_and_symlink_escapes_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "tasks"
            outside = Path(tmp) / "outside"
            root.mkdir()
            outside.mkdir()
            (root / "link").symlink_to(outside, target_is_directory=True)
            for task_name in ("../outside", str(outside), "link"):
                with self.subTest(task_name=task_name), self.assertRaises(ValueError):
                    resolve_task_dir(root, task_name)


class RequestConstructionTest(unittest.TestCase):
    def test_miles_request_uses_session_url_and_allowlists_metadata(self) -> None:
        metadata = {
            "task_name": "train/task-1",
            "max_seq_len": 32768,
            "session_server_instance_id": "router-a",
            "untrusted": "not-forwarded",
        }
        with patch.dict(
            os.environ,
            {
                "MILES_ROUTER_EXTERNAL_HOST": "miles-host",
                "CODEPROVER_MILES_MODEL_NAME": "code-prover-sft",
            },
            clear=False,
        ):
            request = build_run_request(
                base_url="http://127.0.0.1:31000/sessions/abc",
                prompt=[{"role": "user", "content": "canonical prompt\n"}],
                request_kwargs={"max_tokens": 4096, "temperature": 0.7},
                metadata=metadata,
            )
        self.assertEqual(
            request["base_url"], "http://miles-host:31000/sessions/abc/v1"
        )
        self.assertEqual(request["model"], "code-prover-sft")
        self.assertEqual(request["task_name"], "train/task-1")
        self.assertEqual(
            request["instruction_sha256"],
            hashlib.sha256(b"canonical prompt\n").hexdigest(),
        )
        self.assertNotIn("untrusted", request)

    def test_qwen_and_aliyun_kwargs_preserve_tito_contract(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            settings = _settings(Path(tmp))
            request = RunRequest(
                task_name="task",
                instruction_sha256="0" * 64,
                base_url="http://router/sessions/one/v1",
                model="code-prover-sft",
                max_seq_len=32768,
                sampling_params={
                    "max_tokens": 8192,
                    "temperature": 0.55,
                    "top_p": 0.9,
                    "messages": [{"role": "user", "content": "bad override"}],
                },
            )
            agent = build_agent_kwargs(request, settings)
            environment = build_environment_kwargs(settings)

        self.assertEqual(agent["api_base"], "http://router/sessions/one/v1")
        self.assertEqual(agent["api_key"], "$CODEPROVER_MILES_API_KEY")
        self.assertEqual(agent["max_tokens"], 8192)
        self.assertEqual(agent["temperature"], 0.55)
        self.assertEqual(agent["request_timeout"], 1800)
        self.assertEqual(agent["context_soft_limit_tokens"], 32768)
        self.assertFalse(agent["enable_compaction"])
        self.assertTrue(agent["stop_on_length"])
        self.assertEqual(agent["extra_request_fields"], {"top_p": 0.9})
        self.assertEqual(environment["aliyun_cluster"], "sg")
        self.assertEqual(environment["generic_template"], "zenan-allow-internet")
        self.assertEqual(
            environment["aliyun_image"],
            "registry.example/code-prover-lean:latest",
        )

    def test_miles_qwen_shim_restores_exact_raw_assistant(self) -> None:
        raw_assistant = {
            "role": "assistant",
            "content": None,
            "reasoning_content": "raw reasoning",
            "tool_calls": [
                {
                    "id": "upstream-call-7",
                    "type": "function",
                    "function": {"name": "Read", "arguments": "{\"file_path\":\"/task/a.lean\"}"},
                }
            ],
        }
        qwen_history = [
            {"role": "user", "content": "solve"},
            {
                "role": "assistant",
                "content": "<think>reconstructed</think>",
                "tool_calls": [
                    {
                        "id": "call0:0",
                        "type": "function",
                        "function": {"name": "Read", "arguments": "{}"},
                    }
                ],
            },
            {
                "role": "user",
                "content": "<tool_response>\nfile contents\n</tool_response>",
            },
        ]

        restored = restore_miles_assistant_messages(
            {"model": "policy", "messages": qwen_history}, [raw_assistant]
        )
        self.assertEqual(restored["messages"][1], raw_assistant)
        self.assertEqual(restored["messages"][2], qwen_history[2])
        self.assertEqual(qwen_history[1]["tool_calls"][0]["id"], "call0:0")

        with self.assertRaisesRegex(RuntimeError, "not returned by Miles"):
            restore_miles_assistant_messages(
                {"messages": qwen_history}, []
            )
        with self.assertRaisesRegex(RuntimeError, "omitted"):
            restore_miles_assistant_messages(
                {"messages": qwen_history[:1]}, [raw_assistant]
            )


class RewardAndMetadataTest(unittest.IsolatedAsyncioTestCase):
    async def test_miles_qwen_shim_stops_on_length_without_nudge(self) -> None:
        response = SimpleNamespace(
            status_code=200,
            raise_for_status=lambda: None,
            json=lambda: {
                "choices": [
                    {
                        "finish_reason": "length",
                        "message": {"role": "assistant", "content": "partial"},
                    }
                ],
                "usage": {"prompt_tokens": 3, "completion_tokens": 8},
            },
        )
        base_post = AsyncMock(return_value=response)
        context = SimpleNamespace()
        with tempfile.TemporaryDirectory() as tmp:
            agent = MilesSessionQwenNativeAgent(
                logs_dir=Path(tmp),
                model_name="policy",
            )
            with patch(
                "agents.qwen_native_agent.QwenNativeAgent._post_with_retry",
                new=base_post,
            ):
                await agent.run("solve", SimpleNamespace(), context)

            events = (Path(tmp) / "qwen-native-agent.jsonl").read_text()

        self.assertEqual(base_post.await_count, 1)
        self.assertEqual(context.metadata["stop_reason"], "truncated")
        self.assertIn('"reason": "truncated"', events)
        self.assertNotIn("truncation_nudge", events)
        self.assertEqual(len(agent._miles_raw_assistant_messages), 1)

    async def test_miles_qwen_shim_caches_only_successful_raw_assistants(self) -> None:
        raw_assistant = {
            "role": "assistant",
            "content": None,
            "reasoning_content": "raw",
            "tool_calls": [],
        }
        success = SimpleNamespace(
            status_code=200,
            json=lambda: {"choices": [{"message": raw_assistant}]},
        )
        second = SimpleNamespace(
            status_code=400,
            json=lambda: {"error": "stop"},
        )
        base_post = AsyncMock(side_effect=[success, second])
        with tempfile.TemporaryDirectory() as tmp:
            agent = MilesSessionQwenNativeAgent(
                logs_dir=Path(tmp),
                model_name="policy",
                enable_compaction=False,
            )
            with patch(
                "agents.qwen_native_agent.QwenNativeAgent._post_with_retry",
                new=base_post,
            ):
                await agent._post_with_retry(
                    object(),
                    {"messages": [{"role": "user", "content": "solve"}]},
                    lambda *_: None,
                )
                await agent._post_with_retry(
                    object(),
                    {
                        "messages": [
                            {"role": "user", "content": "solve"},
                            {"role": "assistant", "content": "reconstructed"},
                            {"role": "user", "content": "tool result"},
                        ]
                    },
                    lambda *_: None,
                )

        second_wire = base_post.await_args_list[1].args[1]
        self.assertEqual(second_wire["messages"][1], raw_assistant)
        self.assertEqual(len(agent._miles_raw_assistant_messages), 1)

    async def test_zero_reward_is_valid_but_infra_aborts_and_trips_filter(self) -> None:
        class FakeSample:
            class Status:
                PENDING = "pending"
                ABORTED = "aborted"

            def __init__(self, metadata):
                self.metadata = metadata
                self.status = self.Status.PENDING

        good = FakeSample({"reward": 0.0})
        self.assertEqual(await reward_func(None, good), 0.0)
        self.assertEqual(await reward_func(None, [good, good]), [0.0, 0.0])
        self.assertTrue(fail_on_infrastructure(None, [good]))

        bad = FakeSample(
            {"infra_error": {"type": "E2BError", "message": "claim failed"}}
        )
        self.assertEqual(await reward_func(None, bad), 0.0)
        self.assertEqual(bad.status, bad.Status.ABORTED)
        with self.assertRaisesRegex(InfrastructureError, "refusing automatic"):
            fail_on_infrastructure(None, [bad])

        missing = FakeSample({})
        self.assertEqual(await reward_func(None, missing), 0.0)
        self.assertEqual(missing.status, missing.Status.ABORTED)
        self.assertEqual(
            missing.metadata["infra_error"]["type"], "InfrastructureError"
        )

        mismatch = FakeSample(
            {
                "reward": 1.0,
                "tito_session_mismatch": [
                    {"type": "content", "detail": "rendered text drift"}
                ],
            }
        )
        with self.assertRaisesRegex(InfrastructureError, "tito_session_mismatch"):
            fail_on_infrastructure(None, [mismatch])

        truncated_thinking = FakeSample(
            {
                "reward": 0.0,
                "tito_session_mismatch": [
                    {
                        "type": "assistant_text",
                        "expected_text": "assistant\n<think>\npartial\n</think>\n\n",
                        "actual_text": "assistant\n<think>\npartial",
                    }
                ],
            }
        )
        self.assertTrue(fail_on_infrastructure(None, [truncated_thinking]))

        mixed_mismatch = FakeSample(
            {
                "reward": 0.0,
                "tito_session_mismatch": [
                    {"type": "assistant_text"},
                    {"type": "non_assistant_text"},
                ],
            }
        )
        with self.assertRaisesRegex(InfrastructureError, "non_assistant_text"):
            fail_on_infrastructure(None, [mixed_mismatch])

    async def test_client_cancellation_flushes_instance_and_reraises(self) -> None:
        post = AsyncMock(
            side_effect=[asyncio.CancelledError(), {"cancelled": 1}]
        )
        with (
            patch.dict(
                os.environ,
                {"CODEPROVER_AGENT_SERVER_URL": "http://harbor:11000"},
                clear=False,
            ),
            patch("rl.miles_harbor_agent._post_json", new=post),
            self.assertRaises(asyncio.CancelledError),
        ):
            await run(
                base_url="http://router/sessions/one",
                prompt="canonical\n",
                metadata={
                    "task_name": "smoke",
                    "session_server_instance_id": "router-instance-a",
                },
            )
        self.assertEqual(post.await_count, 2)
        self.assertEqual(
            post.await_args_list[1].args[1],
            {"session_server_instance_ids": ["router-instance-a"]},
        )

    def test_harbor_result_preserves_eval_and_marks_transport_fault(self) -> None:
        completed = SimpleNamespace(
            exception_info=None,
            verifier_result=SimpleNamespace(
                rewards={"reward": 1.0, "compiled": 1.0}
            ),
            agent_result=SimpleNamespace(
                n_input_tokens=12,
                n_output_tokens=3,
                metadata={"stop_reason": "final_answer", "api_calls": 2},
            ),
        )
        payload = _result_payload(completed, 4.5)
        self.assertEqual(payload["reward"], 1.0)
        self.assertEqual(payload["eval_report"]["compiled"], 1.0)
        self.assertEqual(payload["agent_metrics"]["api_calls"], 2)

        transport_failure = SimpleNamespace(
            exception_info=None,
            verifier_result=SimpleNamespace(rewards={"reward": 0.0}),
            agent_result=SimpleNamespace(
                n_input_tokens=0,
                n_output_tokens=0,
                metadata={"stop_reason": "request_transport_error"},
            ),
        )
        payload = _result_payload(transport_failure, 1.0)
        self.assertEqual(payload["exit_status"], "infra_error")
        self.assertIn("infra_error", payload)
        self.assertNotIn("reward", payload)


class HarborContractTest(unittest.IsolatedAsyncioTestCase):
    async def test_real_harbor_020_trial_create_contract_with_mocked_run(self) -> None:
        from harbor.trial.single_step import SingleStepTrial
        from harbor.trial.trial import Trial

        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            task = root / "tasks" / "smoke"
            task.mkdir(parents=True)
            instruction = "canonical instruction\n"
            (task / "instruction.md").write_text(instruction, encoding="utf-8")
            expected = hashlib.sha256(instruction.encode()).hexdigest()
            verify_instruction_sha256(task, expected)
            with self.assertRaisesRegex(ValueError, "does not match"):
                verify_instruction_sha256(task, "0" * 64)

            request = RunRequest(
                task_name="smoke",
                instruction_sha256=expected,
                base_url="http://router/sessions/one/v1",
                model="code-prover-sft",
            )
            fake_trial = object.__new__(SingleStepTrial)
            fake_trial.run = AsyncMock(
                return_value=SimpleNamespace(
                    exception_info=None,
                    verifier_result=SimpleNamespace(rewards={"reward": 1.0}),
                    agent_result=SimpleNamespace(
                        n_input_tokens=1,
                        n_output_tokens=1,
                        metadata={"stop_reason": "final_answer"},
                    ),
                )
            )
            with patch.object(
                Trial, "create", new=AsyncMock(return_value=fake_trial)
            ) as create:
                payload = await run_harbor_trial(request, _settings(root / "tasks"))

        self.assertEqual(payload["reward"], 1.0)
        config = create.await_args.args[0]
        self.assertEqual(
            config.agent.import_path,
            "rl.miles_qwen_session_agent:MilesSessionQwenNativeAgent",
        )
        self.assertEqual(
            config.environment.import_path,
            "tools.e2b_env:ACRE2BEnvironment",
        )


if __name__ == "__main__":
    unittest.main()
