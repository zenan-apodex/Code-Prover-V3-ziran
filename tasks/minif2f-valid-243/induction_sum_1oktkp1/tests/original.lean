import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $\sum_{k=1}^n \frac{1}{k(k+1)} = \frac{n}{n+1}$. -/
theorem induction_sum_1oktkp1 (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 : ℝ) / ((k + 1) * (k + 2)) = n / (n + 1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
