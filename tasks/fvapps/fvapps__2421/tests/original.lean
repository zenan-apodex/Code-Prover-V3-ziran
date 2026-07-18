import Mathlib

def majorityElement (xs : List Int) : Int :=
  sorry

theorem single_element_majority {x : Int} :
  majorityElement [x] = x :=
  sorry

theorem repeated_element_majority (lst : List Int) (x : Int) :
  majorityElement (List.replicate (lst.length + 1) x) = x :=
  sorry
