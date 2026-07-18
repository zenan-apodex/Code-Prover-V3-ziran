import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
A group of $N$ students, where $N < 50$, is on a field trip. If their teacher puts them in groups of 8, the last group has 5 students. If their teacher instead puts them in groups of 6, the last group has 3 students. What is the sum of all possible values of $N$? -/
theorem mathd_numbertheory_149 :
    ∑ k ∈ Finset.filter (fun x => x % 8 = 5 ∧ x % 6 = 3) (Finset.range 50), k = (66) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
