import Mathlib

inductive Cell where
  | mk : Char → Nat → Cell
  deriving Repr, BEq, Inhabited

def chess_board_cell_color : Cell → Cell → Bool := sorry

theorem chess_board_symmetry (c1 c2 : Cell) : 
  chess_board_cell_color c1 c2 = chess_board_cell_color c2 c1 := sorry

theorem chess_board_self_same_color (c : Cell) :
  chess_board_cell_color c c = true := sorry

theorem chess_board_transitivity (c1 c2 c3 : Cell) :
  chess_board_cell_color c1 c2 = true → 
  chess_board_cell_color c2 c3 = true →
  chess_board_cell_color c1 c3 = true := sorry

theorem chess_board_adjacent_vertical (c : Cell) (h : c.2 < 8) :
  let above := Cell.mk c.1 (c.2 + 1)
  chess_board_cell_color c above = false := sorry

def nextChar (c : Char) : Char := 
  Char.ofNat ((Char.toNat c) + 1)

theorem chess_board_adjacent_horizontal (c : Cell) (h : c.1 < 'H') :
  let right := Cell.mk (nextChar c.1) c.2
  chess_board_cell_color c right = false := sorry
