import Mathlib

def smallest_range_i (arr : List Int) (k : Nat) : Nat :=
  sorry

theorem smallest_range_i_non_negative {arr : List Int} {k : Nat} (h : arr.length > 0) :
  smallest_range_i arr k ≥ 0 := sorry

theorem smallest_range_i_single_element {arr : List Int} {k : Nat} (h : arr.length = 1) : 
  smallest_range_i arr k = 0 := sorry

theorem smallest_range_i_bound {arr : List Int} {k : Nat} (h : arr.length > 0) :
  smallest_range_i arr k ≤ (arr.maximum?.getD 0) - (arr.minimum?.getD 0) := sorry

theorem smallest_range_i_reduction {arr : List Int} {k : Nat} (h : arr.length > 0) :
  smallest_range_i arr k = max 0 ((arr.maximum?.getD 0) - (arr.minimum?.getD 0) - 2 * k) := sorry

theorem smallest_range_i_zero_k {arr : List Int} (h₁ : arr.length > 0) (h₂ : arr.length > 1) :
  smallest_range_i arr 0 = (arr.maximum?.getD 0) - (arr.minimum?.getD 0) := sorry

theorem smallest_range_i_large_k {arr : List Int} {k : Nat} (h₁ : arr.length > 0)
  (h₂ : k ≥ (arr.maximum?.getD 0) - (arr.minimum?.getD 0)) :
  smallest_range_i arr k = 0 := sorry
