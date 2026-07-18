import Mathlib

def List.minimums (l : List (List Int)) : Int := sorry 

def List.sum (l : List Int) : Int := sorry

def List.minimum (l : List Int) : Int := sorry

theorem minimums_eq_sum_of_mins (numbers : List (List Int))
  (h : ∀ l ∈ numbers, l.length > 0) :
  numbers.minimums = (numbers.map List.minimum).sum := sorry

theorem single_element_minimums (numbers : List (List Int))
  (h1 : ∀ l ∈ numbers, l.length = 1) :
  numbers.minimums = numbers.join.sum := sorry
