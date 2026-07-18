import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Given the two functions $f(x)=x^3+2x+1$ and $g(x)=x-1$, find $f(g(1))$. -/
theorem mathd_algebra_616 (f g : ℝ → ℝ) (h₀ : ∀ x, f x = x ^ 3 + 2 * x + 1)
    (h₁ : ∀ x, g x = x - 1) : f (g 1) = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
