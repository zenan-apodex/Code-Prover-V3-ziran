import Mathlib

open scoped Nat
open scoped Real

/--
The expression $10x^2-x-24$ can be written as $(Ax-8)(Bx+3),$ where $A$ and $B$ are integers. What is $AB + B$?
-/
theorem mathd_algebra_276 (a b : ℤ)
    (h₀ : ∀ x : ℝ, 10 * x ^ 2 - x - 24 = (a * x - 8) * (b * x + 3)) : a * b + b = 12 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
