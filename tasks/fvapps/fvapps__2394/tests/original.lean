import Mathlib

def solve_brackets (s : String) : Nat :=
  sorry

theorem solve_brackets_non_negative (s : String) :
  solve_brackets s ≥ 0 := sorry

theorem solve_brackets_empty :
  solve_brackets "" = 0 := sorry

theorem solve_brackets_balanced :
  solve_brackets "()" = 0 := sorry

theorem solve_brackets_single_close :
  solve_brackets ")" = 1 := sorry



def repeat_char (c : Char) (n : Nat) : String :=
  sorry
