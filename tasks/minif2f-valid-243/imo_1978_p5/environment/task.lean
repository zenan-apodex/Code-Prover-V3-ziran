import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $f$ be an injective function from ${1,2,3,\ldots}$ in itself. Prove that for any $n$ we have: $\sum_{k=1}^{n} f(k)k^{-2} \geq \sum_{k=1}^{n} k^{-1}.$ -/
theorem imo_1978_p5 (n : ℕ) (a : ℕ → ℕ) (h₀ : Function.Injective a) (h₁ : a 0 = 0) (h₂ : 0 < n) :
    ∑ k ∈ Finset.Icc 1 n, (1 : ℝ) / k ≤ ∑ k ∈ Finset.Icc 1 n, (a k / k ^ 2 : ℝ) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
