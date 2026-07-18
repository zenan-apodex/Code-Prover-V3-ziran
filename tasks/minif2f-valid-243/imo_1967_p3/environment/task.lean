import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $k,m,n$ be natural numbers such that $m+k+1$ is a prime greater than $n+1$. Let $c_s=s(s+1)$. Prove that

\[(c_{m+1}-c_k)(c_{m+2}-c_k)\ldots(c_{m+n}-c_k)\]

is divisible by the product $c_1c_2\ldots c_n$. -/
theorem imo_1967_p3 (k m n : ℕ) (c : ℕ → ℕ) (h₀ : 0 < k ∧ 0 < m ∧ 0 < n)
    (h₁ : ∀ s, c s = s * (s + 1)) (h₂ : Nat.Prime (k + m + 1)) (h₃ : n + 1 < k + m + 1) :
    (∏ i ∈ Finset.Icc 1 n, c i : ℤ)∣ ∏ i ∈ Finset.Icc 1 n, (c (m + i) - c k : ℤ) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
