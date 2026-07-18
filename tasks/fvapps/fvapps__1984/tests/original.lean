import Mathlib

inductive TreeNode where
  | node : Int → Option TreeNode → Option TreeNode → TreeNode
  deriving Repr

def buildTree (preorder : List Int) (inorder : List Int) : Option TreeNode :=
  sorry

def inorder_traversal (tree : Option TreeNode) : List Int :=
  sorry

def preorder_traversal (tree : Option TreeNode) : List Int :=
  sorry

theorem buildTree_reconstructs_traversals {size : Nat} (preorder inorder : List Int) :
  (preorder.length = size) →
  (inorder.length = size) →
  size > 0 →
  let tree := buildTree preorder inorder
  inorder_traversal tree = inorder ∧ 
  preorder_traversal tree = preorder :=
sorry

theorem empty_input_gives_none :
  buildTree [] [] = none :=
sorry

theorem single_node_preserves_value (x : Int) :
  let tree := buildTree [x] [x]
  match tree with
  | some (TreeNode.node val left right) => val = x ∧ left = none ∧ right = none 
  | none => False
:=
sorry
