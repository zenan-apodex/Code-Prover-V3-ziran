import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Prove that there is no function $f$ from the set of non-negative integers into itself such that $f(f(n))=n+1987$ for all $n$. -/
theorem imo_1987_p4 (f : ℕ → ℕ) : ∃ n, f (f n) ≠ n + 1987 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
