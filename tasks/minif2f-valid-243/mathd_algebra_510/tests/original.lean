import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Given that $x + y = 13$ and $xy = 24$, find the distance from the point $(x, y)$ to the origin. -/
theorem mathd_algebra_510 (x y : ℝ) (h₀ : x + y = 13) (h₁ : x * y = 24) :
    Real.sqrt (x ^ 2 + y ^ 2) = (11) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
