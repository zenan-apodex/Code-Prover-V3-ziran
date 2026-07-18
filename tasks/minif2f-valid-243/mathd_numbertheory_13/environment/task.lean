import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the average of the two smallest positive integer solutions to the congruence $$14u \equiv 46 \pmod{100}~?$$ -/
theorem mathd_numbertheory_13 (u v : ℕ) (S : Set ℕ)
    (h₀ : ∀ n : ℕ, n ∈ S ↔ 0 < n ∧ 14 * n % 100 = 46) (h₁ : IsLeast S u)
    (h₂ : IsLeast (S \ {u}) v) : (u + v : ℚ) / 2 = (64) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
