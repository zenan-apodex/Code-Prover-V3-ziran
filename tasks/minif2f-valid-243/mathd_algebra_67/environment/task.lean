import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $f(x) = 5x+3$ and $g(x)=x^2-2$. What is $g(f(-1))$? -/
theorem mathd_algebra_67 (f g : ℝ → ℝ) (h₀ : ∀ x, f x = 5 * x + 3) (h₁ : ∀ x, g x = x ^ 2 - 2) :
    g (f (-1)) = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
