import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Find the integer that lies between $\sqrt[3]{-45}$ and $\sqrt[3]{-101}$. -/
theorem mathd_algebra_437 (x y : ℝ) (n : ℤ) (h₀ : x ^ 3 = -45) (h₁ : y ^ 3 = -101) (h₂ : ↑n < x)
    (h₃ : y < n) : n = (-4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
