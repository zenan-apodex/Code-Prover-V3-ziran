import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What positive two-digit integer is exactly twice the sum of its digits? -/
theorem mathd_numbertheory_284 (a b : ℕ) (h₀ : 1 ≤ a ∧ a ≤ 9 ∧ b ≤ 9)
    (h₁ : 10 * a + b = 2 * (a + b)) : 10 * a + b = (18) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
