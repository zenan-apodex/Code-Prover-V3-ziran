import Mathlib

def List.sum (xs : List Int) : Int := 
  xs.foldl (· + ·) 0

def learn_charitable_game (arr : List Int) : Bool := sorry

theorem single_element_validity {n : Int} :
  learn_charitable_game [n] = (n > 0) := sorry

theorem non_positive_sum_invalid {arr : List Int} (h : arr.sum ≤ 0) :
  learn_charitable_game arr = false := sorry

theorem divisible_sum_valid {arr : List Int} (h₁ : arr.sum > 0) :
  learn_charitable_game arr = (arr.sum % arr.length == 0) := sorry

theorem all_zeros_invalid {arr : List Int} 
  (h₁ : arr.length ≥ 2)
  (h₂ : ∀ x ∈ arr, x = 0) :
  learn_charitable_game arr = false := sorry
