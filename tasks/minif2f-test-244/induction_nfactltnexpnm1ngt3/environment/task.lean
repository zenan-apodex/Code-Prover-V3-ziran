import Mathlib

open scoped Nat
open scoped Real

theorem induction_nfactltnexpnm1ngt3 (n : ℕ) (h₀ : 3 ≤ n) : n ! < n ^ (n - 1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
