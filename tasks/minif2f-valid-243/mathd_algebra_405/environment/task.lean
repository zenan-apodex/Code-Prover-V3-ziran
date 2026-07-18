import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For how many positive integer values of $x$ is the sum $x^2+4x+4$ less than 20? -/
theorem mathd_algebra_405 (S : Finset ℕ) (h₀ : ∀ x, x ∈ S ↔ 0 < x ∧ x ^ 2 + 4 * x + 4 < 20) :
    S.card = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
