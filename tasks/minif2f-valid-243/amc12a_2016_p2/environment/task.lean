import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For what value of $x$ does $10^{x}\cdot 100^{2x}=1000^{5}$?

$\textbf{(A)}\ 1 \qquad\textbf{(B)}\ 2\qquad\textbf{(C)}\ 3\qquad\textbf{(D)}\ 4\qquad\textbf{(E)}\ 5$ -/
theorem amc12a_2016_p2 (x : ℝ) (h₀ : (10 : ℝ) ^ x * 100 ^ (2 * x) = 1000 ^ 5) : x = (3) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
