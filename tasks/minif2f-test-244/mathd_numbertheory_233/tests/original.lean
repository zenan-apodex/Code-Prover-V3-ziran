import Mathlib

open scoped Nat
open scoped Real

/--
Find $24^{-1} \pmod{11^2}$. That is, find the residue $b$ for which $24b \equiv 1\pmod{11^2}$.

Express your answer as an integer from $0$ to $11^2-1$, inclusive.
-/
theorem mathd_numbertheory_233 (b : ZMod (11 ^ 2)) (h₀ : b = 24⁻¹) : b = 116 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
