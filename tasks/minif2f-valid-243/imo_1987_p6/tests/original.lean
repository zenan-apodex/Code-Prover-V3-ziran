import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $n\ge2$ be an integer. Prove that if $k^2+k+n$ is prime for all integers $k$ such that $0\le k\le\sqrt{n\over3}$, then $k^2+k+n$ is prime for all integers $k$ such that $0\le k\le n-2$. -/
theorem imo_1987_p6 (p : ℕ) (hp : 2 ≤ p) (f : ℕ → ℕ) (h₀ : ∀ x, f x = x ^ 2 + x + p)
    (h₁ : ∀ k : ℕ, k ≤ Nat.floor (Real.sqrt (p / 3)) → Nat.Prime (f k)) :
    ∀ i ≤ p - 2, Nat.Prime (f i) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
