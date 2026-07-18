import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Together, Larry and Lenny have $\$$35. Larry has two-fifths of Lenny's amount. How many more dollars than Larry does Lenny have? -/
theorem mathd_algebra_51 (a b : ℝ) (h₀ : 0 < a ∧ 0 < b) (h₁ : a + b = 35) (h₂ : a = 2 / 5 * b) :
    b - a = (15) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
