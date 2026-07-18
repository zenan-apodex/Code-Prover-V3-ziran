import Mathlib

def List.sum (l : List Nat) : Nat := sorry 

def List.maximum (l : List Nat) : Nat := sorry

def candies (arr : List Nat) : Int := sorry

theorem candies_valid_input {arr : List Nat} (h : arr.length ≥ 2) :
  candies arr ≥ 0 ∧ candies arr = arr.length * (List.maximum arr) - arr.sum := sorry

theorem candies_invalid_input {arr : List Nat} (h : arr.length ≤ 1) :
  candies arr = -1 := sorry

theorem candies_minimum_list :
  candies [1, 1] = 0 := sorry

theorem candies_result_formula {arr : List Nat} (h : arr.length ≥ 2) :
  candies arr = arr.length * (List.maximum arr) - arr.sum := sorry
