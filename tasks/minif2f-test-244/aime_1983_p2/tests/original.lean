import Mathlib

open scoped Nat
open scoped Real

/--
Let $f(x) = |x - p| + |x - 15| + |x - p - 15|$, where $0 < p < 15$.  Determine the minimum value taken by $f(x)$ for $x$ in the interval $p \le x \le 15$.
-/
theorem aime_1983_p2 (p : ℝ) (f : ℝ → ℝ) (h₀ : 0 < p ∧ p < 15)
    (h₂ : ∀ x, f x = abs (x - p) + abs (x - 15) + abs (x - p - 15)) : IsLeast (f '' Set.Icc p 15) 15 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
