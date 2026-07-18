import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the sum of the four positive factors of the positive integer value of $\sqrt{196}$? -/
theorem mathd_numbertheory_35 : ∑ k ∈ Nat.divisors (Nat.sqrt 196), k = (24) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
