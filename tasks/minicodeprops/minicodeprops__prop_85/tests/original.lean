import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_85 (xs: List α) (ys: List β) :
  (List.length xs = List.length ys) →
    (zip' (List.reverse xs) (List.reverse ys) = List.reverse (zip' xs ys)):= by sorry
