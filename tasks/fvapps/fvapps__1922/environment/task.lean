import Mathlib

inductive TreeNode where
  | mk (val : Int) (left : Option TreeNode) (right : Option TreeNode)
  deriving Repr

def minCameraCover : Option TreeNode → Nat :=
  sorry

theorem minCameraCover_nonnegative (t : TreeNode) :
  minCameraCover (some t) ≥ 0 := sorry

theorem minCameraCover_leaf (t : TreeNode) (v : Int) :
  t = TreeNode.mk v none none → 
  minCameraCover (some t) = 1 := sorry

theorem minCameraCover_empty :
  minCameraCover none = 0 := sorry

theorem minCameraCover_monotone (t t' : TreeNode) (v : Int) (r : Option TreeNode) :
  t' = TreeNode.mk v (some t) r →
  minCameraCover (some t') ≥ 1 := sorry

theorem minCameraCover_add_child (t root : TreeNode) (n : Nat) (v : Int) (l : Option TreeNode) :
  minCameraCover (some root) = n →
  root = TreeNode.mk v l (some t) →
  minCameraCover (some root) ≥ n := sorry
