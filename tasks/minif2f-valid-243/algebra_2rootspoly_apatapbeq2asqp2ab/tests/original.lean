import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Show that $(a + a) * (a + b) = 2 * a ^ 2 + 2 * (a * b).$ -/
theorem algebra_2rootspoly_apatapbeq2asqp2ab (a b : ℂ) :
    (a + a) * (a + b) = 2 * a ^ 2 + 2 * (a * b) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
