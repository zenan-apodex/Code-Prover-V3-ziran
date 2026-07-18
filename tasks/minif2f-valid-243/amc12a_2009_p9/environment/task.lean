import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Suppose that $ f(x+{}3)={}3x^2+{}7x+{}4$ and $ f(x)={}ax^2+{}bx+{}c$. What is $ a+{}b+{}c$?

$ \textbf{(A)}-{}\!1 \qquad
\textbf{(B)}\ 0 \qquad
\textbf{(C)}\ 1 \qquad
\textbf{(D)}\ 2 \qquad
\textbf{(E)}\ 3$ -/
theorem amc12a_2009_p9 (a b c : ℝ) (f : ℝ → ℝ) (h₀ : ∀ x, f (x + 3) = 3 * x ^ 2 + 7 * x + 4)
    (h₁ : ∀ x, f x = a * x ^ 2 + b * x + c) : a + b + c = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
