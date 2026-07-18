import Mathlib

inductive Tree where
  | empty : Tree
  | node (val : Int) (left right : Tree) : Tree
deriving Repr

def sumNumbers : Tree → Int
  | Tree.empty => 0
  | t => sorry

theorem empty_tree_sum :
  sumNumbers Tree.empty = 0 := by sorry

theorem single_node_sum (v : Int) (h : 0 ≤ v ∧ v ≤ 9):
  sumNumbers (Tree.node v Tree.empty Tree.empty) = v := by sorry 

theorem three_node_sum (root_val left_val right_val : Int)
    (h1 : 0 ≤ root_val ∧ root_val ≤ 9)
    (h2 : 0 ≤ left_val ∧ left_val ≤ 9) 
    (h3 : 0 ≤ right_val ∧ right_val ≤ 9):
  sumNumbers (Tree.node root_val 
              (Tree.node left_val Tree.empty Tree.empty)
              (Tree.node right_val Tree.empty Tree.empty)) = 
    (root_val * 10 + left_val) + (root_val * 10 + right_val) := by sorry

theorem single_path_sum (v : Int) (h : 0 ≤ v ∧ v ≤ 9):
  sumNumbers (Tree.node v (Tree.node v Tree.empty Tree.empty) Tree.empty) = 
    v * 10 + v := by sorry
