import Mathlib

def zip' : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x::xs, y::ys => ⟨x, y⟩ :: zip' xs ys

theorem prop_46 {α β: Type} (xs: List β) :
  zip' ([]: List α) xs = []:= by sorry
