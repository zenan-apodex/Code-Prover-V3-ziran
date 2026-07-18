import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $n$ be a positive integer.  What is the greatest possible value of $\gcd(n + 7, 2n + 1)$? -/
theorem mathd_numbertheory_156 :
    IsGreatest {Nat.gcd (n + 7) (2 * n + 1) | (n : ℕ) (hn : 0 < n)} (13) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
