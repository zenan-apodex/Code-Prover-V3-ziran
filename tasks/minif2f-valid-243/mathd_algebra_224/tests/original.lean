import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The square root of $t$ is greater than $2$ and less than $3.5$. How many integer values of $t$ satisfy this condition? -/
theorem mathd_algebra_224 (S : Finset ℕ)
    (h₀ : ∀ n : ℕ, n ∈ S ↔ Real.sqrt n < 7 / 2 ∧ 2 < Real.sqrt n) : S.card = (8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
