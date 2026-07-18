import Mathlib

def List.sum : List Int → Int 
  | [] => 0
  | x::xs => x + sum xs

def invite_more_women (arr : List Int) : Bool := sorry

theorem invite_more_women_sum_property (arr : List Int) 
  (h : arr.length > 0)
  (h₁ : ∀ x ∈ arr, x = 1 ∨ x = -1) :
  invite_more_women arr = (List.sum arr > 0) := sorry

theorem party_balance_monotonicity (arr : List Int)
  (h : arr.length > 0)
  (h₁ : ∀ x ∈ arr, x = 1 ∨ x = -1) :
  invite_more_women (arr ++ [-1]) ≤ invite_more_women arr ∧ 
  invite_more_women arr ≤ invite_more_women (arr ++ [1]) := sorry
