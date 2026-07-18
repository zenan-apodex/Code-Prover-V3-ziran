import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $ |x -{} 2| ={} p$, where $ x < 2$, then $ x -{} p ={}$

$ \textbf{(A)}-{}\!2 \qquad \textbf{(B)}\  2 \qquad \textbf{(C)}\  2 -{} 2p \qquad \textbf{(D)}\  2p -{} 2\qquad \textbf{(E)}\ |2p -{} 2|$ -/
theorem amc12_2000_p5 (x p : ℝ) (h₀ : x < 2) (h₁ : abs (x - 2) = p) : x - p = (2 - 2 * p) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
