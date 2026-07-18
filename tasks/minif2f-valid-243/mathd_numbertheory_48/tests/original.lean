import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $321_{b}$ is equal to the base 10 integer 57, find $b$ given that $b>0$. -/
theorem mathd_numbertheory_48 (b : ℕ) (h₀ : 0 < b) (h₁ : 3 * b ^ 2 + 2 * b + 1 = 57) : b = (4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
