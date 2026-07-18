import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Evaluate: $\left( \frac{1}{2} + \frac{1}{3} \right) \left( \frac{1}{2} - \frac{1}{3} \right)$ -/
theorem mathd_algebra_462 : ((1 : ℚ) / 2 + 1 / 3) * (1 / 2 - 1 / 3) = (5 / 36) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
