import Mathlib

theorem prop_41 (n: Nat) (f: α → α) (xs: List α) :
  (List.take n (List.map f xs) = List.map f (List.take n xs)):= by sorry
