import Mathlib

def solve (arr : List Int) : List Int :=
  sorry

theorem last_element_always_included {arr : List Int} (h : arr ≠ []) :
  (solve arr).getLast? = arr.getLast? :=
  sorry



theorem result_subset_of_input {arr : List Int} (h : arr ≠ []) :
  ∀ x : Int, x ∈ solve arr → x ∈ arr :=
  sorry
