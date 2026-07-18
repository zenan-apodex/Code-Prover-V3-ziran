import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the reciprocal of $ \frac{1}{2}+{}\frac{2}{3}$?

$ \textbf{(A)}\ \frac{6}{7} \qquad
\textbf{(B)}\ \frac{7}{6} \qquad
\textbf{(C)}\ \frac{5}{3} \qquad
\textbf{(D)}\ 3 \qquad
\textbf{(E)}\ \frac{7}{2}$ -/
theorem amc12a_2008_p2 (x : ℝ) (h₀ : x * (1 / 2 + 2 / 3) = 1) : x = (6 / 7) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
