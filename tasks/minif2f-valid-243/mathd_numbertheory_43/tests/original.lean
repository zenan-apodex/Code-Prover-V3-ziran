import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Determine the largest possible integer $n$ such that $942!$ is divisible by $15^n$. -/
theorem mathd_numbertheory_43 : IsGreatest {n : ℕ | 15 ^ n ∣ 942!} (233) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
