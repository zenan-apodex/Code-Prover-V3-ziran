"""Token-level trajectory builder for RL rollouts.

RL training needs the exact token ids the policy sampled, plus a loss mask
separating model-generated tokens (train) from injected tool-result tokens
(don't train). Re-rendering the whole conversation through the chat template
each turn is NOT safe — qwen templates re-normalize `<think>` blocks, so a
re-render need not reproduce the sampled bytes. Instead we render the prompt
once and then only ever APPEND:

    prompt(template)  [gen tokens, mask 1]  [user-glue tokens, mask 0]
                      [gen tokens, mask 1]  ...

The user-glue text (`<|im_end|>` handling, `<|im_start|>user ...`, generation
prompt with forced `<think>`) is derived from the tokenizer's own template at
load time and verified by `verify_template()` — if the model's template ever
changes shape, we fail loudly instead of training on misaligned tokens.
"""

from __future__ import annotations

import dataclasses
import functools


@functools.lru_cache(maxsize=2)
def get_tokenizer(model_path: str):
    from transformers import AutoTokenizer

    return AutoTokenizer.from_pretrained(model_path, trust_remote_code=True)


@dataclasses.dataclass
class TemplateGlue:
    """Template-derived constants for append-only conversation building."""

    gen_prompt: str        # e.g. "<|im_start|>assistant\n<think>\n"
    post_assistant: str    # text after assistant's <|im_end|> token, e.g. "\n"
    user_open: str         # e.g. "<|im_start|>user\n"
    user_close: str        # e.g. "<|im_end|>\n"
    im_end_id: int

    def user_turn_text(self, content: str) -> str:
        """Glue appended after a generated turn that ended with <|im_end|>."""
        return (
            self.post_assistant + self.user_open + content
            + self.user_close + self.gen_prompt
        )


def derive_glue(tokenizer) -> TemplateGlue:
    # The follow-up user turn MUST be <tool_response>-shaped: the qwen3.6
    # template treats such turns as tool observations within the current
    # agentic cycle and PRESERVES earlier <think> blocks; a plain user turn
    # counts as a new query and STRIPS them (rewriting history, which would
    # break append-only token building). Our dialect only ever injects
    # tool_response-wrapped user turns mid-episode.
    tool_turn = "<tool_response>\nCCC\n</tool_response>"
    u1 = {"role": "user", "content": "AAA"}
    a1 = {"role": "assistant", "content": "<think>\nT\n</think>\n\nBBB"}
    u2 = {"role": "user", "content": tool_turn}

    r_u1 = tokenizer.apply_chat_template([u1], add_generation_prompt=False, tokenize=False)
    r_u1_gen = tokenizer.apply_chat_template([u1], add_generation_prompt=True, tokenize=False)
    if not r_u1_gen.startswith(r_u1):
        raise RuntimeError("chat template: generation prompt is not a pure suffix")
    gen_prompt = r_u1_gen[len(r_u1):]

    r_a = tokenizer.apply_chat_template([u1, a1], add_generation_prompt=False, tokenize=False)
    r_full = tokenizer.apply_chat_template([u1, a1, u2], add_generation_prompt=True, tokenize=False)
    if not r_full.startswith(r_a):
        raise RuntimeError("chat template: appending a tool_response user turn rewrites history")
    between = r_full[len(r_a):]
    if tool_turn not in between:
        raise RuntimeError("chat template: cannot locate user turn in rendered suffix")
    user_open, rest = between.split(tool_turn, 1)
    if not rest.endswith(gen_prompt):
        raise RuntimeError("chat template: user glue does not end with generation prompt")
    user_close = rest[: -len(gen_prompt)]

    # r_a itself must end with the assistant's <|im_end|>-plus-whitespace; the
    # part after the literal <|im_end|> token is the post_assistant glue.
    im_end = "<|im_end|>"
    idx = r_a.rstrip().rfind(im_end)
    if idx < 0:
        raise RuntimeError("chat template: assistant turn does not close with <|im_end|>")
    post_assistant = r_a[idx + len(im_end):]

    # user_open in `between` starts with post_assistant; strip it to avoid
    # double-counting (it is added by user_turn_text explicitly).
    if user_open.startswith(post_assistant):
        user_open = user_open[len(post_assistant):]

    im_end_id = tokenizer.convert_tokens_to_ids(im_end)
    if im_end_id is None or im_end_id < 0:
        raise RuntimeError("tokenizer has no <|im_end|> token")
    return TemplateGlue(gen_prompt, post_assistant, user_open, user_close, im_end_id)


