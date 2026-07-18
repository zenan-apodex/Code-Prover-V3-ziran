import Mathlib

def score_throws (radiuses : List Float) : Nat := sorry



theorem score_throws_empty : 
  score_throws [] = 0 := sorry





def throw_points (r : Float) : Nat :=
  if r < 5 then 10
  else if r ≤ 10 then 5
  else 0

def bonus_points (radiuses : List Float) : Nat :=
  match radiuses with
  | [] => 0
  | xs => if (∀ r ∈ xs, r < 5) then 100 else 0
