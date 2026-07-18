import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For positive real numbers $a$, $b$, and $c$, show that $\frac{a^2}{b^2}+\frac{b^2}{c^2}+\frac{c^2}{a^2}$ is at least $\frac{b}{a}+\frac{c}{b}+\frac{a}{c}$. -/
theorem algebra_amgm_sumasqdivbsqgeqsumbdiva (a b c : ℝ) (h₀ : 0 < a ∧ 0 < b ∧ 0 < c) :
    a ^ 2 / b ^ 2 + b ^ 2 / c ^ 2 + c ^ 2 / a ^ 2 ≥ b / a + c / b + a / c := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
