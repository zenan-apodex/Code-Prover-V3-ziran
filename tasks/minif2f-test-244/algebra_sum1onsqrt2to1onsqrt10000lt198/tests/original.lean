import Mathlib

open scoped Nat
open scoped Real

theorem algebra_sum1onsqrt2to1onsqrt10000lt198 :
    ∑ k ∈ Finset.Icc (2 : ℕ) 10000, 1 / Real.sqrt k < 198 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
