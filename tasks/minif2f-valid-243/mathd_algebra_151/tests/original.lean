import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- Evaluate $\left\lceil\sqrt{27}\right\rceil - \left\lfloor\sqrt{26}\right\rfloor$. -/
theorem mathd_algebra_151 : Int.ceil (Real.sqrt 27) - Int.floor (Real.sqrt 26) = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
