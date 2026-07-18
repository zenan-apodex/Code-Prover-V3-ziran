import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- The midpoint of the line segment between $(x,y)$ and $(-9,1)$ is $(3,-5)$. Find $(x,y)$. -/
theorem mathd_algebra_126 (x y : ℝ) (h₀ : 2 * 3 = x - 9) (h₁ : 2 * -5 = y + 1) : (x, y) = ((15, -11)) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
