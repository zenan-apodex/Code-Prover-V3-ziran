import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
When Rachel divides her favorite number by 7, she gets a remainder of 5. What will the remainder be if she multiplies her favorite number by 5 and then divides by 7? -/
theorem mathd_numbertheory_335 (n : ℕ) (h₀ : n % 7 = 5) : 5 * n % 7 = (4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
