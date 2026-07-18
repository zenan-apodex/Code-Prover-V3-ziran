import Mathlib

def stringContains (s1 s2 : String) : Bool := sorry

def actually_really_good (foods : List String) : String := sorry

theorem actually_really_good_prefix (foods : List String) :
  String.startsWith (actually_really_good foods) "You know what's actually really good? " := sorry

theorem actually_really_good_empty_list :
  actually_really_good [] = "You know what's actually really good? Nothing!" := sorry







theorem actually_really_good_handles_duplicates (food : String) :
  actually_really_good [food, food] = actually_really_good [food] := sorry
