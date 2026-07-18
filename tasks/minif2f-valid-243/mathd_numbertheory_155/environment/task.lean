import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- How many positive three-digit integers are congruent to $7 \pmod{19}?$ -/
theorem mathd_numbertheory_155 :
    Finset.card (Finset.filter (fun x => x % 19 = 7) (Finset.Icc 100 999)) = (48) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
