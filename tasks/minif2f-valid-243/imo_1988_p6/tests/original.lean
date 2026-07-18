import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $ a$ and $ b$ be two positive integers such that $ a \cdot b +{} 1$ divides $ a^{2} +{} b^{2}$. Show that $ \frac {a^{2} +{} b^{2}}{a \cdot b +{} 1}$ is a perfect square. -/
theorem imo_1988_p6 (a b : ℕ) (h₀ : 0 < a ∧ 0 < b) (h₁ : a * b + 1 ∣ a ^ 2 + b ^ 2) :
    ∃ x : ℕ, (x ^ 2 : ℝ) = (a ^ 2 + b ^ 2) / (a * b + 1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
