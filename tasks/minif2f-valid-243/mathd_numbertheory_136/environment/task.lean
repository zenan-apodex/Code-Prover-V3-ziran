import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
When 39,500 is divided by an integer $n$, the quotient is 123 and the remainder is 17. Find $n$. -/
theorem mathd_numbertheory_136 (n : ℕ) (h₀ : 123 * n + 17 = 39500) : n = (321) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
