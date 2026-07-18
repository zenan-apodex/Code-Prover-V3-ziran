import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The graph of $y=ax^2 + bx + c$ is a parabola with vertical axis of symmetry.  The vertex of this parabola is $(2,3)$ and the parabola contains the point $(4,4)$.  Find the value of $y$ when $x=6$. -/
theorem mathd_algebra_214 (a : ℝ) (f : ℝ → ℝ) (h₀ : ∀ x, f x = a * (x - 2) ^ 2 + 3) (h₁ : f 4 = 4) :
    f 6 = (7) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
