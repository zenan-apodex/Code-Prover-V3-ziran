import Mathlib

theorem prop_74 (i: Nat) (xs: List α) :
  (List.reverse (List.take i xs) = List.drop (List.length xs - i) (List.reverse xs)):= by sorry
