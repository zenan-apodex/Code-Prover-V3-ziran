"""Dynamic-sampling filter for prover RL.

miles' --dynamic-sampling-filter-path takes exactly one function, but we need
both stock checks: drop groups containing ABORTED samples (their reward is
None — infra fault, and it crashes the nonzero-std tensor build), THEN drop
groups whose binary rewards carry no signal (all-0/all-1).
"""

from miles.rollout.filter_hub.dynamic_sampling_filters import (
    check_no_aborted,
    check_reward_nonzero_std,
)


def check_clean_and_nonzero_std(args, samples, **kwargs):
    out = check_no_aborted(args, samples, **kwargs)
    if not out.keep:
        return out
    return check_reward_nonzero_std(args, samples, **kwargs)
