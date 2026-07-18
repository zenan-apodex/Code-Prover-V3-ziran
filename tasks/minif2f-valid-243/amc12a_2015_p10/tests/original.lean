import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Integers $x$ and $y$ with $x>y>0$ satisfy $x+y+xy=80$.  What is $x$?

$\textbf{(A) }8\qquad\textbf{(B) }10\qquad\textbf{(C) }15\qquad\textbf{(D) }18\qquad\textbf{(E) }26$ -/
theorem amc12a_2015_p10 (x y : ℤ) (h₀ : 0 < y) (h₁ : y < x) (h₂ : x + y + x * y = 80) : x = (26) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
