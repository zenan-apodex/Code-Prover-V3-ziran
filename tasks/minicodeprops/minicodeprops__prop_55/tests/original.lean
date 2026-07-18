import Mathlib

theorem prop_55 (n: Nat) (xs: List α) (ys: List α) :
  (List.drop n (xs ++ ys) = List.drop n xs ++ List.drop (n - List.length xs) ys):= by sorry
