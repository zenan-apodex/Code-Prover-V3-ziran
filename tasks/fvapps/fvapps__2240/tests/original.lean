import Mathlib

def solve_tree_zeros (n : Nat) (edges : List (Nat × Nat)) (values : List Int) : Nat :=
  sorry

theorem solve_tree_zeros_nonnegative (n : Nat) (edges : List (Nat × Nat)) (values : List Int) :
  solve_tree_zeros n edges values ≥ 0 := 
  sorry

theorem solve_tree_zeros_finite (n : Nat) (edges : List (Nat × Nat)) (values : List Int) :
  ∃ (k : Nat), solve_tree_zeros n edges values = k :=
  sorry

def list_max (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | [x] => x
  | x::xs => Nat.max x (list_max xs)

theorem solve_tree_zeros_bounds (n : Nat) (edges : List (Nat × Nat)) (values : List Int) :
  solve_tree_zeros n edges values ≥ list_max (values.map Int.natAbs) :=
  sorry
