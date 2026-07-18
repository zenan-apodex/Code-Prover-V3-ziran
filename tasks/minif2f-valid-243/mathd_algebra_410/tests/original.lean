import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the minimum possible value for $y$ in the equation $y = x^2 - 6x + 13$? -/
theorem mathd_algebra_410 :
    IsLeast {y : ℝ | ∃ x : ℝ, y = x ^ 2 - 6 * x + 13} (4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
