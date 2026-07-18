import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that a square number must either be a multiple of 3 or have a remainder of 1 when divided by 3. -/
theorem numbertheory_sqmod3in01d (a : ℤ) : a ^ 2 % 3 = 0 ∨ a ^ 2 % 3 = 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
