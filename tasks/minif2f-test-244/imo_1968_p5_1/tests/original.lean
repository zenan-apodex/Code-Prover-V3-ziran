import Mathlib

open scoped Nat
open scoped Real

/--
Let $f$ be a real-valued function defined for all real numbers, such that for some $a>0$ we have \[ f(x+a)={1\over2}+\sqrt{f(x)-f(x)^2} \] for all $x$.
Prove that $f$ is periodic, and give an example of such a non-constant $f$ for $a=1$.
-/
theorem imo_1968_p5_1 (a : ℝ) (f : ℝ → ℝ) (h₀ : 0 < a)
    (h₁ : ∀ x, f (x + a) = 1 / 2 + Real.sqrt (f x - f x ^ 2)) : ∃ b > 0, ∀ x, f (x + b) = f x := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
