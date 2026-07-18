import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
What is the minimum value of $ f(x) ={} |x -{} 1| +{} |2x -{} 1| +{} |3x -{} 1| +{} \cdots +{} |119x -{} 1|$?

$ \textbf{(A)}\ 49 \qquad
\textbf{(B)}\ 50 \qquad
\textbf{(C)}\ 51 \qquad
\textbf{(D)}\ 52 \qquad
\textbf{(E)}\ 53$ -/
theorem amc12a_2010_p22 :
    IsLeast { ∑ k ∈ Finset.Icc 1 119, abs ((k : ℕ) * x - 1) | (x : ℝ)} (49) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
