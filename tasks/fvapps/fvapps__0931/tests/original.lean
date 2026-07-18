import Mathlib

def sum_list : List Nat → Nat 
  | [] => 0
  | (h :: t) => h + sum_list t

def calculate_damage (n : Nat) (items : List Nat) : Nat := sorry



theorem damage_non_negative {n : Nat} {items : List Nat} 
  (h : items.length > 0) :
  calculate_damage n items ≥ 0 := sorry
