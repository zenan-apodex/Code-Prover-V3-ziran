import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $f(x)=4x^3+1$, find $f^{-1}(33)$. -/
theorem mathd_algebra_393 (σ : Equiv ℝ ℝ) (h₀ : ∀ x, σ.1 x = 4 * x ^ 3 + 1) : σ.2 33 = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
