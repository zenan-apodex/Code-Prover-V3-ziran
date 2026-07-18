import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- How many integers $n$ satisfy $0< n< 60$ and $4n\equiv 2\pmod 6?$ -/
theorem mathd_numbertheory_211 :
    Finset.card (Finset.filter (fun n => 6 ∣ 4 * ↑n - (2 : ℤ)) (Finset.range 60)) = (20) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
