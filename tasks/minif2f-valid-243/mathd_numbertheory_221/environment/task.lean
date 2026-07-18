import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
How many natural numbers less than 1000 have exactly three distinct positive integer divisors? -/
theorem mathd_numbertheory_221 (S : Finset ℕ)
    (h₀ : ∀ x : ℕ, x ∈ S ↔ 0 < x ∧ x < 1000 ∧ x.divisors.card = 3) : S.card = (11) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
