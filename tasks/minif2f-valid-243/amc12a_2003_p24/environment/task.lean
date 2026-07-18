import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $ a\ge b>1$, what is the largest possible value of $ \log_a(a/b)+{}\log_b(b/a)$?

$ \textbf{(A)}\ -{}2 \qquad
\textbf{(B)}\ 0 \qquad
\textbf{(C)}\ 2 \qquad
\textbf{(D)}\ 3 \qquad
\textbf{(E)}\ 4$ -/
theorem amc12a_2003_p24 :
    IsGreatest {y : ℝ | ∃ a b : ℝ, 1 < b ∧ b ≤ a ∧ y = Real.logb a (a / b) + Real.logb b (b / a)}
      (0) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
