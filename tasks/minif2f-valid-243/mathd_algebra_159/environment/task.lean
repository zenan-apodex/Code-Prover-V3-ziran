import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $f(x)=3x^4-7x^3+2x^2-bx+1$. For what value of $b$ is $f(1)=1$? -/
theorem mathd_algebra_159 (b : ℝ) (f : ℝ → ℝ)
    (h₀ : ∀ x, f x = 3 * x ^ 4 - 7 * x ^ 3 + 2 * x ^ 2 - b * x + 1) (h₁ : f 1 = 1) : b = (-2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
