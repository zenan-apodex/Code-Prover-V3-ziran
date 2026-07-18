import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Find $\frac{1}{a-1}+\frac{1}{b-1},$ where $a$ and $b$ are the roots of the quadratic equation $2x^2-7x+2 = 0.$ -/
theorem mathd_algebra_131 (a b : ℝ) (f : ℝ → ℝ) (h₀ : ∀ x, f x = 2 * x ^ 2 - 7 * x + 2)
    (h₁ : f a = 0) (h₂ : f b = 0) (h₃ : a ≠ b) : 1 / (a - 1) + 1 / (b - 1) = (-1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
