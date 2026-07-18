import Mathlib

def solve_chip_game (n : Nat) (banned : List (Nat × Nat)) : Nat :=
  sorry

theorem empty_board_nonnegative (n : Nat) :
  n ≥ 2 → solve_chip_game n [] ≥ 0 :=
  sorry

theorem odd_board_has_middle (n : Nat) :
  n ≥ 2 → n % 2 = 1 → solve_chip_game n [] ≥ 1 :=
  sorry

theorem all_cells_banned (n : Nat) :
  n ≥ 2 →
  let banned := List.range n |>.bind (fun x => 
    List.range n |>.map (fun y => (x+1, y+1)))
  solve_chip_game n banned = 0 :=
  sorry
