import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $f(x)=x^3-8$, what is $f^{-1}(f(f^{-1}(19)))$? -/
theorem mathd_algebra_323 (σ : Equiv ℝ ℝ) (h : ∀ x, σ.1 x = x ^ 3 - 8) : σ.2 (σ.1 (σ.2 19)) = (3) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
