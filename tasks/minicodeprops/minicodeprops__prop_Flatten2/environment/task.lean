import Mathlib

inductive MyTree (α: Type) where
| leaf : MyTree α
| node : MyTree α → α → MyTree α  →  MyTree α


def flatten0 : MyTree α → List α
  | MyTree.leaf => []
  | MyTree.node p x q => flatten0 p ++ [x] ++ flatten0 q


def flatten2 : MyTree α -> List α -> List α
| MyTree.leaf, ys => ys
| MyTree.node p x q, ys => flatten2 p (x:: flatten2 q ys)

theorem prop_Flatten2 (p: MyTree α) [DecidableEq α] :
  flatten2 p [] == flatten0 p:= by sorry
