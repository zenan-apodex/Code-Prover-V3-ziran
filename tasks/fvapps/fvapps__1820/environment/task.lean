import Mathlib

inductive TreeNode (α : Type) where
  | nil : TreeNode α
  | node : α → TreeNode α → TreeNode α → TreeNode α

variable {α : Type} [Ord α] [Inhabited α] [Max α]

def largest_values : TreeNode α → List α := sorry

def get_height : TreeNode α → Nat := sorry

def get_level_nodes : TreeNode α → Nat → List α := sorry

def list_max (l : List α) : α := 
  List.foldl max default l

theorem empty_tree_gives_empty_list :
  largest_values (@TreeNode.nil α) = [] := sorry

theorem single_node_gives_singleton (x : α) :
  largest_values (@TreeNode.node α x TreeNode.nil TreeNode.nil) = [x] := sorry

theorem result_length_matches_height (t : TreeNode α) :
  List.length (largest_values t) = get_height t := sorry

theorem level_max_appears_in_nodes (t : TreeNode α) (level : Nat) 
  (h : level < List.length (largest_values t)) :
  List.get! (largest_values t) level = list_max (get_level_nodes t level) := sorry
