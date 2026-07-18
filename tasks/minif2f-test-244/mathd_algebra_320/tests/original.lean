import Mathlib

open scoped Nat
open scoped Real

/--
Let $x$ be a positive number such that $2x^2 = 4x + 9.$ If $x$ can be written in simplified form as $\dfrac{a + \sqrt{b}}{c}$ such that $a,$ $b,$ and $c$ are positive integers, what is $a + b + c$?
-/
theorem mathd_algebra_320 (x : NNReal) (a b c : ℕ) (h₀ : 0 < a ∧ 0 < b ∧ 0 < c)
    (h₁ : 2 * x ^ 2 = 4 * x + 9) (h₂ : x = (a + NNReal.sqrt b) / c)
    (h₃ : (¬∃ n > 1, n ∣ a ∧ n ^ 2 ∣ b ∧ n ∣ c) ∧ ¬IsSquare b) : a + b + c = 26 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
