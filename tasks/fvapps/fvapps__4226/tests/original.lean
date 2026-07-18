import Mathlib

def remove_smallest (list : List Int) : List Int :=
  sorry

def minimum (list : List Int) : Option Int :=
  sorry

theorem remove_smallest_length (list : List Int) :
  list = [] → remove_smallest list = [] ∧
  list ≠ [] → List.length (remove_smallest list) = List.length list - 1 :=
sorry



def list_eq (l1 l2 : List Int) : Bool :=
  sorry
