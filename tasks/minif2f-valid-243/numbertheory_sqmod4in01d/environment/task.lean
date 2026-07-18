import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $a^2 \mod 4$ is either 0 or 1 for all $a$ in ℤ. -/
theorem numbertheory_sqmod4in01d (a : ℤ) : a ^ 2 % 4 = 0 ∨ a ^ 2 % 4 = 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
