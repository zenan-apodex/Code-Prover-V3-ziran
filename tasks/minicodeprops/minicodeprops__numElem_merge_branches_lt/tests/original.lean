import Mathlib

inductive MyHeap where
| nil : MyHeap
| node : MyHeap → Nat → MyHeap  →  MyHeap


def hmerge : MyHeap  → MyHeap  → MyHeap
| MyHeap.nil, q => q
| p, MyHeap.nil => p
| MyHeap.node p x q, MyHeap.node r y s =>
  if x <= y then MyHeap.node (hmerge q (MyHeap.node r y s)) x p
            else MyHeap.node (hmerge (MyHeap.node p x q) s) y r


def numElem : MyHeap → Nat
| MyHeap.nil => 0
| MyHeap.node p _x q => 1 + numElem p + numElem q

theorem numElem_merge_branches_lt (p q: MyHeap) (x: Nat): numElem (hmerge p q) < numElem (MyHeap.node p x q) := by sorry
