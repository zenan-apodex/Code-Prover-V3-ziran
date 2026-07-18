import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Simplify $(7b^3)^2 \cdot (4b^2)^{-3},$ given that $b$ is non-zero. -/
theorem mathd_algebra_89 (b : ℝ) (h₀ : b ≠ 0) :
    (7 * b ^ 3) ^ 2 * (4 * b ^ 2) ^ (-(3 : ℤ)) = (49 / 64) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
