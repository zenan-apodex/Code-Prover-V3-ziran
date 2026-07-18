import Mathlib

inductive TreeNode where
  | leaf : TreeNode  
  | node : Int → TreeNode → TreeNode → TreeNode
  deriving Repr

def bstFromPreorder (preorder : List Int) : TreeNode :=
  sorry

def treeToList (root : TreeNode) : List Int :=
  sorry

def is_valid_bst (preorder : List Int) : Bool :=
  sorry

def is_bst (node : TreeNode) (min_val max_val : Int) : Bool :=
  sorry

theorem bst_from_preorder_preserves_values (preorder : List Int) :
  is_valid_bst preorder →
  let result := treeToList (bstFromPreorder preorder)
  (∀ x, x ∈ preorder → x ∈ result) ∧ 
  (∀ x, x ∈ result → x ∈ preorder) :=
  sorry

theorem bst_from_preorder_maintains_bst_property (preorder : List Int) :
  is_valid_bst preorder →
  is_bst (bstFromPreorder preorder) (-1000) 1000 :=
  sorry

theorem bst_from_preorder_structure (preorder : List Int) :
  is_valid_bst preorder →
  treeToList (bstFromPreorder preorder) = treeToList (bstFromPreorder preorder) :=
  sorry
