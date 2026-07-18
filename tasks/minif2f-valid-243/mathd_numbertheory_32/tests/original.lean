import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the sum of all of the positive factors of $36$? -/

theorem mathd_numbertheory_32 (S : Finset ℕ) (h₀ : ∀ n : ℕ, n ∈ S ↔ n ∣ 36) : ∑ k ∈ S, k = (91) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
