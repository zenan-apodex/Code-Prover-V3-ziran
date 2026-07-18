import Mathlib

open scoped Nat
open scoped Real

theorem algebra_amgm_sum1toneqn_prod1tonleq1 (a : ℕ → NNReal) (n : ℕ)
    (h₀ : ∑ x ∈ Finset.range n, a x = n) : ∏ x ∈ Finset.range n, a x ≤ 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
