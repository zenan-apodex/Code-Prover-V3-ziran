import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Given complex numbers $a$, $b$, and $c$, with $a+b=2c$ and $c=i$, prove that $ac + bc = -2$. -/
theorem algebra_manipexpr_apbeq2cceqiacpbceqm2 (a b c : ℂ) (h₀ : a + b = 2 * c)
    (h₁ : c = Complex.I) : a * c + b * c = -2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
