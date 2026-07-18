import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Solve for $a$: $\frac15|9+2a|< 1$.  Express your answer in interval notation. -/
theorem mathd_algebra_327 :
    {a : ℝ | 1 / 5 * abs (9 + 2 * a) < 1} = (Set.Icc (-7) (-2)) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
