import Mathlib

open scoped Nat
open scoped Real

/--
The two positive integer solutions of the equation $x^2 - mx + n = 0$ are $k$ and $t$, where $m$ and $n$ are both prime numbers and $k > t$. What is the value of $m^n + n^m + k^t + t^k$?
-/
theorem mathd_algebra_289 (k t m n : ℕ) (h₀ : Nat.Prime m ∧ Nat.Prime n) (h₁ : t < k)
    (h₂ : (k ^ 2 : ℤ) - m * k + n = 0) (h₃ : (t ^ 2 : ℤ) - m * t + n = 0) :
    m ^ n + n ^ m + k ^ t + t ^ k = 20 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
