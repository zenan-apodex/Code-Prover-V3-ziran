import Mathlib

structure LCG where
  seed : Nat

/-- LCG random function returns a value between 0 and 1 -/
def LCG.random (self : LCG) : Float := sorry

theorem lcg_output_range (seed : Nat) (h : seed ≤ 9) :
  let lcg := LCG.mk seed
  let result := lcg.random
  0 ≤ result ∧ result ≤ 1 := sorry

theorem lcg_deterministic (seed : Nat) (h : seed ≤ 9) :
  let lcg1 := LCG.mk seed
  let lcg2 := LCG.mk seed
  lcg1.random = lcg2.random := sorry

theorem lcg_decimal_output (seed : Nat) (h : seed ≤ 9) :
  let lcg := LCG.mk seed
  let result := lcg.random
  Float.round (result * 10) = result * 10 := sorry

theorem lcg_period :
  ∀ (s : Nat), ∃ (n : Nat), n ≤ 10 ∧
  (let lcg := LCG.mk s
   let seq := List.range n |>.map (λ _ => lcg.random)
   ∃ (i j : Nat), i < j ∧ j < seq.length ∧ 
   seq.get ⟨i, by sorry⟩ = seq.get ⟨j, by sorry⟩) := sorry
