import Mathlib

inductive TreeNode where
  | node (val: Int) (left right : Option TreeNode) : TreeNode

def zigzagLevelOrder (root : Option TreeNode) : List (List Int) :=
  sorry

theorem zigzagLevelOrder_valid {root : Option TreeNode} :
  let result := zigzagLevelOrder root
  -- Result is a list of lists
  result.all (fun level => level.all (fun x => x ≥ -100 ∧ x ≤ 100)) ∧
  -- Each level length is at most double the previous
  result.tail.all (fun level => 
    match result.head? with
    | some prev => level.length ≤ 2 * prev.length 
    | none => true) :=
  sorry

theorem zigzagLevelOrder_empty :
  zigzagLevelOrder none = [] :=
  sorry

theorem zigzagLevelOrder_single_node :
  zigzagLevelOrder (some (TreeNode.node 1 none none)) = [[1]] := 
  sorry
