"""Miles-session fidelity shim for V3's shared Qwen-native Harbor agent.

The shared agent deliberately decodes and re-encodes assistant turns into its
training dialect.  That is correct for ordinary OpenAI-compatible endpoints,
but Miles' TITO session server requires the next request to echo the exact raw
assistant object it returned (including ``reasoning_content`` and structured
``tool_calls``).  This isolated subclass restores those raw checkpoints only
on the Miles path.  Miles remains the sole owner of token IDs, loss masks, and
rollout log probabilities.
"""

from __future__ import annotations

import copy
from typing import Any

from agents.qwen_native_agent import QwenNativeAgent
from rl.miles_message_fidelity import restore_miles_assistant_messages


class MilesSessionQwenNativeAgent(QwenNativeAgent):
    """QwenNativeAgent that preserves Miles' append-only assistant identity."""

    def __init__(
        self,
        *args: Any,
        enable_compaction: bool = False,
        stop_on_length: bool = True,
        **kwargs: Any,
    ):
        if enable_compaction:
            raise ValueError("Miles TITO does not permit Qwen history compaction")
        if not stop_on_length:
            raise ValueError("Miles TITO must stop after a length-truncated turn")
        super().__init__(
            *args,
            enable_compaction=False,
            stop_on_length=True,
            **kwargs,
        )
        self._miles_raw_assistant_messages: list[dict[str, Any]] = []

    async def _post_with_retry(self, client: Any, wire: dict[str, Any], emit: Any):
        restored_wire = restore_miles_assistant_messages(
            wire, self._miles_raw_assistant_messages
        )
        response = await super()._post_with_retry(client, restored_wire, emit)
        if response is None or response.status_code >= 300:
            return response

        try:
            assistant = response.json()["choices"][0]["message"]
        except (KeyError, IndexError, TypeError, ValueError) as exc:
            raise RuntimeError(
                "Miles policy response omitted its raw assistant message"
            ) from exc
        if not isinstance(assistant, dict):
            raise RuntimeError("Miles policy assistant message is not an object")
        self._miles_raw_assistant_messages.append(copy.deepcopy(assistant))
        return response
