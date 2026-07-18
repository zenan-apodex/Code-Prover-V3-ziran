import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Solve for $e$, given that $2d$ is $8$ less than $17e$, and $2e$ is $9$ less than $d$. -/
theorem mathd_algebra_119 (d e : ℝ) (h₀ : 2 * d = 17 * e - 8) (h₁ : 2 * e = d - 9) : e = (2) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
