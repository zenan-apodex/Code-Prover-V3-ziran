import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $ f(x)={}\sqrt{ax^2+{}bx}$. For how many real values of $ a$ is there at least one positive value of $ b$ for which the domain of $ f$ and the range of $ f$ are the same set?

$ \textbf{(A)}\ 0 \qquad
\textbf{(B)}\ 1 \qquad
\textbf{(C)}\ 2 \qquad
\textbf{(D)}\ 3 \qquad
\textbf{(E)}\ \text{infinitely many}$ -/
theorem amc12a_2003_p25 :
    {a : ℝ | ∃
      (b : ℝ) (f : ℝ → ℝ) (h₀ : 0 < b)
      (h₁ : ∀ x, f x = Real.sqrt (a * x ^ 2 + b * x)),
      {x | 0 ≤ a * x ^ 2 + b * x} = f '' {x | 0 ≤ a * x ^ 2 + b * x}}.encard = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
