import Mathlib

inductive TreeNode where
  | leaf : TreeNode
  | node (val : Int) (left right : TreeNode) : TreeNode

def list_to_tree : List Int → TreeNode :=
  sorry

def tree_to_list : TreeNode → List Int :=
  sorry

def add_one_row : TreeNode → Int → Int → TreeNode :=
  sorry

theorem add_one_row_result_nonempty (t : TreeNode) (v : Int) (d : Int)
  (h1 : -100 ≤ v ∧ v ≤ 100) (h2 : 1 ≤ d ∧ d ≤ 3) :
  ∃ l : List Int, tree_to_list (add_one_row t v d) = l ∧ l ≠ [] :=
  sorry

theorem add_one_row_depth_one (t : TreeNode) (v : Int) (orig_val : Int)
  (h1 : -100 ≤ v ∧ v ≤ 100) (h2 : t ≠ TreeNode.leaf) :
  let result := add_one_row t v 1
  let result_list := tree_to_list result
  result_list.head? = some v ∧
  result_list.get? 1 = some orig_val :=
  sorry

theorem add_one_row_single_node (val v : Int) (d : Int)
  (h1 : -100 ≤ val ∧ val ≤ 100) (h2 : -100 ≤ v ∧ v ≤ 100) (h3 : d = 1 ∨ d = 2) :
  let t := TreeNode.node val TreeNode.leaf TreeNode.leaf
  let result := add_one_row t v d
  let result_list := tree_to_list result
  (d = 1 → result_list.head? = some v ∧ result_list.get? 1 = some val) ∧
  (d = 2 → result_list.head? = some val ∧ 
           result_list.get? 1 = some v ∧
           result_list.get? 2 = some v) :=
  sorry
