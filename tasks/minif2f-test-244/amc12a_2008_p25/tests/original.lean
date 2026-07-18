import Mathlib

open scoped Nat
open scoped Real

/--
A sequence $ (a_1,b_1)$, $ (a_2,b_2)$, $ (a_3,b_3)$, $ \ldots$ of points in the coordinate plane satisfies \[ (a_{n +{} 1}, b_{n +{} 1}) ={} (\sqrt {3}a_n -{} b_n, \sqrt {3}b_n +{} a_n)\hspace{3ex}\text{for}\hspace{3ex}  n ={} 1,2,3,\ldots.\] Suppose that $ (a_{100},b_{100}) ={} (2,4)$.  What is $ a_1 +{} b_1$?

$ \textbf{(A)}\-{} \frac {1}{2^{97}}  \qquad
\textbf{(B)}\-{} \frac {1}{2^{99}} \qquad
\textbf{(C)}\ 0 \qquad
\textbf{(D)}\ \frac {1}{2^{98}}  \qquad
\textbf{(E)}\ \frac {1}{2^{96}}$
-/
theorem amc12a_2008_p25 (a b : ℕ → ℝ) (h₀ : ∀ n, a (n + 1) = Real.sqrt 3 * a n - b n)
    (h₁ : ∀ n, b (n + 1) = Real.sqrt 3 * b n + a n) (h₂ : a 100 = 2) (h₃ : b 100 = 4) :
    a 1 + b 1 = 1 / 2 ^ 98 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
