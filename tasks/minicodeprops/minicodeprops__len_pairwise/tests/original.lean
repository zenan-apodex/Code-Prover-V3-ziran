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

theorem len_pairwise (xs: List (List Nat)): 2 * (pairwise xs).length = (if (Odd xs.length) then xs.length + 1 else xs.length) := by sorry
