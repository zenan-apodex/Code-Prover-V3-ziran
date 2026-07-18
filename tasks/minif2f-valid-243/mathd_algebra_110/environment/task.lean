import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Simplify $(2-2i)(5+5i)$, where $i^2 = -1.$ -/
theorem mathd_algebra_110 (q e : ℂ) (h₀ : q = 2 - 2 * Complex.I) (h₁ : e = 5 + 5 * Complex.I) :
    q * e = (20) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
