import Mathlib

inductive TreeNode where
  | nil : TreeNode
  | node (value : Nat) (left right : TreeNode) : TreeNode

def rob_house : TreeNode → Nat
  | _ => sorry

-- Property: Result is always natural number
theorem rob_house_nat (t : TreeNode) : 
  rob_house t ≥ 0 := by sorry

-- Base case: Empty tree returns 0
theorem rob_house_empty :
  rob_house TreeNode.nil = 0 := by sorry

-- Base case: Single node returns its value 
theorem rob_house_single (n : Nat) :
  rob_house (TreeNode.node n TreeNode.nil TreeNode.nil) = n := by sorry

-- Property: Result for tree with children is at least as large as root value
theorem rob_house_with_children (v : Nat) (l r : TreeNode) :
  rob_house (TreeNode.node v l r) ≥ v := by sorry
