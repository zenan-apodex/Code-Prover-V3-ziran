import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
For what values of $x$ is it true that $x^2 - 5x - 4 \le 10$? Express your answer in interval notation. -/
theorem mathd_algebra_101 :
    {x : ℝ | x ^ 2 - 5 * x - 4 ≤ 10} = (Set.Icc (-2) 7) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
