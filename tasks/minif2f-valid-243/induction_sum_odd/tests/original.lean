import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that the sum of the first $n$ odd numbers is $n^2$. -/
theorem induction_sum_odd (n : ℕ) : ∑ k ∈ Finset.range n, (2 * k + 1) = n ^ 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
