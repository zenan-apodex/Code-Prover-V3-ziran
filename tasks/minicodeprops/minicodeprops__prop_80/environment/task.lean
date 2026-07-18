import Mathlib

theorem prop_80 (n: Nat) (xs: List α) (ys: List α) :
  (List.take n (xs ++ ys) = List.take n xs ++ List.take (n - List.length xs) ys):= by sorry
