import Mathlib

open scoped Nat
open scoped Real

/--
For what values of the variable $x$ does the following inequality hold: \[ \dfrac{4x^2}{(1-\sqrt{2x+1})^2}< 2x+9 \ ?  \]
-/
theorem imo_1960_p2 :
    { x : ℝ |
      0 ≤ 1 + 2 * x ∧ (1 - Real.sqrt (1 + 2 * x)) ^ 2 ≠ 0 ∧
      4 * x ^ 2 / (1 - Real.sqrt (1 + 2 * x)) ^ 2 < 2 * x + 9 } = Set.Ico (-(1 / 2)) (45 / 8) \ {0} := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
