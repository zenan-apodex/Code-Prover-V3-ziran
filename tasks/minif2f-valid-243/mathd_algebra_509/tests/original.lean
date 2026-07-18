import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Simplify the following expression to a simplified fraction: $$\sqrt{\dfrac{\dfrac{5}{\sqrt{80}}+\dfrac{\sqrt{845}}{9}+\sqrt{45}}{\sqrt5}}.$$ -/
theorem mathd_algebra_509 :
    Real.sqrt ((5 / Real.sqrt 80 + Real.sqrt 845 / 9 + Real.sqrt 45) / Real.sqrt 5) = (13 / 6) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
