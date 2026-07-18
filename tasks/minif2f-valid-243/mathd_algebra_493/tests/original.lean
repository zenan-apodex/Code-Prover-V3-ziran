import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $f(x) = x^2 - 4\sqrt{x} + 1$. What is $f(f(4))$? -/
theorem mathd_algebra_493 (f : ℝ → ℝ) (h₀ : ∀ x, f x = x ^ 2 - 4 * Real.sqrt x + 1) :
    f (f 4) = (70) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
