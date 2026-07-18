import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + sum xs

def sum_from_string (s : String) : Nat :=
  sorry





theorem sum_single_number (n : Nat) :
  sum_from_string (toString n) = n :=
  sorry

theorem sum_empty_string :
  sum_from_string "" = 0 :=
  sorry
