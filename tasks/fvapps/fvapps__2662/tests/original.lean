import Mathlib

structure RoundData where
  P1 : String
  P2 : String
deriving Repr

def GameResults := List (RoundData × Bool)

def shoot : GameResults → String := sorry

theorem shoot_returns_valid_result (results : GameResults) :
  shoot results = "Pete Wins!" ∨ 
  shoot results = "Phil Wins!" ∨
  shoot results = "Draw!" := sorry

def calculateScore (shots : String) (double : Bool) : Nat :=
  (shots.foldl (fun acc c => if c = 'X' then acc + 1 else acc) 0) * 
  (if double then 2 else 1)

theorem shoot_gives_correct_winner (results : GameResults) :
  let peteScore := results.foldl 
    (fun acc (round, double) => acc + calculateScore round.P1 double) 0
  let philScore := results.foldl 
    (fun acc (round, double) => acc + calculateScore round.P2 double) 0
  (peteScore > philScore → shoot results = "Pete Wins!") ∧
  (philScore > peteScore → shoot results = "Phil Wins!") ∧
  (peteScore = philScore → shoot results = "Draw!") := sorry

theorem shoot_symmetrical_draw (results : GameResults) :
  let symmetricalResults := results.map 
    (fun (round, double) => ({P1 := round.P1, P2 := round.P1}, double))
  shoot symmetricalResults = "Draw!" := sorry
