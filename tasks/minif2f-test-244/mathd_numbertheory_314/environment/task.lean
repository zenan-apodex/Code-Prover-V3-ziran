import Mathlib

open scoped Nat
open scoped Real

/--
Let $r$ be the remainder when $1342$ is divided by $13$.

Determine the smallest positive integer that has these two properties:

$\bullet~$ It is a multiple of $1342$.

$\bullet~$ Its remainder upon being divided by $13$ is smaller than $r$.
-/
theorem mathd_numbertheory_314 (r : ℕ) (h₀ : r = 1342 % 13) :
    IsLeast {n : ℕ | 0 < n ∧ 1342 ∣ n ∧ n % 13 < r} 6710 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
