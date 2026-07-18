import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $9$ divides $10^n-1$ for any positive integer $n$. -/
theorem induction_divisibility_9div10tonm1 (n : ℕ) (h₀ : 0 < n) : 9 ∣ 10 ^ n - 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
