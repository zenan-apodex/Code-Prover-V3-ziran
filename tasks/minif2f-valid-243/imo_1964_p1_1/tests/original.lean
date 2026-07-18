import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that if $2^n-1$ is divisible by 7, then $n$ is divisible by 3. -/
theorem imo_1964_p1_1 (n : ℕ) (h₀ : 7 ∣ 2 ^ n - 1) : 3 ∣ n := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
