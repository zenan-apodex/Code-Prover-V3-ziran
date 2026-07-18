import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Which of the following is equal to the product
\[ \frac {8}{4}\cdot\frac {12}{8}\cdot\frac {16}{12}\cdots\frac {4n +{} 4}{4n}\cdots\frac {2008}{2004}?
\]$ \textbf{(A)}\ 251 \qquad \textbf{(B)}\ 502 \qquad \textbf{(C)}\ 1004 \qquad \textbf{(D)}\ 2008 \qquad \textbf{(E)}\ 4016$ -/
theorem amc12a_2008_p4 : ∏ k ∈ Finset.Icc (1 : ℕ) 501, ((4 : ℝ) * k + 4) / (4 * k) = (502) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
