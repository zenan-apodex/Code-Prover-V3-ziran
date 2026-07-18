import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- The sum of the proper divisors of 18 is 21. What is the sum of the proper divisors of 198? -/
theorem mathd_numbertheory_403 : ∑ k ∈ Nat.properDivisors 198, k = (270) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
