import Mathlib

def sum_list : List Nat → Nat
  | [] => 0
  | x::xs => x + sum_list xs

def lost_sheep (friday : List Nat) (saturday : List Nat) (total : Nat) : Nat :=
sorry





theorem lost_sheep_reverse_invariant (friday : List Nat) (saturday : List Nat) (total : Nat) :
  lost_sheep friday saturday total = lost_sheep friday.reverse saturday.reverse total :=
sorry

theorem lost_sheep_empty_lists (total : Nat) :
  lost_sheep [] [] total = total :=
sorry
