import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- In this problem, $a$ and $b$ are integers, such that $a \ge b.$

If $a+b\equiv 2\pmod{10}$ and $2a+b\equiv 1\pmod{10}$, then what is the last digit of $a-b$? -/
theorem mathd_numbertheory_110 (a b : ℕ) (h₀ : 0 < a ∧ 0 < b ∧ b ≤ a) (h₁ : (a + b) % 10 = 2)
    (h₂ : (2 * a + b) % 10 = 1) : (a - b) % 10 = (6) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
