import Mathlib

inductive ListNode where
  | mk : Int → Option ListNode → ListNode
deriving Repr

inductive TreeNode where
  | mk : Int → Option TreeNode → Option TreeNode → TreeNode
deriving Repr

def is_subpath (head : Option ListNode) (root : Option TreeNode) : Bool :=
  sorry

theorem empty_tree_property {head : ListNode} :
  is_subpath (some head) none = false := by
  sorry

theorem empty_list_property {root : Option TreeNode} :
  is_subpath none root = true := by
  sorry

theorem single_path_property {head : ListNode} {root : TreeNode} {list_len tree_len : Nat} :
  list_len > tree_len →
  is_subpath (some head) (some root) = false := by
  sorry

theorem single_node_property {val : Int} :
  let head := ListNode.mk val none
  let root := TreeNode.mk val none none 
  is_subpath (some head) (some root) = true := by
  sorry
