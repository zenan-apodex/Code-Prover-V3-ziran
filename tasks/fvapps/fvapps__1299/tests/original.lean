import Mathlib

def find_max_dish_type (n : Nat) (dishes : List Nat) : Nat :=
  sorry

theorem n_parameter_irrelevant (n : Nat) (dishes : List Nat) 
    (h : dishes ≠ []) : 
    find_max_dish_type n dishes = find_max_dish_type dishes.length dishes :=
  sorry

theorem preserves_input (dishes : List Nat) (h : dishes ≠ []) : 
    let original := dishes;
    let _ := find_max_dish_type dishes.length dishes;
    dishes = original :=
  sorry
