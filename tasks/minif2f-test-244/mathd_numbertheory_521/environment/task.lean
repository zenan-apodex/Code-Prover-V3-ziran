import Mathlib

open scoped Nat
open scoped Real

/--
The product of two consecutive positive even integers is 288. What is the greater of the two integers?
-/
theorem mathd_numbertheory_521 (m n : ℕ) (h₀ : Even m) (h₁ : Even n) (h₂ : m - n = 2)
    (h₃ : m * n = 288) : m = 18 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
