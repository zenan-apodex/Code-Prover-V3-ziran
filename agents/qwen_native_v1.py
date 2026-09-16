"""Exact user/assistant wire codec used by the union-v1 Qwen SFT.

The training corpus contains no system role, OpenAI tool role, structured
``tool_calls`` field, or tool schema.  This module is intentionally independent
of the agent runtime so the same transformation can be used by inference and
dataset export without the two implementations drifting.
"""

from __future__ import annotations

import hashlib
import json
import re
from collections.abc import Iterable, Mapping, Sequence
from dataclasses import dataclass
from typing import Any

QWEN_NATIVE_V1 = "qwen-native-v1"

_DROPPED_REQUEST_FIELDS = frozenset(
    {
        "tools",
        "tool_choice",
        "parallel_tool_calls",
        "cache_control",
        "prompt_cache_key",
    }
)

_TOOL_CALL_RE = re.compile(
    r"<tool_call>\s*(.*?)\s*</tool_call>",
    flags=re.DOTALL,
)
_OPEN_TOOL_CALL_RE = re.compile(r"<tool_call>", flags=re.IGNORECASE)
_CLOSE_TOOL_CALL_RE = re.compile(r"</tool_call>", flags=re.IGNORECASE)
_THINK_RE = re.compile(r"<think>.*?</think>", flags=re.DOTALL)
_QWEN_FUNCTION_RE = re.compile(
    r"^\s*<function=([A-Za-z_][A-Za-z0-9_.:-]*)>\s*(.*?)\s*</function>\s*$",
    flags=re.DOTALL,
)
_QWEN_PARAMETER_RE = re.compile(
    r"<parameter=([A-Za-z_][A-Za-z0-9_.:-]*)>\s*(.*?)\s*</parameter>",
    flags=re.DOTALL,
)


class ProtocolEncodingError(ValueError):
    """Raised when logical history cannot be represented by this protocol."""


@dataclass(frozen=True)
class ProtocolError:
    """Auditable assistant-response protocol violation."""

    code: str
    message: str
    tool_name: str | None = None
    raw: str | None = None

    def as_dict(self) -> dict[str, str]:
        payload = {"protocol": QWEN_NATIVE_V1, "code": self.code, "message": self.message}
        if self.tool_name:
            payload["tool_name"] = self.tool_name
        if self.raw:
            payload["raw"] = self.raw[:500]
        return payload


@dataclass(frozen=True)
class DecodedToolCall:
    """Provider-neutral tool call recovered from a native assistant turn."""

    name: str
    arguments: dict[str, Any]
    call_id: str


@dataclass(frozen=True)
class DecodedAssistant:
    """Decoded assistant content, calls, and non-fatal protocol errors."""

    content: str
    tool_calls: tuple[DecodedToolCall, ...]
    errors: tuple[ProtocolError, ...]


def _field(value: object, name: str, default: Any = None) -> Any:
    if isinstance(value, Mapping):
        return value.get(name, default)
    return getattr(value, name, default)


def stringify_content(content: Any) -> str:
    """Return the textual payload of a chat message without extension fields."""
    if isinstance(content, str):
        return content
    if content is None:
        return ""
    if isinstance(content, Sequence) and not isinstance(content, (bytes, bytearray)):
        parts: list[str] = []
        for block in content:
            if isinstance(block, Mapping):
                block_type = block.get("type")
                if block_type not in {None, "text", "input_text", "output_text"}:
                    raise ProtocolEncodingError(
                        f"unsupported content block type for {QWEN_NATIVE_V1}: {block_type!r}"
                    )
                text = block.get("text", block.get("content", ""))
                if not isinstance(text, str):
                    raise ProtocolEncodingError("text content block must contain a string")
                parts.append(text)
            else:
                raise ProtocolEncodingError(
                    f"unsupported content block for {QWEN_NATIVE_V1}: {type(block).__name__}"
                )
        return "".join(parts)
    raise ProtocolEncodingError(
        f"message content must be string/list/null, got {type(content).__name__}"
    )


def _arguments_object(arguments: Any, *, context: str) -> dict[str, Any]:
    if arguments is None or arguments == "":
        return {}
    if isinstance(arguments, str):
        try:
            arguments = json.loads(arguments)
        except json.JSONDecodeError as exc:
            raise ProtocolEncodingError(
                f"{context} arguments are not valid JSON: {exc.msg}"
            ) from exc
    if not isinstance(arguments, Mapping):
        raise ProtocolEncodingError(f"{context} arguments must be a JSON object")
    return dict(arguments)


