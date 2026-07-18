import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x :: xs) => x + sum xs

def house_numbers_sum (nums : List Nat) : Nat := sorry

theorem house_numbers_sum_non_negative {nums : List Nat} (h : 0 ∈ nums) :
  house_numbers_sum nums ≥ 0 := sorry



theorem house_numbers_sum_ignore_after_zero {nums modified : List Nat} 
  (h : 0 ∈ nums)
  (h2 : modified.take (nums.indexOf 0 + 1) = nums.take (nums.indexOf 0 + 1)) :
  house_numbers_sum modified = house_numbers_sum nums := sorry

theorem house_numbers_sum_ones (n : Nat) :
  house_numbers_sum (List.replicate n 1 ++ [0]) = n := sorry

theorem house_numbers_sum_zero :
  house_numbers_sum [0] = 0 := sorry

theorem house_numbers_sum_zero_prefix :
  house_numbers_sum [0, 1, 2, 3] = 0 := sorry
