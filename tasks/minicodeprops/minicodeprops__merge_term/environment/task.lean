import Mathlib

def lmerge : List Nat → List Nat → List Nat
| [], ys => ys
| xs, [] => xs
| x::xs, y::ys => if  x <= y  then
      x::(lmerge xs (y::ys))
    else
      y::(lmerge (x::xs) ys)


def pairwise : List (List Nat) → List (List Nat)
| xs::ys::xss => lmerge xs ys :: pairwise xss
| xss => xss

theorem merge_term : (pairwise (xs::ys::xss)).length < (xs::ys::xss).length := by sorry
