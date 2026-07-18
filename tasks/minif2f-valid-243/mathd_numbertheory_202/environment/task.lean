import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the units digit of $19^{19}+99^{99}$? -/
theorem mathd_numbertheory_202 : (19 ^ 19 + 99 ^ 99) % 10 = (8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
