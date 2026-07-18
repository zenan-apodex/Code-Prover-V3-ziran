import Mathlib

namespace Game

inductive Direction where
  | L : Direction
  | R : Direction
deriving Repr

inductive Language where
  | E : Language
  | H : Language
deriving Repr

def solve_gr_game (n x : Nat) (d : Direction) (l : Language) : Nat × Language :=
  sorry

theorem position_in_bounds {n x : Nat} {d : Direction} {l : Language} 
    (h1 : 0 < n) (h2 : 0 < x) :
  let (pos, _) := solve_gr_game n x d l
  0 < pos ∧ pos ≤ n :=
  sorry

theorem position_matches_direction {n x : Nat} {d : Direction} {l : Language} 
    (h1 : 0 < n) (h2 : 0 < x) (h3 : x ≤ n) :
  let (pos, _) := solve_gr_game n x d l
  (d = Direction.L → pos = x) ∧ 
  (d = Direction.R → pos = n - x + 1) :=
  sorry

theorem language_alternates {n x : Nat} {d : Direction} {l : Language}
    (h1 : 0 < n) (h2 : 0 < x) :
  let (pos, lang) := solve_gr_game n x d l
  ((pos % 2 = 1) → lang = l) ∧
  ((pos % 2 = 0) → lang = match l with
                           | Language.E => Language.H
                           | Language.H => Language.E) :=
  sorry

end Game
