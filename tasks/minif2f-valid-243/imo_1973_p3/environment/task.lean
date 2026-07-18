import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Determine the minimum value of $a^{2} + b^{2}$ when $(a,b)$ traverses all the pairs of real numbers for which the equation \[ x^{4} + ax^{3} + bx^{2} + ax + 1 = 0 \] has at least one real root. -/
theorem imo_1973_p3 :
    IsLeast
      {(a^2 + b^2) | (a : ℝ) (b : ℝ) (h : ∃ x, x^4 + a * x^3 + b * x^2 + a * x + 1 = 0)}
      (4 / 5) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
