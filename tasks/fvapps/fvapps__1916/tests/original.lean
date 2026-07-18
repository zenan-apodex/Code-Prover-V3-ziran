import Mathlib

inductive Tree (α : Type) where
  | leaf : α → Tree α
  | node : α → Tree α → Tree α → Tree α

def maxPathSum (t : Tree Int) : Int :=
  sorry

def listMax (l : List Int) : Int :=
  sorry

theorem max_path_sum_geq_max_node_value (t : Tree Int) (values : List Int) 
  (h : values.length > 0) : 
  maxPathSum t ≥ listMax values := sorry

theorem max_path_sum_is_finite (t : Tree Int) :
  ∃ (n : Int), maxPathSum t = n := sorry

theorem max_path_sum_single_node (v : Int) :
  maxPathSum (Tree.leaf v) = v := sorry

theorem max_path_sum_linear_path (v : Int) :
  v ≥ 0 → maxPathSum (Tree.node v (Tree.node v (Tree.leaf v) (Tree.leaf v)) (Tree.leaf v)) ≥ 2 * v := sorry

theorem max_path_sum_linear_path_neg (v : Int) :
  v ≤ 0 → maxPathSum (Tree.node v (Tree.node v (Tree.leaf v) (Tree.leaf v)) (Tree.leaf v)) ≥ v := sorry
