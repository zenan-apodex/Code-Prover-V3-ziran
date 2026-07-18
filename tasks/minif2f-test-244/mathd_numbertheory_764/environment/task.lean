import Mathlib

open scoped Nat
open scoped Real

/--
Given that $p\ge 7$ is a prime number, evaluate $$1^{-1} \cdot 2^{-1} + 2^{-1} \cdot 3^{-1} + 3^{-1} \cdot 4^{-1} + \cdots + (p-2)^{-1} \cdot (p-1)^{-1} \pmod{p}.$$
-/
theorem mathd_numbertheory_764 (p : ℕ) (h₀ : Nat.Prime p) (h₁ : 7 ≤ p) :
    ∑ k ∈ Finset.Icc 1 (p - 2), (k : ZMod p)⁻¹ * ((k : ZMod p) + 1)⁻¹ = 2 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
