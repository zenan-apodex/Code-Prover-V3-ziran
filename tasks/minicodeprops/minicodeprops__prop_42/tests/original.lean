import Mathlib

theorem prop_42 (n: Nat) (x: α) (xs: List α) :
  (List.take n.succ (x::xs) = x :: (List.take n xs)):= by sorry
