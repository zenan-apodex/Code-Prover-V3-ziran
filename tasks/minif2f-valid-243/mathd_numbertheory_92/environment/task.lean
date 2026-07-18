import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Solve the congruence $5n \equiv 8 \pmod{17}$, as a residue modulo 17.  (Give an answer between 0 and 16.) -/
theorem mathd_numbertheory_92 (n : ℕ) (h₀ : 5 * n % 17 = 8) : n % 17 = (5) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
