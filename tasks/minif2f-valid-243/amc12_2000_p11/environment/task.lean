import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Two non-zero real numbers, $ a$ and $ b,$ satisfy $ ab ={} a -{} b$. Which of the following is a possible value of $ \frac {a}{b} +{} \frac {b}{a} -{} ab$?

$ \textbf{(A)}-{}\!2 \qquad \textbf{(B)}-{}\!\frac {1}{2} \qquad \textbf{(C)}\ \frac {1}{3} \qquad \textbf{(D)}\ \frac {1}{2} \qquad \textbf{(E)}\ 2$ -/
theorem amc12_2000_p11 (a b : ℝ) (h₀ : a ≠ 0 ∧ b ≠ 0) (h₁ : a * b = a - b) :
    a / b + b / a - a * b = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
