import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))


inductive MyTree where
| nil : MyTree
| node : MyTree → Nat → MyTree → MyTree


def add : Nat → MyTree → MyTree
| x, .nil => .node .nil x .nil
| x, .node p y q => if x <= y then .node (add x p) y q else .node p y (add x q)


def toTree : List Nat → MyTree
| [] => .nil
| x::xs => add x (toTree xs)


def flatten : MyTree → List Nat → List Nat
| .nil, ys => ys
| .node p x q, ys => flatten p (x :: flatten q ys)


def tsort : List Nat → List Nat
| xs => flatten (toTree xs) []

theorem prop_TSortPermutes (xs: List Nat) : isPermutation (tsort xs) xs == true:= by sorry
