import Mathlib

inductive BTree (α : Type)
  | leaf : BTree α
  | node : α → BTree α → BTree α → BTree α

def treeByLevels {α : Type} (t : BTree α) : List α :=
  sorry

def buildTree {α : Type} (values : List α) : BTree α :=
  sorry

theorem empty_tree_gives_empty_list {α : Type} :
  treeByLevels (BTree.leaf : BTree α) = [] :=
sorry

theorem tree_length {α : Type} (values : List α) (h : values ≠ []) :
  let tree := buildTree values
  List.length (treeByLevels tree) = List.length values :=
sorry

theorem root_is_first {α : Type} [Inhabited α] (values : List α) (h : values ≠ []) (v : α) (vs : List α) 
  (h2 : values = v :: vs) :
  let tree := buildTree values
  List.head? (treeByLevels tree) = some v :=
sorry

theorem values_preserved_length {α : Type} (values : List α) (h : values ≠ []) :
  let tree := buildTree values
  List.length (treeByLevels tree) = List.length values :=
sorry
