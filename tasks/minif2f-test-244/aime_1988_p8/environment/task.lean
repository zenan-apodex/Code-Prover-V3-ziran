import Mathlib

open scoped Nat
open scoped Real

/--
The function $f$, defined on the set of ordered pairs of positive integers, satisfies the following properties:
\begin{eqnarray*} f(x,x) &=& x, \\ f(x,y) &=& f(y,x), \quad \text{and} \\ (x + y) f(x,y) &=& yf(x,x + y). \end{eqnarray*}
Calculate $f(14,52)$.
-/
theorem aime_1988_p8 (f : ℕ → ℕ → ℝ) (h₀ : ∀ x, 0 < x → f x x = x)
    (h₁ : ∀ x y, 0 < x ∧ 0 < y → f x y = f y x)
    (h₂ : ∀ x y, 0 < x ∧ 0 < y → (↑x + ↑y) * f x y = y * f x (x + y)) : f 14 52 = 364 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
