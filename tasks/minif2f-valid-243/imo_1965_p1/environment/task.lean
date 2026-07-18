import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Determine all values of $x$ in the interval $0 \leq x \leq 2\pi$ which satisfy the inequality \[ 2 \cos{x} \leq \sqrt{1+\sin{2x}}-\sqrt{1-\sin{2x}} \leq \sqrt{2}.  \] -/
theorem imo_1965_p1 :
    {x : ℝ | 0 ≤ x ∧ x ≤ 2 * π ∧ 2 * Real.cos x ≤
      abs (Real.sqrt (1 + Real.sin (2 * x)) - Real.sqrt (1 - Real.sin (2 * x))) ∧
      abs (Real.sqrt (1 + Real.sin (2 * x)) - Real.sqrt (1 - Real.sin (2 * x))) ≤ Real.sqrt 2} =
    (Set.Icc (π / 4) (7 * π / 4)) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
