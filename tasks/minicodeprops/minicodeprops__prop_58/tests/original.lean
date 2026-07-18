import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_58 (n: Nat) (xs: List α) (ys: List β) :
  (List.drop n (zip' xs ys) =  zip' (List.drop n xs) (List.drop n ys)):= by sorry
