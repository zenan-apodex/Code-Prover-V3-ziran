import Mathlib

def min_cost_to_transform (s r : String) : Nat := sorry

def countDiffs (s r : String) : Nat := sorry







theorem cost_to_self (s : String) :
  min_cost_to_transform s s = 0 := sorry

theorem cost_symmetric (s r : String) :
  min_cost_to_transform s r = min_cost_to_transform r s := sorry
