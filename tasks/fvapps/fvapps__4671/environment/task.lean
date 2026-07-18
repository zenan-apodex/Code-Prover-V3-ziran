import Mathlib

def isTree (graph : List (List Nat)) : Bool := sorry 

def isValidAdjacencyMatrix (matrix : List (List Nat)) : Bool := sorry

def dfs (graph : List (List Nat)) (node : Nat) (visited : List Nat) : List Nat := sorry

theorem tree_edge_count 
  (graph : List (List Nat)) : 
  isValidAdjacencyMatrix graph → isTree graph → 
  (List.length (List.join graph)) / 2 = graph.length - 1 := sorry

theorem tree_connected
  (graph : List (List Nat)) :
  isValidAdjacencyMatrix graph → isTree graph →
  ∀ start, (dfs graph start []).length = graph.length := sorry

theorem valid_matrix_nonempty
  (graph : List (List Nat)) :
  isValidAdjacencyMatrix graph → graph.length > 0 := sorry

theorem valid_matrix_indices
  (graph : List (List Nat)) :
  isValidAdjacencyMatrix graph →
  ∀ row ∈ graph, ∀ x ∈ row, x < graph.length := sorry
