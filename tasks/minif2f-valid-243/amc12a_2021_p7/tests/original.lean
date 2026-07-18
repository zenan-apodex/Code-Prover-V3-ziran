import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the least possible value of $(xy-1)^2+(x+y)^2$ for real numbers $x$ and $y$?

$\textbf{(A)}\ 0 \qquad\textbf{(B)}\ \frac14 \qquad\textbf{(C)}\ \frac12 \qquad\textbf{(D)}\ 1 \qquad\textbf{(E)}\ 2$ -/
theorem amc12a_2021_p7 : IsLeast {v : ℝ | ∃ x y : ℝ, (x * y - 1) ^ 2 + (x + y) ^ 2 = v} (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
