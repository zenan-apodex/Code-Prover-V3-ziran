import Mathlib

open scoped Nat
open scoped Real

/--
If $ x$, $ y$, and $ z$ are positive numbers satisfying \[x +{} 1/y ={} 4,\quad  y +{} 1/z ={} 1,\quad\text{and}\quad z +{} 1/x ={} 7/3,\] then $ xyz ={}$

$ \textbf{(A)}\ 2/3 \qquad \textbf{(B)}\ 1 \qquad \textbf{(C)}\ 4/3 \qquad \textbf{(D)}\ 2 \qquad \textbf{(E)}\ 7/3$
-/
theorem amc12_2000_p20 (x y z : ℝ) (h₀ : 0 < x ∧ 0 < y ∧ 0 < z) (h₁ : x + 1 / y = 4)
    (h₂ : y + 1 / z = 1) (h₃ : z + 1 / x = 7 / 3) : x * y * z = 1 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
