import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys


def zipConcat : α → List α → List β → List (α × β)
  | _, _, [] => []
  | x, xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_44 (x: α) (xs: List α) (ys: List β) :
  zip' (x::xs) ys = zipConcat x xs ys:= by sorry
