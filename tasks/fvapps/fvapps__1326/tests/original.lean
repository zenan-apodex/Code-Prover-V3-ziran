import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + sum xs

def find_distance (n : Nat) (fuel : List Nat) : Nat :=
  sorry





theorem first_zero_distance_zero (n : Nat) (fuel : List Nat) (h : fuel.length > 0) :
  fuel.get ⟨0, h⟩ = 0 → find_distance n fuel = 0 :=
sorry



theorem all_zeros_distance_zero (n : Nat) :
  find_distance n (List.replicate n 0) = 0 :=
sorry

theorem single_nonzero_distance (n : Nat) (val : Nat) (h : n > 0) :
  find_distance n (val :: List.replicate (n-1) 0) = val :=
sorry
