import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Let $ k={}2008^2+{}2^{2008}$. What is the units digit of $ k^2+{}2^k$?

$ \textbf{(A)}\ 0 \qquad
\textbf{(B)}\ 2 \qquad
\textbf{(C)}\ 4 \qquad
\textbf{(D)}\ 6 \qquad
\textbf{(E)}\ 8$ -/
theorem amc12a_2008_p15 (k : ℕ) (h₀ : k = 2008 ^ 2 + 2 ^ 2008) : (k ^ 2 + 2 ^ k) % 10 = (6) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
