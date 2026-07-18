import Mathlib

theorem prop_57 (n: Nat) (m: Nat) (xs: List α) :
  (List.drop n (List.take m xs) = List.take (m - n) (List.drop n xs)):= by sorry
