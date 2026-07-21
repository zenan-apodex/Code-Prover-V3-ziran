"""Third-party (non-SFT) models on the qwen-native harness.

Thin subclass of :class:`QwenNativeAgent` for OpenAI-compatible endpoints
whose models were NOT trained on the union-v1 protocol (DeepSeek, ...).
Everything — loop, tool dispatch, spec guard, compaction, robustness — is
inherited unchanged so cross-model comparisons hold the harness constant;
the only delta is that the tool catalog + ``<tool_call>`` convention are
injected into the first user message (``tool_primer`` defaults ON here).

Usage (config):
    agents:
      - import_path: agents.thirdparty_agent:ThirdPartyAgent
        model_name: deepseek-v4-pro
        kwargs:
          api_base: https://llm-hub.apodex.app/v1
          api_key: $DPSK_API_KEY            # env reference, never a literal
          extra_headers: {"X-Llmhub-Channel": "7"}
"""

from __future__ import annotations

from pathlib import Path

from .qwen_native_agent import QwenNativeAgent


class ThirdPartyAgent(QwenNativeAgent):
    def __init__(self, logs_dir: Path, model_name: str | None = None, *args,
                 tool_primer: bool = True, **kwargs):
        super().__init__(logs_dir, model_name, *args,
                         tool_primer=tool_primer, **kwargs)

    @staticmethod
    def name() -> str:
        return "qwen-native-v1-3p"
