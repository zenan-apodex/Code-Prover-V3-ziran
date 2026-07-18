import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose $t$ is a positive integer such that $\mathop{\text{lcm}}[12,t]^3=(12t)^2$. What is the smallest possible value for $t$? -/
theorem mathd_numbertheory_629 : IsLeast {t : ℕ | 0 < t ∧ Nat.lcm 12 t ^ 3 = (12 * t) ^ 2} (18) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
