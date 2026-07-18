import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Find the value of $(52+6\sqrt{43})^{3/2}-(52-6\sqrt{43})^{3/2}$. -/
theorem aime_1990_p2 :
    (52 + 6 * Real.sqrt 43) ^ ((3 : ℝ) / 2) - (52 - 6 * Real.sqrt 43) ^ ((3 : ℝ) / 2) = (828) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
