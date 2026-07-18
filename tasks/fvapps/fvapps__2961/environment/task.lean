import Mathlib

def complete_series (arr : List Nat) : List Nat := sorry

theorem complete_series_returns_list (arr : List Nat) :
  ∃ l, complete_series arr = l := by sorry

theorem complete_series_main_property (arr : List Nat) :
  (∃ x ∈ arr, ∃ y ∈ arr, x = y ∧ arr.indexOf x ≠ arr.indexOf y) →
  complete_series arr = [0] := by sorry

theorem complete_series_complete_sequence (arr : List Nat) :
  (∀ x ∈ arr, ∀ y ∈ arr, x = y → arr.indexOf x = arr.indexOf y) →
  let maxVal := arr.maximum?.getD 0
  complete_series arr = List.range (maxVal + 1) := by sorry 

theorem complete_series_length (arr : List Nat) :
  (∀ x ∈ arr, ∀ y ∈ arr, x = y → arr.indexOf x = arr.indexOf y) →
  let maxVal := arr.maximum?.getD 0
  (complete_series arr).length = maxVal + 1 := by sorry

theorem complete_series_contains_all_elements (arr : List Nat) : 
  (∀ x ∈ arr, ∀ y ∈ arr, x = y → arr.indexOf x = arr.indexOf y) →
  let maxVal := arr.maximum?.getD 0
  ∀ i, i ≤ maxVal → i ∈ complete_series arr := by sorry

theorem complete_series_monotone (arr : List Nat) :
  (∀ x ∈ arr, ∀ y ∈ arr, x = y → arr.indexOf x = arr.indexOf y) →
  ∀ i j, i < j → i < (complete_series arr).length → j < (complete_series arr).length →
  (complete_series arr).get ⟨i, by sorry⟩ ≤ (complete_series arr).get ⟨j, by sorry⟩ := by sorry
