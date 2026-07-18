import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For a given $z$, what is the maximum value of $36az - 9a^2$ as $a$ varies?
Show that the answer is $36z^2$. -/
theorem algebra_sqineq_36azm9asqle36zsq (z a : ℝ) : 36 * (a * z) - 9 * a ^ 2 ≤ 36 * z ^ 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
