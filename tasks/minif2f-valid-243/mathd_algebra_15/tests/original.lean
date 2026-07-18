import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $a * b = a^b + b^a$, for all positive integer values of $a$ and $b$, then what is the value of $2 * 6$? -/
theorem mathd_algebra_15 (s : ℕ → ℕ → ℕ)
    (h₀ : ∀ a b, 0 < a ∧ 0 < b → s a b = a ^ (b : ℕ) + b ^ (a : ℕ)) : s 2 6 = (100) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
