import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Simplify: $3!(2^3+\sqrt{9})\div 2$. -/
theorem mathd_algebra_536 : ↑3! * ((2 : ℝ) ^ 3 + Real.sqrt 9) / 2 = (33) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
