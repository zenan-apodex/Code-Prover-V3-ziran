import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $f(x) = 3\sqrt{2x - 7} - 8$.  Find $f(8)$. -/
theorem mathd_algebra_433 (f : ℝ → ℝ) (h₀ : ∀ x, f x = 3 * Real.sqrt (2 * x - 7) - 8) :
  f 8 = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
