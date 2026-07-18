import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the greatest common factor of $20 !$ and $200,\!000$?  (Reminder: If $n$ is a positive integer, then $n!$ stands for the product $1\cdot 2\cdot 3\cdot \cdots \cdot (n-1)\cdot n$.) -/
theorem mathd_numbertheory_169 : Nat.gcd 20! 200000 = (40000) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
