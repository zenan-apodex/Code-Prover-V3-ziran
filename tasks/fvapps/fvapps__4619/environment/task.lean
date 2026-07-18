import Mathlib

inductive Player where
  | black
  | white
deriving Repr, BEq

def opposite : Player → Player 
  | Player.black => Player.white
  | Player.white => Player.black

def whoseMove (player : Player) (win : Bool) : Player := sorry

theorem whoseMove_valid (player : Player) (win : Bool) :
  whoseMove player win = player ∨ whoseMove player win = opposite player := by sorry

theorem whoseMove_win (player : Player) (win : Bool) :
  win = true → whoseMove player win = player := by sorry

theorem whoseMove_lose (player : Player) (win : Bool) :
  win = false → whoseMove player win = opposite player := by sorry
