import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the positive difference between $120\%$ of 30 and $130\%$ of 20? -/
theorem mathd_algebra_10 : abs ((120 : ℝ) / 100 * 30 - 130 / 100 * 20) = (10) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
