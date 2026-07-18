import Mathlib

def smaller (arr : List Int) : List Int := sorry

theorem smaller_length_matches_input (arr : List Int) (h : arr ≠ []) :
  List.length (smaller arr) = List.length arr := sorry

theorem smaller_returns_non_negative (arr : List Int) (h : arr ≠ []) :
  ∀ x ∈ smaller arr, x ≥ 0 := sorry

theorem smaller_last_always_zero (arr : List Int) (h : arr ≠ []) :
  List.get! (smaller arr) (List.length arr - 1) = 0 := sorry

theorem smaller_count_correct (arr : List Int) (h : arr ≠ []) :
  ∀ i, i < List.length arr →
    List.get! (smaller arr) i = 
      (List.drop (i+1) arr).countP (· < List.get! arr i) := sorry



theorem smaller_maximum_constraint (arr : List Int) (h : arr ≠ []) :
  ∀ i, i < List.length arr →
    List.get! (smaller arr) i ≤ List.length arr - i - 1 := sorry
