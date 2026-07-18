import Mathlib

inductive MyHeap where
| nil : MyHeap
| node : MyHeap → Nat → MyHeap  →  MyHeap


def numElem : MyHeap → Nat
| MyHeap.nil => 0
| MyHeap.node p _x q => 1 + numElem p + numElem q

theorem numElem_lt_subHeaps  (q r: MyHeap) {x: Nat}: numElem q < numElem (MyHeap.node q x r) ∧ numElem r < numElem (MyHeap.node q x r) := by sorry
