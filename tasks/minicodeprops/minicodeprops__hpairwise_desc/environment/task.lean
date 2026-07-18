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


def hpairwise : List MyHeap → List MyHeap
| p::q::qs => (hmerge p q)::hpairwise qs
| ps => ps

theorem hpairwise_desc (ps: List MyHeap): List.length (hpairwise ps) ≤ List.length ps := by sorry
