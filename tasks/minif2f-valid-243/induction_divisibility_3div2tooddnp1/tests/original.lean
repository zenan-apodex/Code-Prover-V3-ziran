import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $2^{2n+1} + 1$ is divisible by 3 for all natural numbers $n$. -/
theorem induction_divisibility_3div2tooddnp1 (n : ℕ) : 3 ∣ 2 ^ (2 * n + 1) + 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
