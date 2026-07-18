import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Simplify $(a-1)(a+1)(a+2) - (a-2)(a+1).$ -/
theorem mathd_algebra_568 (a : ℝ) :
    (a - 1) * (a + 1) * (a + 2) - (a - 2) * (a + 1) = (a ^ 3 + a ^ 2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
