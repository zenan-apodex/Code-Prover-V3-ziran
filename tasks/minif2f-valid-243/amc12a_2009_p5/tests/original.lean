import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
One dimension of a cube is increased by $ 1$, another is decreased by $ 1$, and the third is left unchanged. The volume of the new rectangular solid is $ 5$ less than that of the cube. What was the volume of the cube?

$ \textbf{(A)}\ 8 \qquad
\textbf{(B)}\ 27 \qquad
\textbf{(C)}\ 64 \qquad
\textbf{(D)}\ 125 \qquad
\textbf{(E)}\ 216$ -/
theorem amc12a_2009_p5 (x : ℝ) (h₀ : x ^ 3 - (x + 1) * (x - 1) * x = 5) :
    x ^ 3 = (125) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
