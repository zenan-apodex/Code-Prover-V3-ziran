import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show any $n$ non-negative real numbers with product equal to $1$ must have sum at least $n$. -/
theorem algebra_amgm_prod1toneq1_sum1tongeqn (a : ℕ → NNReal) (n : ℕ)
    (h₀ : ∏ i ∈ Finset.range n, a i = 1) : ∑ i ∈ Finset.range n, a i ≥ n := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
