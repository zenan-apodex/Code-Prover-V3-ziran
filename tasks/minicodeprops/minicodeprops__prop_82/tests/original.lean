import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_82 (n: Nat) (xs: List α) (ys: List β) :
  (List.take n (zip' xs ys) = zip' (List.take n xs) (List.take n ys)):= by sorry
