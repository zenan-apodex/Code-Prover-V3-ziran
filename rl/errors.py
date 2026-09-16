"""Dependency-free, credential-redacted diagnostics for RL infrastructure."""

import os


def safe_failure_detail(exc: BaseException, limit: int | None = 500) -> str:
    causes = []
    seen = set()
    current = exc
    while current is not None and id(current) not in seen:
        seen.add(id(current))
        causes.append(f"{type(current).__name__}: {current}")
        current = current.__cause__ or (
            current.__context__ if not current.__suppress_context__ else None
        )
    # Put the underlying SDK error first so the 500-character limit retains it.
    detail = " <- ".join(reversed(causes))
    secret = os.environ.get("E2B_API_KEY")
    if secret:
        detail = detail.replace(secret, "<redacted>")
    return detail if limit is None else detail[:limit]
