import Mathlib

inductive MyTree (α: Type) where
| leaf : MyTree α
| node : MyTree α → α → MyTree α  →  MyTree α


def flatten0 : MyTree α → List α
  | MyTree.leaf => []
  | MyTree.node p x q => flatten0 p ++ [x] ++ flatten0 q


def f3Size : MyTree α → Nat
| MyTree.leaf => 1
| MyTree.node p _x q => (f3Size p) * 2 + f3Size q


lemma f3Size_gt_zero (t: MyTree α): f3Size t > 0 := by
  induction t with
  | leaf => simp [f3Size]
  | node p _ q ih1 => simp [f3Size, ih1]


def flatten3 : MyTree α → List α
| MyTree.leaf => []
| MyTree.node (MyTree.node p x q) y r => flatten3 (MyTree.node p x (MyTree.node q y r))
| MyTree.node MyTree.leaf x q => x :: flatten3 q
termination_by t => f3Size t
decreasing_by
  simp_wf
  simp [f3Size]
  linarith [f3Size_gt_zero p]
  simp_wf
  simp [f3Size]

theorem prop_Flatten3 (p: MyTree α) [DecidableEq α] :
  flatten3 p == flatten0 p:= by sorry
