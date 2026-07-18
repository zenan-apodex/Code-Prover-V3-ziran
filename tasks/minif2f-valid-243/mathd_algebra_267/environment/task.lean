import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Solve for $x$: $\frac{x+1}{x-1} = \frac{x-2}{x+2}$ -/
theorem mathd_algebra_267 (x : ℝ) (h₀ : x ≠ 1) (h₁ : x ≠ -2)
    (h₂ : (x + 1) / (x - 1) = (x - 2) / (x + 2)) : x = (0) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
