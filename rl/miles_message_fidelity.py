"""Dependency-free message identity helpers for the V3/Miles adapter."""

from __future__ import annotations

import copy
from typing import Any


def restore_miles_assistant_messages(
    wire: dict[str, Any],
    raw_assistant_messages: list[dict[str, Any]],
) -> dict[str, Any]:
    """Return a request whose prior assistant turns exactly match Miles."""
    restored = copy.deepcopy(wire)
    messages = restored.get("messages")
    if not isinstance(messages, list):
        raise RuntimeError("Qwen-native request omitted its messages list")

    assistant_index = 0
    for index, message in enumerate(messages):
        if not isinstance(message, dict):
            raise RuntimeError("Qwen-native request contains a non-object message")
        if message.get("role") != "assistant":
            continue
        if assistant_index >= len(raw_assistant_messages):
            raise RuntimeError(
                "Qwen-native history contains an assistant turn not returned by Miles"
            )
        messages[index] = copy.deepcopy(raw_assistant_messages[assistant_index])
        assistant_index += 1

    if assistant_index != len(raw_assistant_messages):
        raise RuntimeError(
            "Qwen-native history omitted a previously returned Miles assistant turn"
        )
    return restored
