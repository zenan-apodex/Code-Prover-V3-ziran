import Mathlib

def lamps (a: List Nat) : Nat := sorry

theorem lamps_result_bounded (a: List Nat) : 
  lamps a ≤ a.length ∧ 0 ≤ lamps a := sorry



theorem lamps_alternating_sequence (a: List Nat) (h: a.length > 0) :
  lamps ((List.range a.length).map (fun i => i % 2)) = 0 := sorry
