import Mathlib

open scoped Nat
open scoped Real

/--
Let $a > b > c > d$ be positive integers and suppose that \[ ac + bd = (b+d+a-c)(b+d-a+c).  \] Prove that $ab + cd$ is not prime.
-/
theorem imo_2001_p6 (a b c d : ℤ) (h₀ : 0 < a ∧ 0 < b ∧ 0 < c ∧ 0 < d) (h₁ : d < c) (h₂ : c < b)
    (h₃ : b < a) (h₄ : a * c + b * d = (b + d + a - c) * (b + d - a + c)) :
    ¬Prime (a * b + c * d) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
