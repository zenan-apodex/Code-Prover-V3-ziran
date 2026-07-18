import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $n^2$ is less than $n!$ (factorial) for all natural numbers $n \ge 4$. -/
theorem induction_ineq_nsqlefactn (n : ℕ) (h₀ : 4 ≤ n) : n ^ 2 ≤ n ! := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
