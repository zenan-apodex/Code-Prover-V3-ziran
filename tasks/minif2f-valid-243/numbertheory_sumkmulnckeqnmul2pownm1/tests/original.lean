import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Calculate $\sum_{k=1}^{n} k \binom{n}{k}$.
Show that the answer is $n 2^{n-1}$. -/
theorem numbertheory_sumkmulnckeqnmul2pownm1 (n : ℕ) (h₀ : 0 < n) :
    ∑ k ∈ Finset.Icc 1 n, k * Nat.choose n k = (n * 2 ^ (n - 1)) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
