import Mathlib

open scoped Nat
open scoped Real

/--
Four positive integers $ a,b,c,$ and $ d$ have a product of 8! and satisfy\begin{align*}ab +{} a +{} b &={} 524\\
bc +{} b +{} c &={} 146\\
cd +{} c +{} d &={} 104.\end{align*} What is $ a -{} d$?

$ \textbf{(A)} \ 4 \qquad \textbf{(B)} \ 6 \qquad \textbf{(C)} \ 8 \qquad \textbf{(D)} \ 10 \qquad \textbf{(E)} \ 12$
-/
theorem amc12_2001_p21 (a b c d : ℕ) (h₀ : a * b * c * d = 8!) (h₁ : a * b + a + b = 524)
    (h₂ : b * c + b + c = 146) (h₃ : c * d + c + d = 104) : ↑a - ↑d = (10 : ℤ) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
