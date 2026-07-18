import Mathlib

open scoped Nat
open scoped Real

/--
If $A$ is the sum of the positive divisors of $500$, what is the sum of the distinct prime divisors of $A$?
-/
theorem mathd_numbertheory_427 (a : ℕ) (h₀ : a = ∑ k ∈ Nat.divisors 500, k) :
    ∑ k ∈ Finset.filter (fun x => Nat.Prime x) (Nat.divisors a), k = 25 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
