import Mathlib

open scoped Nat
open scoped Real

/--
The greatest common divisor of positive integers $m$ and $n$ is 6. The least common multiple of $m$ and $n$ is 126. What is the least possible value of $m+n$?
-/
theorem mathd_numbertheory_277 :
    IsLeast
       {(m + n) | (m : ℕ) (n : ℕ) (h₀ : Nat.gcd m n = 6) (h₁ : Nat.lcm m n = 126)}
      60 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
