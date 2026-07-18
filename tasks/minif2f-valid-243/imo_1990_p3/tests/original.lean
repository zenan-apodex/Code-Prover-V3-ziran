import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Determine all integers $ n > 1$ such that
\[ \frac {2^n +{} 1}{n^2}
\]
is an integer. -/
theorem imo_1990_p3 : {n : ℕ | 1 < n ∧ n ^ 2 ∣ 2 ^ n + 1} = ({3}) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
