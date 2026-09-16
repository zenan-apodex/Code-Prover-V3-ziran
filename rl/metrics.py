"""Streaming episode metrics shared by training and fixed-set evaluation."""

from __future__ import annotations

from collections import Counter


class EpisodeMetrics:
    def __init__(self):
        self.counts = Counter()
        self.tokens = Counter()
        self.reasons = Counter()
        self.reason_passes = Counter()

    def add_group(self, group):
        if not group:
            return
        successes = 0
        for sample in group:
            meta = getattr(sample, "metadata", None) or {}
            failed = getattr(sample.status, "name", str(sample.status)) in {"FAILED", "ABORTED"}
            passed = not failed and sample.reward is not None and float(sample.reward) > 0
            successes += passed
            self.counts["samples"] += 1
            self.counts["passes"] += passed
            self.counts["infra_failures"] += failed
            self.counts["truncated"] += getattr(sample.status, "name", "") == "TRUNCATED"
            reason = "infrastructure_failure" if failed else meta.get("stop_detail", "unknown")
            self.reasons[reason] += 1
            self.reason_passes[reason] += passed
            token_keys = ("prompt_tokens", "model_generated_tokens", "tool_and_feedback_tokens", "synthetic_tokens")
            if all(key in meta for key in token_keys):
                self.counts["token_accounted_samples"] += 1
                for key in token_keys:
                    self.tokens[key] += meta[key]
            self.counts["sandbox_acquire_seconds"] += meta.get("sandbox_acquire_time_sec", 0)
            self.counts["sandbox_pool_hits"] += bool(meta.get("sandbox_pool_hit", False))
            self.counts["wall_seconds"] += meta.get("episode_wall_time_sec", 0)
            self.counts["tool_calls"] += meta.get("tool_calls", 0)
            self.counts["length_limited_turns"] += meta.get("length_limited_turns", 0)
            self.counts["turns"] += meta.get("n_turns", 0)
        self.counts["groups"] += 1
        self.counts["all_zero_groups"] += successes == 0
        self.counts["all_one_groups"] += successes == len(group)
        self.counts["mixed_groups"] += 0 < successes < len(group)
        self.counts[f"groups_of_{len(group)}"] += 1
        self.counts[f"passing_groups_of_{len(group)}"] += successes > 0
        if len(group) >= 2:
            n, failures = len(group), len(group) - successes
            # Average over all pairs, so full evaluation is comparable to two trials.
            self.counts["pass_at_2_sum"] += 1 - failures * (failures - 1) / (n * (n - 1))
            self.counts["pass_at_2_groups"] += 1

    def summarize(self, prefix):
        n, g = self.counts["samples"], self.counts["groups"]
        result = {"samples": n, "groups": g}
        if not n:
            return {f"{prefix}/{key}": value for key, value in result.items()}
        result.update({
            "pass@1": self.counts["passes"] / n,
            "truncated_ratio": self.counts["truncated"] / n,
            "infra_failure_ratio": self.counts["infra_failures"] / n,
            "token_accounting_coverage": self.counts["token_accounted_samples"] / n,
            "all_zero_group_ratio": self.counts["all_zero_groups"] / g,
            "all_one_group_ratio": self.counts["all_one_groups"] / g,
            "mixed_group_ratio": self.counts["mixed_groups"] / g,
            "episode_wall_seconds_mean": self.counts["wall_seconds"] / n,
            "sandbox_acquire_seconds_mean": self.counts["sandbox_acquire_seconds"] / n,
            "sandbox_pool_hit_ratio": self.counts["sandbox_pool_hits"] / n,
            "tool_calls_mean": self.counts["tool_calls"] / n,
            "length_limited_turn_ratio": self.counts["length_limited_turns"] / max(1, self.counts["turns"]),
        })
        for key, value in self.counts.items():
            if key.startswith("groups_of_"):
                k = key.removeprefix("groups_of_")
                result[f"pass@{k}"] = self.counts[f"passing_groups_of_{k}"] / value
        if self.counts["pass_at_2_groups"]:
            result["pass@2"] = self.counts["pass_at_2_sum"] / self.counts["pass_at_2_groups"]
        total = sum(self.tokens.values())
        for key, value in self.tokens.items():
            result[f"{key}_mean"] = value / max(1, self.counts["token_accounted_samples"])
            result[f"{key}_fraction"] = value / max(1, total)
        for reason, count in self.reasons.items():
            result[f"stop/{reason}/count"] = count
            result[f"stop/{reason}/fraction"] = count / n
            result[f"stop/{reason}/pass_rate"] = self.reason_passes[reason] / count
        return {f"{prefix}/{key}": value for key, value in result.items()}
