import Mathlib

inductive TreeNode where
  | mk (val : Int) (left : Option TreeNode) (right : Option TreeNode) : TreeNode
deriving Repr

def maxAncestorDiff : Option TreeNode → Int
  | none => 0
  | some _ => sorry

partial def getAllValues : Option TreeNode → List Int
  | none => []
  | some (TreeNode.mk v l r) => v :: (getAllValues l ++ getAllValues r)

theorem maxAncestorDiff_nonnegative (tree : Option TreeNode) :
  maxAncestorDiff tree ≥ 0 := sorry

theorem maxAncestorDiff_single_node (v : Int) :
  maxAncestorDiff (some (TreeNode.mk v none none)) = 0 := sorry

theorem maxAncestorDiff_empty_tree :
  maxAncestorDiff none = 0 := sorry

def listMaximum (l : List Int) : Int :=
  match l with
  | [] => 0
  | x::xs => List.foldl max x xs

def listMinimum (l : List Int) : Int :=
  match l with
  | [] => 0
  | x::xs => List.foldl min x xs

theorem maxAncestorDiff_bounded (tree : Option TreeNode) :
  tree ≠ none →
  maxAncestorDiff tree ≤ (listMaximum (getAllValues tree) - listMinimum (getAllValues tree)) := sorry
