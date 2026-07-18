import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Given that
\begin{align*}
x_{1}&=211,\\
x_{2}&=375,\\
x_{3}&=420,\\
x_{4}&=523, \text{ and}\\
x_{n}&=x_{n-1}-x_{n-2}+x_{n-3}-x_{n-4} \text{ when } n \geq 5,
\end{align*}

find the value of $x_{531}+x_{753}+x_{975}$. -/
theorem aimeII_2001_p3 (x : ℕ → ℤ) (h₀ : x 1 = 211) (h₂ : x 2 = 375) (h₃ : x 3 = 420)
    (h₄ : x 4 = 523) (h₆ : ∀ n ≥ 5, x n = x (n - 1) - x (n - 2) + x (n - 3) - x (n - 4)) :
    x 531 + x 753 + x 975 = (898) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
