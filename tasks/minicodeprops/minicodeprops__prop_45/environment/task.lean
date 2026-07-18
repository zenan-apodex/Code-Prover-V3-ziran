import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_45 (x: α) (y: β) (xs: List α) (ys: List β) :
  zip' (x::xs) (y::ys) = (x, y) :: zip' xs ys:= by sorry
