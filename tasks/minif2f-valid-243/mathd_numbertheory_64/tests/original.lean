import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the smallest positive integer that satisfies the congruence $30x \equiv 42 \pmod{47}$? -/
theorem mathd_numbertheory_64 : IsLeast {x : ℕ | 30 * x ≡ 42 [MOD 47]} (39) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
