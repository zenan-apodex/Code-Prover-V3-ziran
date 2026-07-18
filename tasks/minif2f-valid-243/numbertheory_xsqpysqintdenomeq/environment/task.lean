import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that if the squares of two rational numbers sum to an integer, then their denominators must be equal, when expressed in lowest terms. -/
theorem numbertheory_xsqpysqintdenomeq (x y : ℚ) (h₀ : (x ^ 2 + y ^ 2).den = 1) : x.den = y.den := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
