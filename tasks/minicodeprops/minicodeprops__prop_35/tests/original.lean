import Mathlib

def dropWhile : (α → Bool) → List α → List α
  | _, [] => []
  | p, x::xs => if p x then dropWhile p xs else x::xs

theorem prop_35 (xs: List α) :
  dropWhile (fun _ => False) xs = xs:= by sorry
