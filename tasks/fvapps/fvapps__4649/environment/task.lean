import Mathlib

def List.sum : List Int → Int 
  | [] => 0
  | (x::xs) => x + sum xs

def get_section_id (scroll : Int) (sizes : List Int) : Int :=
  sorry

theorem get_section_id_bounds (scroll : Int) (sizes : List Int) (h : sizes ≠ []) :
  -1 ≤ get_section_id scroll sizes ∧ get_section_id scroll sizes < sizes.length :=
  sorry
