import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $2$ divides $4^n$ for any positive integer $n$. -/
theorem numbertheory_2dvd4expn (n : ℕ) (h₀ : n ≠ 0) : 2 ∣ 4 ^ n := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