def verify_template(tokenizer, glue: TemplateGlue) -> None:
    """Glue-built token stream must equal a full template render byte-for-byte
    (for canonically formatted assistant turns)."""
    u1 = {"role": "user", "content": "solve it"}
    # The generation prompt already ends with "<think>\n", so the model's
    # sampled bytes start with the think BODY (no opening tag):
    generated = "plan\n</think>\n\ncalling tool"
    a_text = "<think>\n" + generated  # what the full turn looks like re-rendered
    u2 = {"role": "user", "content": "<tool_response>\nok\n</tool_response>"}

    full = tokenizer.apply_chat_template([u1, {"role": "assistant", "content": a_text}, u2],
                                         add_generation_prompt=True, tokenize=False)
    built = (
        tokenizer.apply_chat_template([u1], add_generation_prompt=True, tokenize=False)
        + generated + "<|im_end|>"
        + glue.user_turn_text(u2["content"])
    )
    if built != full:
        raise RuntimeError(
            "chat-template glue verification FAILED — refusing to build RL "
            f"trajectories.\n--- glue-built ---\n{built[-400:]}\n--- template ---\n{full[-400:]}"
        )


class TokenStream:
    """Append-only (tokens, loss_mask, logprobs) triple for one episode."""

    def __init__(self, model_path: str):
        self.tokenizer = get_tokenizer(model_path)
        self.glue = derive_glue(self.tokenizer)
        verify_template(self.tokenizer, self.glue)
        self.tokens: list[int] = []
        self.loss_mask: list[int] = []       # response tokens only
        self.logprobs: list[float] = []      # response tokens only
        self.prompt_len: int = 0

    def start(self, instruction: str) -> list[int]:
        text = self.tokenizer.apply_chat_template(
            [{"role": "user", "content": instruction}],
            add_generation_prompt=True, tokenize=False,
        )
        self.tokens = self.tokenizer(text, add_special_tokens=False)["input_ids"]
        self.prompt_len = len(self.tokens)
        return self.tokens

    @property
    def response_length(self) -> int:
        return len(self.tokens) - self.prompt_len

    def append_generated(self, token_ids: list[int], token_logprobs: list[float]) -> None:
        assert len(token_ids) == len(token_logprobs)
        self.tokens += token_ids
        self.loss_mask += [1] * len(token_ids)
        self.logprobs += token_logprobs

    def append_user_turn(self, content: str) -> None:
        """Append tool results / nudges as a user turn (not trained on).

        Only valid when the last generated token is <|im_end|> (finish stop).
        `content` MUST be <tool_response>-wrapped — a plain user turn would be
        a new query under the qwen3.6 template (stripping earlier thinks) and
        would diverge from this append-only token stream.
        """
        assert self.tokens and self.tokens[-1] == self.glue.im_end_id, (
            "append_user_turn requires the previous turn to end with <|im_end|>"
        )
        assert content.lstrip().startswith("<tool_response>"), (
            "mid-episode user turns must be <tool_response>-wrapped"
        )
        ids = self.tokenizer(self.glue.user_turn_text(content),
                             add_special_tokens=False)["input_ids"]
        self.tokens += ids
        self.loss_mask += [0] * len(ids)
        self.logprobs += [0.0] * len(ids)

    def validate(self) -> None:
        rl = self.response_length
        assert len(self.loss_mask) == rl, (len(self.loss_mask), rl)
        assert len(self.logprobs) == rl, (len(self.logprobs), rl)