def _encoded_tool_call(tool_call: object) -> str:
    function = _field(tool_call, "function", {})
    name = _field(function, "name", "")
    if not isinstance(name, str) or not name.strip():
        raise ProtocolEncodingError("structured tool call is missing function.name")
    arguments = _arguments_object(
        _field(function, "arguments", {}),
        context=f"tool {name!r}",
    )
    # Intentionally no call ID: union-v1 never trained on one in assistant text.
    payload = json.dumps(
        {"name": name, "arguments": arguments},
        ensure_ascii=False,
    )
    return f"<tool_call>\n{payload}\n</tool_call>"


def encode_messages(messages: Iterable[object]) -> list[dict[str, str]]:
    """Convert logical OpenAI chat history to the union-v1 wire contract.

    ``system`` messages are deliberately discarded, consecutive tool results
    are merged into one user turn, and assistant calls are rendered as native
    tags.  Any other role or malformed structured call is rejected explicitly.
    """
    output: list[dict[str, str]] = []
    pending_tool_results: list[str] = []

    def flush_tool_results() -> None:
        if not pending_tool_results:
            return
        content = "\n".join(
            f"<tool_response>\n{result}\n</tool_response>" for result in pending_tool_results
        )
        output.append({"role": "user", "content": content})
        pending_tool_results.clear()

    for index, message in enumerate(messages):
        if not isinstance(message, Mapping):
            raise ProtocolEncodingError(f"message {index} must be a mapping")
        role = message.get("role")
        if role == "system":
            # Exact training behavior: the exporter dropped system turns; it did
            # not leak their bytes into the first user message.
            continue
        if role == "tool":
            pending_tool_results.append(stringify_content(message.get("content")))
            continue

        flush_tool_results()
        if role == "user":
            output.append({"role": "user", "content": stringify_content(message.get("content"))})
            continue
        if role != "assistant":
            raise ProtocolEncodingError(
                f"message {index} has unsupported role {role!r}; "
                "only user/assistant/tool/system are accepted"
            )

        content = stringify_content(message.get("content"))
        reasoning = message.get("reasoning_content", message.get("reasoning"))
        content = inline_reasoning(content, reasoning)
        parts = [content] if content else []
        for tool_call in message.get("tool_calls") or ():
            parts.append(_encoded_tool_call(tool_call))
        output.append({"role": "assistant", "content": "\n".join(parts)})

    flush_tool_results()
    return output


def encode_request(api_kwargs: Mapping[str, Any]) -> dict[str, Any]:
    """Return the exact native chat-completions request sent to the provider."""
    request = {
        key: value for key, value in api_kwargs.items() if key not in _DROPPED_REQUEST_FIELDS
    }
    messages = request.get("messages")
    if messages is not None:
        if not isinstance(messages, Sequence) or isinstance(messages, (str, bytes, bytearray)):
            raise ProtocolEncodingError("request messages must be a sequence")
        request["messages"] = encode_messages(messages)
    return request


def encode_request_native(
    api_kwargs: Mapping[str, Any], tools_schema: Sequence[Mapping[str, Any]]
) -> dict[str, Any]:
    """OpenAI function-calling wire form for models whose serving stack owns
    the tool grammar (kimi-k3: tool calls ride dedicated special tokens, and
    without a ``tools`` parameter the server drops them and truncates —
    2026-07-25). History stays structured; ``<think>`` blocks are stripped
    from replayed assistant turns (reasoning is never re-sent); the logical
    transcript kept by the agent remains identical to the text protocol's.
    """
    request = {
        key: value for key, value in api_kwargs.items() if key not in _DROPPED_REQUEST_FIELDS
    }
    wire: list[dict[str, Any]] = []
    for index, message in enumerate(request.get("messages") or ()):
        if not isinstance(message, Mapping):
            raise ProtocolEncodingError(f"message {index} must be a mapping")
        role = message.get("role")
        if role == "system":
            continue
        if role == "tool":
            wire.append({
                "role": "tool",
                "tool_call_id": str(message.get("tool_call_id") or f"call_{index}"),
                "content": stringify_content(message.get("content")),
            })
            continue
        if role == "user":
            wire.append({"role": "user", "content": stringify_content(message.get("content"))})
            continue
        if role != "assistant":
            raise ProtocolEncodingError(
                f"message {index} has unsupported role {role!r}"
            )
        content = _THINK_RE.sub("", stringify_content(message.get("content"))).strip()
        if not content:
            # moonshot rejects assistant turns with empty content ("must not
            # be empty", 2026-07-25) — an all-<think> turn cut off by
            # max_tokens strips to nothing. Keep a factual placeholder.
            content = "(reasoning elided; no tool call was issued)"
        out: dict[str, Any] = {"role": "assistant", "content": content}
        calls = []
        for ci, tool_call in enumerate(message.get("tool_calls") or ()):
            function = _field(tool_call, "function", {})
            name = _field(function, "name", "")
            if not isinstance(name, str) or not name.strip():
                raise ProtocolEncodingError("structured tool call is missing function.name")
            arguments = _field(function, "arguments", "{}")
            if not isinstance(arguments, str):
                arguments = json.dumps(arguments, ensure_ascii=False)
            calls.append({
                "id": str(_field(tool_call, "id") or f"call_{index}_{ci}"),
                "type": "function",
                "function": {"name": name, "arguments": arguments},
            })
        if calls:
            out["tool_calls"] = calls
        wire.append(out)
    request["messages"] = wire
    request["tools"] = list(tools_schema)
    return request


