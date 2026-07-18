import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose that $ a$ and $ b$ are are nonzero real numbers, and that the equation $ x^2+{}ax+{}b={}0$ has solutions $ a$ and $ b$. Then the pair $ (a,b)$ is

$ \textbf{(A)}\ (-{}2,1) \qquad
\textbf{(B)}\ (-{}1,2) \qquad
\textbf{(C)}\ (1,-{}2) \qquad
\textbf{(D)}\ (2,-{}1) \qquad
\textbf{(E)}\ (4,4)$ -/
theorem amc12b_2002_p6 (a b : ℝ) (h₀ : a ≠ 0 ∧ b ≠ 0)
    (h₁ : ∀ x, x ^ 2 + a * x + b = (x - a) * (x - b)) : (a, b) = ((1, -2)) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
