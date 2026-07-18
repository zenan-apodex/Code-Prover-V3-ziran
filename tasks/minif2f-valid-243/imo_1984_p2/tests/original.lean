import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Find one pair of positive integers $a,b$ such that $ab(a+b)$ is not divisible by $7$, but $(a+b)^7-a^7-b^7$ is divisible by $7^7$. -/
theorem imo_1984_p2 (a b : ℕ) (h₀ : 0 < a ∧ 0 < b) (h₁ : ¬7 ∣ a) (h₂ : ¬7 ∣ b) (h₃ : ¬7 ∣ a + b)
    (h₄ : 7 ^ 7 ∣ (a + b) ^ 7 - a ^ 7 - b ^ 7) : 19 ≤ a + b := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
