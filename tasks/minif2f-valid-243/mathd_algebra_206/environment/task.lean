import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- The polynomial $p(x) = x^2+ax+b$ has distinct roots $2a$ and $b$. Find $a+b$. -/
theorem mathd_algebra_206 (a b : ℝ) (f : ℝ → ℝ) (h₀ : ∀ x, f x = x ^ 2 + a * x + b) (h₁ : 2 * a ≠ b)
    (h₂ : f (2 * a) = 0) (h₃ : f b = 0) : a + b = (-1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
