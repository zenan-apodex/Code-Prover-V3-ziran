import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
The first four terms of an arithmetic sequence are $ p,9,3p-{}q,$ and $ 3p+{}q$. What is the $ 2010^{\text{th}}$ term of the sequence?

$ \textbf{(A)}\ 8041\qquad \textbf{(B)}\ 8043\qquad \textbf{(C)}\ 8045\qquad \textbf{(D)}\ 8047\qquad \textbf{(E)}\ 8049$ -/
theorem amc12a_2010_p10 (p q : ℝ) (a : ℕ → ℝ) (h₀ : ∀ n, a (n + 2) - a (n + 1) = a (n + 1) - a n)
    (h₁ : a 1 = p) (h₂ : a 2 = 9) (h₃ : a 3 = 3 * p - q) (h₄ : a 4 = 3 * p + q) : a 2010 = (8041) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
