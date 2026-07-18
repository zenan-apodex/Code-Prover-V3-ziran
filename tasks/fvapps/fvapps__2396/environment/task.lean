import Mathlib

def solve (s : String) (c : Char := 'a') : Nat :=
  sorry



theorem solve_single_char (s : String) :
  String.length s = 1 →
  solve s = (if s = "a" then 0 else 1)
  := sorry



theorem solve_edge_cases :
  solve "z" = 1 ∧
  solve "a" = 0
  := sorry
