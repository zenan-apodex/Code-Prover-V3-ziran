import Mathlib

inductive Piece where
  | King
  | Assassin
  | Shield
  | Pike
  deriving Inhabited

def isWhite (p: Piece) : Bool := sorry 

def fight_resolve (defender attacker : Piece) : Option Piece := sorry

theorem same_team_invalid {d a : Piece} : 
  isWhite d = isWhite a → fight_resolve d a = none := sorry

theorem result_is_valid {d a : Piece} :
  fight_resolve d a = some d ∨ fight_resolve d a = some a ∨ fight_resolve d a = none := sorry

theorem winning_matchups_symmetrical {d a : Piece} :
  fight_resolve d a = some d →
  ((d = Piece.King ∧ a = Piece.Assassin) ∨
   (d = Piece.Shield ∧ a = Piece.Pike) ∨ 
   (d = Piece.Assassin ∧ a = Piece.Shield) ∨
   (d = Piece.Pike ∧ a = Piece.King)) := sorry

theorem default_attacker_wins {d a : Piece} :
  fight_resolve d a ≠ none →
  fight_resolve d a ≠ some d →
  fight_resolve d a = some a := sorry
