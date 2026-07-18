import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The greatest common divisor of two integers is $(x+3)$ and their least common multiple is $x(x+3)$, where $x$ is a positive integer. If one of the integers is 40, what is the smallest possible value of the other one? -/
theorem mathd_numbertheory_126 :
    IsLeast {a | ∃ x, 0 < x ∧ Nat.gcd a 40 = x + 3 ∧ Nat.lcm a 40 = x * (x + 3)} (8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
