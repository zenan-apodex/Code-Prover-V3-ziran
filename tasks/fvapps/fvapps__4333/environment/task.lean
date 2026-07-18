import Mathlib

def sort_number (l : List Int) : List Int := sorry

theorem sort_number_length {l : List Int} (h : l ≠ []) : 
  (sort_number l).length = l.length := sorry

theorem sort_number_first {l : List Int} (h : l ≠ []) :
  (sort_number l).head! = 1 := sorry

def isSorted (l : List Int) : Prop :=
  ∀ i j, i < j → j < l.length → l[i]! ≤ l[j]!





theorem sort_number_deterministic {l : List Int} (h : l ≠ []) :
  sort_number l = sort_number l := sorry
