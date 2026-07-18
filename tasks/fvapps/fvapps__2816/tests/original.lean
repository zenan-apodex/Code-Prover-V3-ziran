import Mathlib

def calculate (s : String) : String := sorry

theorem calculate_plus_list (nums : List Int) (h : nums ≠ []) : 
  toString (nums.foldl Int.add 0) = 
  calculate (String.intercalate "plus" (nums.map toString)) :=
sorry
