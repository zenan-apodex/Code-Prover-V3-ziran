import Mathlib

open scoped Nat
open scoped Real

/--
If $f(x) = \dfrac{1}{x + 2},$ what is $f(f(1))$?
-/
theorem mathd_algebra_270 (f : ℝ → ℝ) (h₀ : ∀ x ≠ -2, f x = 1 / (x + 2)) :
    f (f 1) = 3 / 7 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
