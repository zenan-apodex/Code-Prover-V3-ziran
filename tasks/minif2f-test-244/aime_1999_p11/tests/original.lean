import Mathlib

open scoped Nat
open scoped Real

/--
Given that $\sum_{k=1}^{35}\sin 5k=\tan \frac mn,$ where angles are measured in degrees, and $m$ and $n$ are relatively prime positive integers that satisfy $\frac mn< 90,$ find $m+n.$
-/
theorem aime_1999_p11 (m : ℚ) (h₀ : 0 < m)
    (h₁ : ∑ k ∈ Finset.Icc (1 : ℕ) 35, Real.sin (5 * k * π / 180) = Real.tan (m * π / 180))
    (h₂ : (m.num : ℝ) / m.den < 90) : ↑m.den + m.num = 177 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
