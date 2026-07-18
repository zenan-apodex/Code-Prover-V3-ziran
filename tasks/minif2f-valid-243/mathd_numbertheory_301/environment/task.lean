import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $j$ is a positive integer and the expression $(7j+3)$ is multiplied by 3 and then divided by 7, what is the remainder? -/
theorem mathd_numbertheory_301 (j : ℕ) (h₀ : 0 < j) : 3 * (7 * ↑j + 3) % 7 = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
