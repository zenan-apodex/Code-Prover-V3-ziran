import Mathlib

open scoped Nat
open scoped Real

/--
What is the smallest positive integer, other than $1$, that is both a perfect cube and a perfect fourth power?
-/
theorem mathd_numbertheory_296 : IsLeast {n : ℕ | 2 ≤ n ∧ ∃ x, x ^ 3 = n ∧ ∃ t, t ^ 4 = n} 4096 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
