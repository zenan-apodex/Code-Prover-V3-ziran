import Mathlib

def List.sum (l: List Nat) : Nat :=
  match l with
  | [] => 0
  | x::xs => x + List.sum xs

def makesquare (nums: List Nat) : Bool :=
  sorry

theorem makesquare_min_length 
  (nums: List Nat) (h: nums.length < 4) : 
  makesquare nums = false := 
  sorry

theorem makesquare_sum_not_div_four
  (nums: List Nat) (h: (List.sum nums % 4) ≠ 0) :
  makesquare nums = false := 
  sorry

theorem makesquare_element_too_large 
  (nums: List Nat) (h: ∃ x ∈ nums, x > List.sum nums / 4) :
  makesquare nums = false :=
  sorry

theorem makesquare_equal_elements 
  (n: Nat) (nums: List Nat) 
  (h1: nums.length % 4 = 0)
  (h2: ∀ x ∈ nums, x = n) :
  makesquare nums = true :=
  sorry 

theorem makesquare_identical_elements
  (n: Nat) :
  makesquare [n,n,n,n] = true :=
  sorry
