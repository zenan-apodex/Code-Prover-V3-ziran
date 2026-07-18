import Mathlib

def bulbSwitch (n : Int) : Int :=
  sorry

theorem bulb_switch_nonnegative (n : Int) (h : n ≥ 0) : 
  let result := bulbSwitch n
  result ≥ 0 ∧ result ≤ n :=
  sorry

theorem bulb_switch_negative (n : Int) (h : n < 0) :
  bulbSwitch n = -1 :=
  sorry

theorem bulb_switch_zero :
  bulbSwitch 0 = 0 :=
  sorry
