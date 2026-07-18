import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $\binom{n}{k} = \binom{n-1}{k} + \binom{n-1}{k-1}$. -/
theorem numbertheory_nckeqnm1ckpnm1ckm1 (n k : ℕ) (h₀ : 0 < n ∧ 0 < k) (h₁ : k ≤ n) :
    Nat.choose n k = Nat.choose (n - 1) k + Nat.choose (n - 1) (k - 1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
