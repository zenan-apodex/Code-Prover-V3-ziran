import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Cards are numbered from 1 to 100. One card is removed and the values on the other 99 are added. The resulting sum is a multiple of 77. What number was on the card that was removed? -/
theorem mathd_numbertheory_257 (x : ℕ) (h₀ : 1 ≤ x ∧ x ≤ 100)
    (h₁ : 77 ∣ (∑ k ∈ Finset.range 101, k - x : ℕ)) : x = (45) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
