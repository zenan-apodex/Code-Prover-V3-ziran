import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Find the number of distinct positive divisors of $(30)^4$ excluding 1 and $(30)^4$. -/
theorem mathd_numbertheory_543 : (∑ k ∈ Nat.divisors (30 ^ 4), 1 - 2 : ℕ) = (123) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
