import Mathlib

inductive BTree (α : Type)
  | leaf : BTree α
  | node : α → BTree α → BTree α → BTree α

def buildCompleteTree {α : Type} (values : List α) : BTree α := sorry

def countCompleteTreeNodes {α : Type} (t : BTree α) : Nat := sorry

theorem count_matches_input_size {α : Type} (values : List α) :
  countCompleteTreeNodes (buildCompleteTree values) = values.length := sorry

theorem perfect_tree_size (h : Nat) : 
  let t : BTree Nat := if h = 0 then BTree.leaf else buildCompleteTree (List.range (2^h - 1))
  countCompleteTreeNodes t = if h = 0 then 0 else 2^h - 1 := sorry

theorem empty_tree_count {α : Type} :
  countCompleteTreeNodes (BTree.leaf : BTree α) = 0 := sorry
