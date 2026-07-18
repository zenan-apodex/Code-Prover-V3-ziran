import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $F(a, b, c, d) = a^b + c ^ d$, what is the value of $b$ such that $F(4, b, 2, 3) = 12$? -/
theorem mathd_algebra_59 (b : ℝ) (h₀ : (4 : ℝ) ^ b + 2 ^ 3 = 12) : b = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
