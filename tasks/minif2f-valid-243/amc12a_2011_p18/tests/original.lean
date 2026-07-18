import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Suppose that $|x+y|+|x-y|=2$. What is the maximum possible value of $x^2-6x+y^2$?


 $ \textbf{(A)}\ 5 \qquad
\textbf{(B)}\ 6 \qquad
\textbf{(C)}\ 7 \qquad
\textbf{(D)}\ 8 \qquad
\textbf{(E)}\ 9
$ -/
theorem amc12a_2011_p18 :
    IsGreatest
      { x^2 - 6 * x + y^2 | (x : ℝ) (y : ℝ) (h₀ : abs (x + y) + abs (x - y) = 2)}
      (8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
