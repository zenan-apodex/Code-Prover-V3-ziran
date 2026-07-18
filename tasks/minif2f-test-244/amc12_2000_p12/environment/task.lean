import Mathlib

open scoped Nat
open scoped Real

/--
Let $ A$, $ M$, and $ C$ be nonnegative integers such that $ A +{} M +{} C ={} 12$. What is the maximum value of $ A \cdot M \cdot C +{} A\cdot M +{} M \cdot C +{} C\cdot A$?

$ \textbf{(A)}\ 62 \qquad \textbf{(B)}\ 72 \qquad \textbf{(C)}\ 92 \qquad \textbf{(D)}\ 102 \qquad \textbf{(E)}\ 112$
-/
theorem amc12_2000_p12 :
    IsGreatest
      {(a*m*c + a*m + m*c + a*c) | (a : ℕ) (m : ℕ) (c : ℕ) (h₀ : a + m + c = 12)}
      112 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
