import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $n$ gives a remainder of 3 when divided by 7, then what remainder does $2n+1$ give when divided by 7? -/
theorem mathd_numbertheory_370 (n : ℕ) (h₀ : n % 7 = 3) : (2 * n + 1) % 7 = (0) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
