import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $ \log(xy^3)={}1$ and $ \log(x^2y)={}1$, what is $ \log(xy)$?

$ \textbf{(A)}\ -{}\!\frac{1}{2} \qquad
\textbf{(B)}\ 0 \qquad
\textbf{(C)}\ \frac{1}{2} \qquad
\textbf{(D)}\ \frac{3}{5} \qquad
\textbf{(E)}\ 1$ -/
theorem amc12b_2003_p17 (x y : ℝ) (h₀ : 0 < x ∧ 0 < y) (h₁ : Real.log (x * y ^ 3) = 1)
    (h₂ : Real.log (x ^ 2 * y) = 1) : Real.log (x * y) = (3 / 5) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
