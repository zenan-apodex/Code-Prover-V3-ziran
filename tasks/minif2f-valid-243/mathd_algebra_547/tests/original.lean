import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the positive value of the expression $\sqrt{x^3 - 2^y}$ when $x = 5$ and $y = 2$? -/
theorem mathd_algebra_547 (x y : ℝ) (h₀ : x = 5) (h₁ : y = 2) : Real.sqrt (x ^ 3 - 2 ^ y) = (11) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
