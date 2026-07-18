import Mathlib

open scoped Nat
open scoped Real

/--
Determine all real numbers $x$ which satisfy the inequality: \[ \sqrt{3-x}-\sqrt{x+1}>\dfrac{1}{2} \]
-/
theorem imo_1962_p2 :
    {x : ℝ | 0 ≤ 3 - x ∧ 0 ≤ x + 1 ∧ 1 / 2 < Real.sqrt (3 - x) - Real.sqrt (x + 1)} =
      Set.Ico (-1) (1 - Real.sqrt 31 / 8) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
