import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that the expressions $2er + e^2 + r^2$ and $(-r + -e)^2$ are equal to each other. -/
theorem algebra_manipexpr_2erprsqpesqeqnrpnesq (e r : ℂ) :
    2 * (e * r) + (e ^ 2 + r ^ 2) = (-r + -e) ^ 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
