import Mathlib

theorem prop_12 (n: Nat) (f: α → α) (xs: List α) :
   (List.drop n (List.map f xs) = List.map f (List.drop n xs)):= by sorry
