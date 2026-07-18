import Mathlib

open scoped Nat
open scoped Real

/--
What is the sum of the two values of $x$ for which $(x+3)^2 = 121$?
-/
theorem mathd_algebra_215 (S : Finset ℝ) (h₀ : ∀ x : ℝ, x ∈ S ↔ (x + 3) ^ 2 = 121) :
    ∑ k ∈ S, k = -6 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
