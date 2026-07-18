import Mathlib

def delete [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then (delete n xs) else x::(delete n xs)


def count [DecidableEq α]: α -> List α -> Nat
  | _z, []    => 0
  | z,  x::xs => if x==z then (count z xs).succ else count z xs


def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)

theorem prop_deleteAll_count (x: α) (xs: List α) [DecidableEq α]:
  (delete x xs == deleteFirst x xs) → count x xs <= 1:= by sorry
