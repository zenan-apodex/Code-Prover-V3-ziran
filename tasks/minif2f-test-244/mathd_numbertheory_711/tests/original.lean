import Mathlib

open scoped Nat
open scoped Real

/--
The greatest common divisor of positive integers $m$ and $n$ is 8. The least common multiple of $m$ and $n$ is 112. What is the least possible value of $m+n$?
-/
theorem mathd_numbertheory_711 :
    IsLeast
      { m + n | (m : ℕ) (n : ℕ)
        (h₀ : 0 < m ∧ 0 < n)
        (h₁ : gcd m n = 8)
        (h₂ : lcm m n = 112)}
      72 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
