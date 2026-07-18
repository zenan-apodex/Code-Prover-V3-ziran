import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $f(x)=5x-12$, find a value for $x$ so that $f^{-1}(x)=f(x+1)$. -/
theorem mathd_algebra_422 (x : ℝ) (σ : Equiv ℝ ℝ) (h₀ : ∀ x, σ.1 x = 5 * x - 12)
    (h₁ : σ.1 (x + 1) = σ.2 x) : x = (47 / 24) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
