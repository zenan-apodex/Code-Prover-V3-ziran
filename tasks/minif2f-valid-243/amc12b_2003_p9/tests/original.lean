import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $ f$ be a linear function for which $ f(6)-{}f(2)={}12$. What is $ f(12)-{}f(2)$?

$ \textbf{(A)}\ 12 \qquad
\textbf{(B)}\ 18 \qquad
\textbf{(C)}\ 24 \qquad
\textbf{(D)}\ 30 \qquad
\textbf{(E)}\ 36$ -/
theorem amc12b_2003_p9 (a b : ℝ) (f : ℝ → ℝ) (h₀ : ∀ x, f x = a * x + b) (h₁ : f 6 - f 2 = 12) :
    f 12 - f 2 = (30) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
