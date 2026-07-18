import Mathlib

def index (arr : List Int) (n : Nat) : Int := sorry

theorem index_valid_index {arr : List Int} {n : Nat} (h : n < arr.length) :
  index arr n = (arr.get ⟨n, h⟩) ^ n := sorry

theorem index_invalid_index {arr : List Int} {n : Nat} (h : n ≥ arr.length) :
  index arr n = -1 := sorry

theorem index_empty_array {n : Nat} :
  index [] n = -1 := sorry
