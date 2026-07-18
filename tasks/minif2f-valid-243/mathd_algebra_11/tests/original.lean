import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the simplified numerical value of $\frac{a+11b}{a-b}$ if $\frac{4a+3b}{a-2b}=5$? -/
theorem mathd_algebra_11 (a b : ℝ) (h₀ : a ≠ b) (h₁ : a ≠ 2 * b)
    (h₂ : (4 * a + 3 * b) / (a - 2 * b) = 5) : (a + 11 * b) / (a - b) = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
