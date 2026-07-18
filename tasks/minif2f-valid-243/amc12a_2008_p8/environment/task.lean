import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the volume of a cube whose surface area is twice that of a cube with volume $ 1$?

$ \textbf{(A)}\ \sqrt{2} \qquad
\textbf{(B)}\ 2 \qquad
\textbf{(C)}\ 2\sqrt{2} \qquad
\textbf{(D)}\ 4 \qquad
\textbf{(E)}\ 8$ -/
theorem amc12a_2008_p8 (x y : ℝ) (h₀ : 0 < x ∧ 0 < y) (h₁ : y ^ 3 = 1)
    (h₂ : 6 * x ^ 2 = 2 * (6 * y ^ 2)) : x ^ 3 = (2 * Real.sqrt 2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
