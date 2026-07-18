import Mathlib

open scoped Nat
open scoped Real

/--
Find all pairs $ (a,b)$ of positive integers that satisfy the equation: $ a^{b^2} ={} b^a$.
-/
theorem imo_1997_p5 :
    {(x, y) | (x : ℕ) (y : ℕ) (h₀ : 0 < x ∧ 0 < y) (h₁ : x ^ y ^ 2 = y ^ x) }
      = {(1, 1), (16, 2), (27, 3)} := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
