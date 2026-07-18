import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- When all the girls at Madeline's school line up in rows of eight, there are seven left over.

If instead they line up in rows of four, how many are left over? -/
theorem mathd_numbertheory_458 (n : ℕ) (h₀ : n % 8 = 7) : n % 4 = (3) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
