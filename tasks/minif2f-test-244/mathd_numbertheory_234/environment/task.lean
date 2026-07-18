import Mathlib

open scoped Nat
open scoped Real

/--
When the two-digit integer $``\text{AB}"$ is cubed, the value is $912,\!673$. What is $A + B$?
-/
theorem mathd_numbertheory_234 (a b : ℕ) (h₀ : 1 ≤ a ∧ a ≤ 9 ∧ b ≤ 9)
    (h₁ : (10 * a + b) ^ 3 = 912673) : a + b = 16 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
