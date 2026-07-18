import Mathlib

open scoped Nat
open scoped Real

theorem induction_pord1p1on2powklt5on2 (n : ℕ) (h₀ : 0 < n) :
    ∏ k ∈ Finset.Icc 1 n, (1 + (1 : ℝ) / 2 ^ k) < 5 / 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
