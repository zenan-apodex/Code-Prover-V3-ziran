import Mathlib

def sum (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | x::xs => x + sum xs

def save (sizes : List Nat) (hd : Nat) : Nat :=
  sorry

theorem save_valid_result_range (sizes : List Nat) (hd : Nat) (h : sizes.length > 0) :
  let result := save sizes hd
  0 ≤ result ∧ result ≤ sizes.length :=
sorry
