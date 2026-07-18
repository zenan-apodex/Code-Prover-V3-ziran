import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that the sum of the first $n$ terms of the sequence $3, 5, 7, 9, ... $ is $(n+1)^2-1$. -/
theorem induction_sum2kp1npqsqm1 (n : ℕ) :
    ↑(∑ k ∈ Finset.range n, (2 * k + 3)) = ↑(n + 1) ^ 2 - (1 : ℤ) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
