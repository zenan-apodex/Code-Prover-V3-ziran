import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $t=2s-s^2$ and $s=n^2 - 2^n+1$. What is the value of $t$ when $n=3$? -/
theorem mathd_algebra_247 (t s : ℝ) (n : ℤ) (h₀ : t = 2 * s - s ^ 2) (h₁ : s = n ^ 2 - 2 ^ n + 1)
    (h₂ : n = 3) : t = (0) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
