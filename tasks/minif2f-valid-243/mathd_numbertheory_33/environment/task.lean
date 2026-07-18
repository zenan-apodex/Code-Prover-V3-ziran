import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Find an integer $n$ such that $0\leq n< 398$ and $n$ is a multiplicative inverse to 7 modulo 398. -/
theorem mathd_numbertheory_33 : ∃ (n : ℕ), n < 398 ∧ n * 7 % 398 = 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
