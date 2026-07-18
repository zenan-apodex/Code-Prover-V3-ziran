import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose that $g(x)=f^{-1}(x)$. If $g(-15)=0$, $g(0)=3$, $g(3)=9$ and $g(9)=20$, what is $f(f(9))$? -/
theorem mathd_algebra_451 (σ : Equiv ℝ ℝ) (h₀ : σ.2 (-15) = 0) (h₁ : σ.2 0 = 3) (h₂ : σ.2 3 = 9)
    (h₃ : σ.2 9 = 20) : σ.1 (σ.1 9) = (0) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
