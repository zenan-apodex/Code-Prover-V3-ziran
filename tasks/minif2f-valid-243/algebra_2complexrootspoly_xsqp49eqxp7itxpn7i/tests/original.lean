import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Factorize $x^2+49$ over the complex numbers.
Show that the answer is $(x+7i)(x-7i)$. -/
theorem algebra_2complexrootspoly_xsqp49eqxp7itxpn7i (x : ℂ) :
    x ^ 2 + 49 = (x + 7 * Complex.I) * (x + -7 * Complex.I) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
