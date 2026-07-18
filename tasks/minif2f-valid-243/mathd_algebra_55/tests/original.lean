import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What fraction is the same as \[
\frac{2-4+6-8+10-12+14}{3-6+9-12+15-18+21}?
\] -/
theorem mathd_algebra_55 (q p : ℝ) (h₀ : q = 2 - 4 + 6 - 8 + 10 - 12 + 14)
    (h₁ : p = 3 - 6 + 9 - 12 + 15 - 18 + 21) : q / p = (2 / 3) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
