import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Given that $x+y = 7$ and $3x+y = 45,$ evaluate $x^2-y^2.$ -/
theorem mathd_algebra_37 (x y : ℝ) (h₀ : x + y = 7) (h₁ : 3 * x + y = 45) : x ^ 2 - y ^ 2 = (217) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
