import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- What is the digit in the hundredths place of the decimal equivalent of $\frac{9}{160}$? -/
theorem mathd_numbertheory_84 : Int.floor ((9 : ℝ) / 160 * 100) = (5) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
