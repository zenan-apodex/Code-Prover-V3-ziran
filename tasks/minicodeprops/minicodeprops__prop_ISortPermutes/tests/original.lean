import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))


def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)

theorem prop_ISortPermutes (xs: List Nat) : isPermutation (isort xs) xs == True:= by sorry
