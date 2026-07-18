import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + List.sum xs

def get_new_notes (salary: Nat) (bills: List Nat) : Nat :=
  sorry







theorem get_new_notes_edge_zero_salary : 
  get_new_notes 0 [] = 0 := sorry

theorem get_new_notes_edge_min_note : 
  get_new_notes 5 [] = 1 := sorry

theorem get_new_notes_edge_no_remainder :
  get_new_notes 100 [100] = 0 := sorry

theorem get_new_notes_edge_insufficient :
  get_new_notes 100 [200] = 0 := sorry
