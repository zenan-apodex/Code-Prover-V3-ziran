import Mathlib

inductive Color where
  | R : Color
  | G : Color
  | B : Color
deriving Repr, BEq, Inhabited, DecidableEq

def count_min_cards_to_remove (n : Nat) (colors : List Color) : Nat :=
  sorry

theorem min_cards_upper_bound {n : Nat} {colors : List Color} 
  (h : colors.length = n) (h1 : n > 0) :
  count_min_cards_to_remove n colors ≤ n - 1 :=
sorry

theorem min_cards_non_negative {n : Nat} {colors : List Color} 
  (h : colors.length = n) (h1 : n > 0) :
  count_min_cards_to_remove n colors ≥ 0 :=
sorry

def countAdjacentSame (colors : List Color) : Nat :=
  (List.zip colors colors.tail).filter (fun (x, y) => decide (x = y)) |>.length

theorem min_cards_equals_adjacent_same {n : Nat} {colors : List Color}
  (h : colors.length = n) (h1 : n > 0) :
  count_min_cards_to_remove n colors = countAdjacentSame colors :=
sorry

theorem min_cards_all_same_color {n : Nat} {colors : List Color}
  (h : colors.length = n) (h1 : n > 0)
  (h2 : ∀ i j, i < colors.length → j < colors.length → colors[i]! = colors[j]!) :
  count_min_cards_to_remove n colors = n - 1 :=
sorry

theorem min_cards_alternating {n : Nat} {colors : List Color}
  (h : colors.length = n) (h1 : n ≥ 2)
  (h2 : ∀ i, i < colors.length - 1 → colors[i]! ≠ colors[i+1]!) :
  count_min_cards_to_remove n colors = 0 :=
sorry
