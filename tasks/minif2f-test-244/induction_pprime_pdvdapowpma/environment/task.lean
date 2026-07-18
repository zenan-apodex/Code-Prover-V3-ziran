import Mathlib

open scoped Nat
open scoped Real

theorem induction_pprime_pdvdapowpma (p a : ℕ) (h₀ : 0 < a) (h₁ : Nat.Prime p) : p ∣ a ^ p - a := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
