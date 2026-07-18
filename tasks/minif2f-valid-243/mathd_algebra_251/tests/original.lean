import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Three plus the reciprocal of a number equals 7 divided by that number.  What is the number? -/
theorem mathd_algebra_251 (x : ℝ) (h₀ : x ≠ 0) (h₁ : 3 + 1 / x = 7 / x) : x = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
