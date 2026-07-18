import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The two-digit number $``B6,''$ where $B$ is the tens digit, is the square of a positive integer. How many distinct possible values are there for $B$? -/
theorem mathd_numbertheory_22 :
    { b ∈ Finset.Icc 1 9 | IsSquare (10 * b + 6) }.card = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
