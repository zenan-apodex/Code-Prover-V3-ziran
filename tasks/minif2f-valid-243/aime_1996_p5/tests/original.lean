import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Suppose that the roots of $x^3+3x^2+4x-11=0$ are $a, b,$ and $c,$ and that the roots of $x^3+rx^2+sx+t=0$ are $a+b, b+c,$ and $c+a.$  Find $t.$ -/
theorem aime_1996_p5 (a b c r s t : ℂ) (f g : ℂ → ℂ)
    (h₀ : ∀ x, f x = x ^ 3 + 3 * x ^ 2 + 4 * x - 11) (h₁ : ∀ x, g x = x ^ 3 + r * x ^ 2 + s * x + t)
    (h₂ : f ⁻¹' {0} = {a, b, c}) (h₃ : g ⁻¹' {0} = {a + b, b + c, c + a}) : t = (23) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