def wire_payload_sha256(api_kwargs: Mapping[str, Any]) -> str:
    """Hash an already encoded provider request using canonical JSON."""

    def json_default(value: Any) -> Any:
        if hasattr(value, "model_dump"):
            return value.model_dump(mode="json")
        if hasattr(value, "dict"):
            return value.dict()
        return str(value)

    canonical = json.dumps(
        api_kwargs,
        ensure_ascii=False,
        sort_keys=True,
        separators=(",", ":"),
        default=json_default,
    )
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def inline_reasoning(content: str, reasoning_content: Any) -> str:
    """Restore parser-split reasoning exactly once."""
    if not reasoning_content or not isinstance(reasoning_content, str):
        return content
    if _THINK_RE.search(content):
        return content
    prefix = f"<think>\n{reasoning_content}\n</think>"
    return f"{prefix}\n\n{content}" if content else prefix


def _deterministic_call_id(
    name: str,
    arguments: Mapping[str, Any],
    index: int,
    *,
    call_id_namespace: str | None = None,
) -> str:
    identity: dict[str, Any] = {
        "name": name,
        "arguments": dict(arguments),
        "index": index,
    }
    if call_id_namespace is not None:
        identity["namespace"] = call_id_namespace
    canonical = json.dumps(
        identity,
        sort_keys=True,
        ensure_ascii=False,
        separators=(",", ":"),
    )
    digest = hashlib.sha256(canonical.encode("utf-8")).hexdigest()[:24]
    return f"call_qwen_{digest}"


def _decoded_call(
    payload: object,
    *,
    index: int,
    allowed_tool_names: frozenset[str] | None,
    raw: str | None = None,
    call_id_namespace: str | None = None,
) -> tuple[DecodedToolCall | None, ProtocolError | None]:
    if not isinstance(payload, Mapping):
        return None, ProtocolError(
            code="tool_call_not_object",
            message="tool_call payload must be a JSON object",
            raw=raw,
        )
    name = payload.get("name")
    if not isinstance(name, str) or not name.strip():
        return None, ProtocolError(
            code="missing_tool_name",
            message="tool_call payload is missing a non-empty name",
            raw=raw,
        )
    try:
        arguments = _arguments_object(payload.get("arguments", {}), context=f"tool {name!r}")
    except ProtocolEncodingError as exc:
        return None, ProtocolError(
            code="invalid_tool_arguments",
            message=str(exc),
            tool_name=name,
            raw=raw,
        )
    if allowed_tool_names is not None and name not in allowed_tool_names:
        return None, ProtocolError(
            code="unknown_tool",
            message=f"model requested tool {name!r}, which is not in the active profile surface",
            tool_name=name,
            raw=raw,
        )
    return (
        DecodedToolCall(
            name=name,
            arguments=arguments,
            call_id=_deterministic_call_id(
                name,
                arguments,
                index,
                call_id_namespace=call_id_namespace,
            ),
        ),
        None,
    )


def _structured_payload(tool_call: object) -> dict[str, Any]:
    function = _field(tool_call, "function", {})
    return {
        "name": _field(function, "name", ""),
        "arguments": _field(function, "arguments", {}),
    }


def _qwen_function_payload(raw: str) -> tuple[dict[str, Any] | None, ProtocolError | None]:
    """Decode the native Qwen3.5 function/parameter XML inside a tool tag.

    This is an opt-in compatibility path for checkpoints that retained the
    Hugging Face Qwen function-call dialect. The union-v1 JSON contract stays
    strict by default.
    """
    match = _QWEN_FUNCTION_RE.fullmatch(raw)
    if match is None:
        return None, ProtocolError(
            code="malformed_qwen_function_xml",
            message="tool_call is neither union-v1 JSON nor valid Qwen function XML",
            raw=raw,
        )

    name, body = match.groups()
    parameters = list(_QWEN_PARAMETER_RE.finditer(body))
    if _QWEN_PARAMETER_RE.sub("", body).strip():
        return None, ProtocolError(
            code="malformed_qwen_function_xml",
            message="Qwen function body contains text outside parameter tags",
            tool_name=name,
            raw=raw,
        )

    arguments: dict[str, Any] = {}
    for parameter in parameters:
        parameter_name, value_text = parameter.groups()
        if parameter_name in arguments:
            return None, ProtocolError(
                code="duplicate_tool_parameter",
                message=f"Qwen function repeats parameter {parameter_name!r}",
                tool_name=name,
                raw=raw,
            )
        value_text = value_text.strip()
        try:
            value = json.loads(value_text)
        except json.JSONDecodeError:
            value = value_text
        arguments[parameter_name] = value
    return {"name": name, "arguments": arguments}, None


