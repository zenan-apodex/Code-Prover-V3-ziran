import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))

theorem prop_perm_symm (xs ys: List α) [DecidableEq α] :
  isPermutation xs ys → isPermutation ys xs:= by sorry
