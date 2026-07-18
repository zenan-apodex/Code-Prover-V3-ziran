import Mathlib

def List.sum : List Int → Int 
  | [] => 0
  | x::xs => x + xs.sum

def isZeroBalanced (arr : List Int) : Bool := sorry

theorem empty_array_not_balanced {arr : List Int} :
  arr = [] → ¬(isZeroBalanced arr) := sorry

theorem balanced_implies_sum_zero {arr : List Int} :
  isZeroBalanced arr → (arr.sum = 0) := sorry

theorem balanced_implies_equal_frequencies {arr : List Int} :
  isZeroBalanced arr → ∀ x, (List.countP (· = x) arr) = (List.countP (· = -x) arr) := sorry 

theorem all_zeros_array_balanced {arr : List Int} :
  arr ≠ [] → (∀ x ∈ arr, x = 0) → isZeroBalanced arr := sorry

theorem reverse_preserves_balance {arr : List Int} :
  isZeroBalanced arr → isZeroBalanced arr.reverse := sorry
