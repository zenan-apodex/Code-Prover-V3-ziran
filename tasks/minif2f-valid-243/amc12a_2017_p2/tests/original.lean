import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The sum of two nonzero real numbers is $4$ times their product. What is the sum of the reciprocals of the two numbers?

$\textbf{(A)}\ 1\qquad\textbf{(B)}\ 2\qquad\textbf{(C)}\ 4\qquad\textbf{(D)}\ 8\qquad\textbf{(E)}\ 12$ -/
theorem amc12a_2017_p2 (x y : ℝ) (h₀ : x ≠ 0) (h₁ : y ≠ 0) (h₂ : x + y = 4 * (x * y)) :
    1 / x + 1 / y = (4) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
