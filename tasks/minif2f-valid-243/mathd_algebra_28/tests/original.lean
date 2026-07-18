import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the largest number $c$ such that $2x^2+5x+c=0$ has at least one real solution? Express your answer as a common fraction. -/
theorem mathd_algebra_28 : IsGreatest {c : ℝ | ∃ x : ℝ, 2 * x ^ 2 + 5 * x + c = 0} (25 / 8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
