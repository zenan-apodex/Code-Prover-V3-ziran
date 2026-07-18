import Mathlib

inductive BTree where
  | nil : BTree
  | node (val: Nat) (left right : BTree) : BTree
  deriving DecidableEq

def pruneTree : BTree → Option BTree 
  | BTree.nil => none
  | BTree.node v l r => sorry

def containsValue : BTree → Nat → Bool
  | BTree.nil, _ => false
  | BTree.node v l r, n => v = n || containsValue l n || containsValue r n

def isLeaf : BTree → Bool
  | BTree.nil => false
  | BTree.node _ BTree.nil BTree.nil => true
  | _ => false

def getValue : BTree → Nat
  | BTree.nil => 0
  | BTree.node v _ _ => v

theorem pruned_tree_only_zeros_and_ones {t : BTree} {pt : BTree} :
  pruneTree t = some pt → 
  ∀ n : Nat, containsValue pt n = true → (n = 0 ∨ n = 1) := sorry

theorem pruned_leaf_nodes_are_one {t : BTree} {pt : BTree} :
  pruneTree t = some pt →
  isLeaf pt = true → getValue pt = 1 := sorry

theorem prune_tree_idempotent {t : BTree} :
  pruneTree t = pruneTree (Option.getD (pruneTree t) BTree.nil) := sorry

theorem prune_tree_nil : 
  pruneTree BTree.nil = none := sorry

theorem prune_tree_zero :
  pruneTree (BTree.node 0 BTree.nil BTree.nil) = none := sorry

theorem prune_tree_one :
  pruneTree (BTree.node 1 BTree.nil BTree.nil) = some (BTree.node 1 BTree.nil BTree.nil) := sorry
