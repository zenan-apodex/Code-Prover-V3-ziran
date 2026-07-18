import Mathlib

open scoped Nat
open scoped Real

/--
Find $3x^2 y^2$ if $x$ and $y$ are integers such that $y^2 + 3x^2 y^2 = 30x^2 + 517$.
-/
theorem aime_1987_p5 (x y : ℤ) (h₀ : y ^ 2 + 3 * (x ^ 2 * y ^ 2) = 30 * x ^ 2 + 517) :
    3 * (x ^ 2 * y ^ 2) = 588 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
