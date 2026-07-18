import Mathlib

def solve_pattern_matching (ops : List String) : List Nat :=
  sorry

theorem add_remove_cancel (num : Nat) (count : Nat) (h : 0 < count ∧ count ≤ 5) : 
  let ops := List.join (List.replicate count [s!"+ {num}", s!"- {num}"]) ++ [s!"? {toString num}"]
  solve_pattern_matching ops = [0]
  := sorry
