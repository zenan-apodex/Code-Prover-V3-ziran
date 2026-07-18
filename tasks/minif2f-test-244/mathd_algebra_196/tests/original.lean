import Mathlib

open scoped Nat
open scoped Real

/--
Find the sum of all solutions of the equation $|2-x|= 3$.
-/
theorem mathd_algebra_196 (S : Finset ℝ) (h₀ : ∀ x : ℝ, x ∈ S ↔ abs (2 - x) = 3) :
    ∑ k ∈ S, k = 4 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
