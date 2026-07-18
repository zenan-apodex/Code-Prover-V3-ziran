import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Given positive real numbers $x$ and $y$ with $x \ge y$ and $\sqrt{xy}(x-y) = x+y$, show that $x+y ≥ 4$. -/
theorem algebra_amgm_sqrtxymulxmyeqxpy_xpygeq4 (x y : ℝ) (h₀ : 0 < x ∧ 0 < y) (h₁ : y ≤ x)
    (h₂ : Real.sqrt (x * y) * (x - y) = x + y) : x + y ≥ 4 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
