import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Determine the least real number $M$ such that the inequality \[|ab(a^{2}-b^{2})+bc(b^{2}-c^{2})+ca(c^{2}-a^{2})| \leq M(a^{2}+b^{2}+c^{2})^{2}\] holds for all real numbers $a$, $b$ and $c$. -/
theorem imo_2006_p3 :
    IsLeast {M : ℝ | ∀ a b c : ℝ,
      abs (a * b * (a ^ 2 - b ^ 2) + b * c * (b ^ 2 - c ^ 2) + c * a * (c ^ 2 - a ^ 2)) ≤
        M * (a ^ 2 + b ^ 2 + c ^ 2) ^ 2}
      (9 * Real.sqrt 2 / 32) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