def decode_assistant(
    *,
    content: Any,
    reasoning_content: Any = None,
    structured_tool_calls: Iterable[object] | None = None,
    allowed_tool_names: Iterable[str] | None = None,
    call_id_namespace: str | None = None,
    accept_qwen_function_xml: bool = False,
) -> DecodedAssistant:
    """Decode an SGLang structured response or raw native-tag fallback.

    Invalid and unknown calls are returned as explicit errors.  Callers can
    turn them into a guarded recovery tool result; they must never be silently
    ignored.
    """
    text = inline_reasoning(stringify_content(content), reasoning_content)
    allowed = frozenset(allowed_tool_names) if allowed_tool_names is not None else None
    calls: list[DecodedToolCall] = []
    errors: list[ProtocolError] = []

    structured = list(structured_tool_calls or ())
    if structured:
        # Some servers retain raw tags even after returning structured calls.
        # Prefer the structured representation and remove the duplicate tags.
        residual = _TOOL_CALL_RE.sub("", text).strip()
        for index, tool_call in enumerate(structured):
            decoded, error = _decoded_call(
                _structured_payload(tool_call),
                index=index,
                allowed_tool_names=allowed,
                raw=None,
                call_id_namespace=call_id_namespace,
            )
            if decoded:
                server_id = _field(tool_call, "id")
                if call_id_namespace is None and isinstance(server_id, str) and server_id:
                    decoded = DecodedToolCall(decoded.name, decoded.arguments, server_id)
                calls.append(decoded)
            if error:
                errors.append(error)
        return DecodedAssistant(residual, tuple(calls), tuple(errors))

    open_count = len(_OPEN_TOOL_CALL_RE.findall(text))
    close_count = len(_CLOSE_TOOL_CALL_RE.findall(text))
    matches = list(_TOOL_CALL_RE.finditer(text))
    if open_count != close_count or open_count != len(matches):
        errors.append(
            ProtocolError(
                code="unbalanced_tool_call_tags",
                message=(
                    "assistant response contains unbalanced or nested <tool_call> tags "
                    f"(open={open_count}, close={close_count}, parsed={len(matches)})"
                ),
                raw=text,
            )
        )

    for index, match in enumerate(matches):
        raw_payload = match.group(1).strip()
        try:
            payload = json.loads(raw_payload)
        except json.JSONDecodeError as exc:
            if accept_qwen_function_xml:
                payload, xml_error = _qwen_function_payload(raw_payload)
                if xml_error is not None:
                    errors.append(xml_error)
                    continue
            else:
                errors.append(
                    ProtocolError(
                        code="malformed_tool_json",
                        message=f"tool_call JSON is invalid: {exc.msg}",
                        raw=raw_payload,
                    )
                )
                continue
        decoded, error = _decoded_call(
            payload,
            index=index,
            allowed_tool_names=allowed,
            raw=raw_payload,
            call_id_namespace=call_id_namespace,
        )
        if decoded:
            calls.append(decoded)
        if error:
            errors.append(error)

    residual = _TOOL_CALL_RE.sub("", text).strip()
    # Remove an unclosed tag from model-visible prose. Its bytes remain in the
    # ProtocolError.raw field and in the raw API trace when enabled.
    if open_count > close_count:
        residual = residual.split("<tool_call>", 1)[0].strip()
    return DecodedAssistant(residual, tuple(calls), tuple(errors))


def protocol_error_recovery_call(
    error: ProtocolError,
    *,
    index: int,
    call_id_namespace: str | None = None,
) -> DecodedToolCall:
    """Represent a protocol violation as the existing guarded recovery tool."""
    arguments = {
        "error": f"{QWEN_NATIVE_V1} protocol error [{error.code}]: {error.message}",
        "tool": error.tool_name or QWEN_NATIVE_V1,
        "recovery_action": "Emit a valid <tool_call> JSON object using an available tool name.",
        "recovery_hint": (
            'Use exactly {"name":"ToolName","arguments":{...}} between one '
            "<tool_call> and </tool_call> pair. Do not invent tool names."
        ),
    }
    return DecodedToolCall(
        name="tool_guard_blocked",
        arguments=arguments,
        call_id=_deterministic_call_id(
            "tool_guard_blocked",
            arguments,
            index,
            call_id_namespace=call_id_namespace,
        ),
    )
