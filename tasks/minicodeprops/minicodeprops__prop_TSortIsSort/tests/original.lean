import Mathlib

def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


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

theorem prop_TSortIsSort (xs: List Nat) : tsort xs == isort xs:= by sorry
