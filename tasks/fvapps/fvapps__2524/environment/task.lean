import Mathlib

def find_length_of_lcis (nums : List Int) : Nat := sorry

theorem lcis_length_properties (nums : List Int) : 
  let result := find_length_of_lcis nums
  result ≥ 0 ∧ 
  result ≤ nums.length ∧
  (nums.length = 0 → result = 0) ∧ 
  (nums.length > 0 → result ≥ 1) := sorry

def is_strictly_increasing (nums : List Int) (i : Nat) : Bool :=
  i > 0 && i < nums.length && nums[i]! > nums[i-1]!

def count_max_increasing (nums : List Int) : Nat := sorry
