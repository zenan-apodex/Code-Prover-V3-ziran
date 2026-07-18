import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | h::t => h + sum t

def solution (nums: List Nat) : Nat :=
  sorry



theorem solution_divisible_by_length (nums: List Nat) (h: nums.length > 0) :
  solution nums % nums.length = 0 :=
sorry



theorem solution_gcd_divides_all (nums: List Nat) (h: nums.length > 0) :
  ∀ n ∈ nums, n % (solution nums / nums.length) = 0 :=
sorry

theorem solution_identical_elements (n: Nat) (len: Nat) (h: len > 0) :
  solution (List.replicate len n) = n * len :=
sorry

theorem solution_single_element (n: Nat) :
  solution [n] = n :=
sorry
