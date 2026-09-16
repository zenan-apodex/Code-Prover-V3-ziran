"""Campaign-specific dynamic-sampling filters for Code-Prover RL."""

from miles.rollout.filter_hub.dynamic_sampling_filters import (
    check_no_aborted,
    check_reward_nonzero_std,
)


def check_clean_and_nonzero_std(args, samples, **kwargs):
    """Drop infrastructure-aborted and homogeneous-reward groups."""
    result = check_no_aborted(args, samples, **kwargs)
    if not result.keep:
        return result
    return check_reward_nonzero_std(args, samples, **kwargs)
