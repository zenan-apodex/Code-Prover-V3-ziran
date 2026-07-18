import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Prove that $n^3 + 2n$ is divisible by 3 for any whole number $n$. -/
theorem induction_divisibility_3divnto3m2n (n : ℕ) : 3 ∣ n ^ 3 + 2 * n := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
