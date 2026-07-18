import Mathlib

inductive TreeNode where
  | nil : TreeNode 
  | node (val: Int) (left right: TreeNode) : TreeNode

def find_path_sum : TreeNode → Int → List (List Int)
  | _, _ => sorry

theorem find_path_sum_valid_sums (t: TreeNode) (target: Int) :
  ∀ path ∈ find_path_sum t target,
  (path.foldl (· + ·) 0) = target :=
  sorry

theorem empty_tree_no_paths (target: Int) :
  find_path_sum TreeNode.nil target = [] :=
  sorry

theorem single_node_match (val target: Int) :
  find_path_sum (TreeNode.node val TreeNode.nil TreeNode.nil) target =
    if val = target then [[val]] else [] :=
  sorry
