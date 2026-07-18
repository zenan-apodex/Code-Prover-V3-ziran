import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $f (x) = x + 2$ and $g (x) = x^2$, then for what value of $x$ does $f(g(x)) = g(f(x))$? Express your answer as a common fraction. -/
theorem mathd_algebra_132 (x : ℝ) (f g : ℝ → ℝ) (h₀ : ∀ x, f x = x + 2) (h₁ : ∀ x, g x = x ^ 2)
    (h₂ : f (g x) = g (f x)) : x = (-1 / 2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
