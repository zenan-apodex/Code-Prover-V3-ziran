import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_83 (xs: List α) (ys: List α) (zs: List β) :
  (zip' (xs ++ ys) zs =
           zip' xs (List.take (List.length xs) zs) ++ zip' ys (List.drop (List.length xs) zs)):= by sorry
