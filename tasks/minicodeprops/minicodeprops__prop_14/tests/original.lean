import Mathlib

theorem prop_14 (p: α → Bool) (xs: List α) (ys: List α) :
  (List.filter p (xs ++ ys) = (List.filter p xs) ++ (List.filter p ys)):= by sorry
