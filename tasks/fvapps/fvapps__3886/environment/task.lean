import Mathlib

def is_prime (n : Nat) : Bool :=
  sorry

def total (arr : List Int) : Int :=
  sorry

def sqrt (n : Nat) : Nat :=
  sorry



theorem total_empty_property (arr : List Int) :
  arr = [] → total arr = 0 :=
sorry

theorem total_properties (arr : List Int) :
  total arr = (List.enum arr).foldl (fun acc (i, x) => if is_prime i then acc + x else acc) 0 :=
sorry

theorem total_sign (arr : List Int) :
  total arr ≥ 0 ∨ ∃ x ∈ arr, x < 0 :=
sorry
