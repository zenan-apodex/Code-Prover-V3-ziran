import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
If $ x$ and $ y$ are positive integers for which $ 2^x3^y ={} 1296$, what is the value of $ x+{}y$?

$ \textbf{(A)}\ 8\qquad
\textbf{(B)}\ 9\qquad
\textbf{(C)}\ 10\qquad
\textbf{(D)}\ 11\qquad
\textbf{(E)}\ 12$ -/
theorem amc12b_2004_p3 (x y : ℕ) (h₀ : 2 ^ x * 3 ^ y = 1296) : x + y = (8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
