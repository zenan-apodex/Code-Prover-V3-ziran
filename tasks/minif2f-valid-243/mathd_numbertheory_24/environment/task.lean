import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the tens digit in the sum $11^1 + 11^2 + 11^3 + \ldots + 11^9$? -/
theorem mathd_numbertheory_24 : (∑ k ∈ Finset.Icc 1 9, 11 ^ k) % 100 = (59) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
