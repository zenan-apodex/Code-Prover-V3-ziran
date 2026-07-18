import Mathlib

open scoped Nat
open scoped Real

/--
Find all integers $\,a,b,c\,$ with $\,1< a< b< c\,$ such that \[ (a-1)(b-1)(c-1)  \] is a divisor of $abc-1.$
-/
theorem imo_1992_p1 :
    { (p, q, r) | (p : ℤ) (q : ℤ) (r : ℤ) (h₀ : 1 < p ∧ p < q ∧ q < r)
      (h₁ : (p - 1) * (q - 1) * (r - 1) ∣ p * q * r - 1) } =
    {(2, 4, 8), (3, 5, 15)} := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
