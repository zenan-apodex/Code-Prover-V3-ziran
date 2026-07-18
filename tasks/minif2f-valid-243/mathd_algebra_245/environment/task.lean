import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Simplify $\left( \frac{4}{x} \right)^{-1} \left( \frac{3x^3}{x} \right)^2 \left( \frac{1}{2x} \right)^{-3}$. -/
theorem mathd_algebra_245 (x : ℝ) (h₀ : x ≠ 0) :
    (4 / x)⁻¹ * (3 * x ^ 3 / x) ^ 2 * (1 / (2 * x))⁻¹ ^ 3 = (18 * x ^ 8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
