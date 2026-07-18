import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For any integer $n$, show that $n$ and $n^2$ are divisible by exactly the same prime numbers. -/
theorem numbertheory_prmdvsneqnsqmodpeq0 (n : ℤ) (p : ℕ) (h₀ : Nat.Prime p) :
    ↑p ∣ n ↔ n ^ 2 % p = 0 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
