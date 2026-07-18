import Mathlib

def List.maximum! : List Nat → Nat 
  | [] => 0
  | [x] => x
  | (x::xs) => max x (maximum! xs)

def obtain_max_number (arr : List Nat) : Nat := sorry

def count_pairs (arr : List Nat) : Nat := sorry









theorem obtain_max_number_twos {n : Nat} (h : n ≥ 1) :
  let arr := List.replicate n 2
  let result := obtain_max_number arr
  result > 0 ∧ result &&& (result - 1) = 0 :=
sorry
