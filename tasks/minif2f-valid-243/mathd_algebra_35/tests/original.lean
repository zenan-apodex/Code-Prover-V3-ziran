import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $p (x) = 2-x^2$ and $q(x) = \frac{6}{x}$, what is the value of $p (q(2))$? -/
theorem mathd_algebra_35 (p q : ℝ → ℝ) (h₀ : ∀ x, p x = 2 - x ^ 2)
    (h₁ : ∀ x ≠ 0, q x = 6 / x) : p (q 2) = (-7) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
