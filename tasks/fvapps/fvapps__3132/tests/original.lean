import Mathlib

def alternate_sort (lst : List Int) : List Int := sorry

theorem alternate_sort_maintains_elements (lst : List Int) :
  List.length (alternate_sort lst) = List.length lst ∧
  ∀ x, List.count x (alternate_sort lst) = List.count x lst := sorry
