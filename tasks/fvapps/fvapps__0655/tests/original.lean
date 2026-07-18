import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + sum xs

def find_deleted_value (n k v : Nat) (arr : List Nat) : Int :=
sorry

theorem find_deleted_value_output_valid {n k v : Nat} {arr : List Nat} :
  let result := find_deleted_value n k v arr
  result = -1 ∨ result > 0 :=
sorry
