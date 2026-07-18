import Mathlib

open scoped Nat
open scoped Real

/--
What is the product of the real roots of the equation \[x^2 + 18x + 30 = 2 \sqrt{x^2 + 18x + 45}\,\,?\]
-/
theorem aime_1983_p3 (f : ℝ → ℝ)
    (h₀ : ∀ x, f x = x ^ 2 + (18 * x + 30) - 2 * Real.sqrt (x ^ 2 + (18 * x + 45)))
    (h₁ : Fintype (f ⁻¹' {0})) : ∏ x ∈ (f ⁻¹' {0}).toFinset, x = 20 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
