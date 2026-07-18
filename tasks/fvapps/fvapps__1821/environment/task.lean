import Mathlib

def sort_array (xs : List Int) : List Int :=
  sorry

theorem sort_array_maintains_length (xs : List Int) :
  (sort_array xs).length = xs.length :=
sorry



theorem sort_array_perm (xs : List Int) :
  List.Perm xs (sort_array xs) :=
sorry

theorem sort_array_pure (xs : List Int) :
  sort_array xs = sort_array xs :=
sorry

theorem sort_array_empty_list :
  sort_array [] = [] :=
sorry
