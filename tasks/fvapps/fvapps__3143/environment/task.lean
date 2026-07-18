import Mathlib

def int_to_word (n : Nat) : String := sorry

def sort_by_name (arr : List Nat) : List Nat := sorry 

theorem sort_by_name_length (arr : List Nat) :
  (sort_by_name arr).length = arr.length := sorry

theorem sort_by_name_permutation (arr : List Nat) :
  ∀ x, x ∈ arr ↔ x ∈ sort_by_name arr := sorry



theorem sort_by_name_idempotent (arr : List Nat) :
  sort_by_name (sort_by_name arr) = sort_by_name arr := sorry
