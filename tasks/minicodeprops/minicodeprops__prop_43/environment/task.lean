import Mathlib

def dropWhile : (α → Bool) → List α → List α
  | _, [] => []
  | p, x::xs => if p x then dropWhile p xs else x::xs


def takeWhile : (α → Bool) → List α → List α
  | _, [] => []
  | p, x::xs => if p x then x ::(takeWhile p xs) else []

theorem prop_43 (p: Nat → Bool) (xs: List Nat) :
  (takeWhile p xs ++ dropWhile p xs = xs):= by sorry
