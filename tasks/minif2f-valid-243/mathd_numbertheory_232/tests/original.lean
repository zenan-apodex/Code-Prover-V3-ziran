import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Compute $(3^{-1}+5^{-1})^{-1}\pmod{31}$. Express your answer as an integer from $0$ to $30$, inclusive. -/
theorem mathd_numbertheory_232 (x y z : ZMod 31) (h₀ : x = 3⁻¹) (h₁ : y = 5⁻¹)
    (h₂ : z = (x + y)⁻¹) : z = (29) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
