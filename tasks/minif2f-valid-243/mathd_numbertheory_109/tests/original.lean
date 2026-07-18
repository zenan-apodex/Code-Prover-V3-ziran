import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Find the modulo $7$ remainder of the sum $1+3+5+7+9+\dots+195+197+199.$ -/
theorem mathd_numbertheory_109 (v : ℕ → ℕ) (h₀ : ∀ n, v n = (2 * n - 1 : ℕ)) :
    (∑ k ∈ Finset.Icc 1 100, v k) % 7 = (4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
