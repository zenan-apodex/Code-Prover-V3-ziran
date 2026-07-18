import Mathlib

open scoped Nat
open scoped Real

/--
Let $\mathbb{N}$ be the set of positive integers. Let $f$ be a function defined on $\mathbb{N}$, which satisfies the inequality $f(n + 1) > f(f(n))$ for all $n \in \mathbb{N}$. Prove that for any $n$ we have $f(n) = n.$
-/
theorem imo_1977_p6 (f : ℕ → ℕ) (h₀ : ∀ n, 0 < f n) (h₁ : ∀ n, 0 < n → f (f n) < f (n + 1)) :
    ∀ n, 0 < n → f n = n := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
