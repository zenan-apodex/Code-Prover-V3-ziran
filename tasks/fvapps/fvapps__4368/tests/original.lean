import Mathlib

def ceil (x : Int) : Int := sorry

def cost (mins: Int) : Int := sorry

theorem cost_minimum_30 (mins: Nat) : 
  cost mins ≥ 30 := sorry

theorem cost_base_rate (mins: Nat) (h: mins ≤ 65) : 
  cost mins = 30 := sorry

theorem cost_negative_zero (mins: Int) :
  mins < 0 → cost mins = cost 0 := sorry



theorem cost_stepwise_increase (mins: Nat) (h: 66 ≤ mins) :
  cost (mins - 1) ≤ cost mins ∧ cost mins - cost (mins - 1) ≤ 10 := sorry
