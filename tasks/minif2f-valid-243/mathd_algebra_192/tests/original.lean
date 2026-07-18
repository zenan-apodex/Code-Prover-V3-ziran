import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- If $Q = 11-5i$, $E = 11+5i$, and $D = 2i$, find $Q\cdot E \cdot D$. -/
theorem mathd_algebra_192 (q e d : ℂ) (h₀ : q = 11 - 5 * Complex.I) (h₁ : e = 11 + 5 * Complex.I)
    (h₂ : d = 2 * Complex.I) : q * e * d = (292 * Complex.I) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
