import Mathlib

def sort_array (arr : List Int) : List Int := sorry

theorem sort_array_preserves_length {arr : List Int} : 
  (sort_array arr).length = arr.length := sorry





theorem sort_array_preserves_elements {arr : List Int} :
  ∀ x, (List.count x arr) = (List.count x (sort_array arr)) := sorry

theorem sort_array_empty :
  sort_array [] = [] := sorry
