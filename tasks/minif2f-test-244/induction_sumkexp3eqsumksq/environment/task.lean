import Mathlib

open scoped Nat
open scoped Real

theorem induction_sumkexp3eqsumksq (n : ℕ) :
    ∑ k ∈ Finset.range n, k ^ 3 = (∑ k ∈ Finset.range n, k) ^ 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
