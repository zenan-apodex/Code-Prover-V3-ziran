import Mathlib

inductive Move where
  | rock : Move
  | paper : Move
  | scissors : Move
deriving Repr, BEq

inductive Outcome where
  | player1Wins : Outcome
  | player2Wins : Outcome  
  | draw : Outcome
deriving Repr, BEq

def rps (p1 p2 : Move) : Outcome :=
  sorry

theorem rps_symmetry (p1 p2 : Move) :
  match rps p1 p2 with
  | Outcome.draw => rps p2 p1 = Outcome.draw
  | Outcome.player1Wins => rps p2 p1 = Outcome.player2Wins
  | Outcome.player2Wins => rps p2 p1 = Outcome.player1Wins
  := sorry

theorem rps_draw (m : Move) :
  rps m m = Outcome.draw := sorry

theorem rps_valid_result (p1 p2 : Move) :
  match rps p1 p2 with
  | Outcome.player1Wins => True
  | Outcome.player2Wins => True
  | Outcome.draw => True := sorry
