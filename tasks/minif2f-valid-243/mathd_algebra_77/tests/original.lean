import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose that $a$ and $b$ are nonzero real numbers, and that the equation  $${x^2 + ax + b = 0}$$ has solutions $a$ and $b$. Then what is the pair $(a,b)$? -/
theorem mathd_algebra_77 (a b : ℝ) (f : ℝ → ℝ) (h₀ : a ≠ 0 ∧ b ≠ 0 ∧ a ≠ b)
    (h₁ : ∀ x, f x = x ^ 2 + a * x + b) (h₂ : f a = 0) (h₃ : f b = 0) : a = 1 ∧ b = -2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
