import Mathlib

def takeWhile : (α → Bool) → List α → List α
  | _, [] => []
  | p, x::xs => if p x then x ::(takeWhile p xs) else []

theorem prop_36 (xs: List α) :
  takeWhile (fun _ => True) xs = xs:= by sorry
