import Mathlib

def points (games : List String) : Nat :=
  sorry



theorem points_draws (n : Nat) :
  let draw_games := List.map (fun i => s!"{i}:{i}") (List.range n)
  points draw_games = n :=
  sorry

theorem points_wins (nums : List Nat) :
  let win_games := List.map (fun n => s!"{n+1}:{n}") nums
  points win_games = nums.length * 3 :=
  sorry
