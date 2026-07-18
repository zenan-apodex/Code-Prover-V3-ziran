import Mathlib

open scoped Nat
open scoped Real

/--
Two different positive numbers $ a$ and $ b$ each differ from their reciprocals by 1. What is $ a +{} b$?
\[ \textbf{(A) } 1 \qquad \textbf{(B) } 2 \qquad \textbf{(C) } \sqrt {5} \qquad \textbf{(D) } \sqrt {6} \qquad \textbf{(E) } 3
\]
-/
theorem amc12a_2002_p13 (a b : ℝ) (h₀ : 0 < a ∧ 0 < b) (h₁ : a ≠ b) (h₂ : abs (a - 1 / a) = 1)
    (h₃ : abs (b - 1 / b) = 1) : a + b = Real.sqrt 5 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
