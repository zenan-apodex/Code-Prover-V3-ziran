import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $x=\frac{\displaystyle\sum_{n=1}^{44} \cos n^\circ}{\displaystyle \sum_{n=1}^{44} \sin n^\circ}.$  What is the greatest integer that does not exceed $100x$? -/
theorem aime_1997_p11 (x : ℝ)
    (h₀ : x = (∑ n ∈ Finset.Icc (1 : ℕ) 44, Real.cos (n * π / 180)) /
      ∑ n ∈ Finset.Icc (1 : ℕ) 44, Real.sin (n * π / 180)) :
    Int.floor (100 * x) = (241) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
