import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The sequence $S_1, S_2, S_3, \cdots, S_{10}$ has the property that every term beginning with the third is the sum of the previous two.  That is, \[ S_n = S_{n-2} + S_{n-1} \text{ for } n \ge 3. \] Suppose that $S_9 = 110$ and $S_7 = 42$.  What is $S_4$?

$ \textbf{(A)}\ 4\qquad\textbf{(B)}\ 6\qquad\textbf{(C)}\ 10\qquad\textbf{(D)}\ 12\qquad\textbf{(E)}\ 16\qquad $ -/
theorem amc12a_2013_p7 (s : ℕ → ℝ) (h₀ : ∀ n, s (n + 2) = s (n + 1) + s n) (h₁ : s 9 = 110)
    (h₂ : s 7 = 42) : s 4 = (10) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
