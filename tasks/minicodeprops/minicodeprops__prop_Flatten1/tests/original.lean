import Mathlib

inductive MyTree (α: Type) where
| leaf : MyTree α
| node : MyTree α → α → MyTree α  →  MyTree α


def f1Size : MyTree α → Nat
| MyTree.leaf => 1
| MyTree.node p _x q => f1Size p + f1Size q +
  (match p with
    | MyTree.leaf => 0
    | MyTree.node _a _b _c=> 2)


lemma f1Size_gt_zero (t: MyTree α): f1Size t > 0 := by
  induction t with
    | leaf => simp [f1Size]
    | node p _x q ih1 => simp [f1Size, ih1]


lemma f1Size_lt_subTrees  (q r: MyTree α) {x: α}: f1Size q < f1Size (MyTree.node q x r) ∧ f1Size r < f1Size (MyTree.node q x r) := by
  simp [f1Size]
  exact ⟨by linarith [f1Size_gt_zero r], by linarith [f1Size_gt_zero q]⟩;


def flatten0 : MyTree α → List α
  | MyTree.leaf => []
  | MyTree.node p x q => flatten0 p ++ [x] ++ flatten0 q


def flatten1 : List (MyTree α) → List α
  | []                                => []
  | MyTree.leaf::ps                   => flatten1 ps
  | (MyTree.node MyTree.leaf x q)::ps => x::(flatten1 (q::ps))
  | (MyTree.node (MyTree.node a b c) x q)::ps => flatten1 ((MyTree.node a b c)::(MyTree.node MyTree.leaf x q)::ps)
termination_by ps => List.sum (ps.map (fun (t: MyTree α ) => f1Size t))
decreasing_by
  simp_wf
  simp [f1Size]
  simp_wf
  simp [f1Size_lt_subTrees]
  simp_wf
  simp [f1Size]
  linarith

theorem prop_Flatten1 (p: MyTree α) [DecidableEq α] :
  flatten1 [p] == flatten0 p:= by sorry
