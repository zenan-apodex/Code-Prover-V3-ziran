import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_84 (xs: List α) (ys: List β) (zs: List β) :
  (zip' xs (ys ++ zs) =
           zip' (List.take (List.length ys) xs) ys ++ zip' (List.drop (List.length ys) xs) zs):= by sorry
