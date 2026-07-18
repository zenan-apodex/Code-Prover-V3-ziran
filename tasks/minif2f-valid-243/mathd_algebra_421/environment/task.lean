import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The parabolas defined by the equations $y=x^2+4x+6$ and $y=\frac{1}{2}x^2+x+6$ intersect at points $(a,b)$ and $(c,d)$, where $c\ge a$. What is $c-a$? -/
theorem mathd_algebra_421 (a b c d : ℝ) (h₀ : b = a ^ 2 + 4 * a + 6)
    (h₁ : b = 1 / 2 * a ^ 2 + a + 6) (h₂ : d = c ^ 2 + 4 * c + 6) (h₃ : d = 1 / 2 * c ^ 2 + c + 6)
    (h₄ : (a, b) ≠ (c, d)) (h₅ : a ≤ c) : c - a = (6) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
