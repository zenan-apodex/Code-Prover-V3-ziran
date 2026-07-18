import Mathlib

open scoped Nat
open scoped Real

/--
A positive integer $n$ is nice if there is a positive integer $m$ with exactly four positive divisors (including $1$ and $m$) such that the sum of the four divisors is equal to $n.$ Find the sum of all the nice numbers in the set $\{ 2010,2011,2012,\dots,2019 \}.$
-/
theorem mathd_numbertheory_451 (S : Finset ℕ)
    (h₀ :
      ∀ n : ℕ,
        n ∈ S ↔
          2010 ≤ n ∧ n ≤ 2019 ∧ ∃ m, (Nat.divisors m).card = 4 ∧ ∑ p ∈ Nat.divisors m, p = n) :
    ∑ k ∈ S, k = 2016 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
