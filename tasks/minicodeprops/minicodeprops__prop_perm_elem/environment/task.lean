import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))

theorem prop_perm_elem (x: α) (xs ys: List α) [DecidableEq α] :
  x ∈ xs → isPermutation xs ys → x ∈ ys:= by sorry
