import Mathlib

structure Edge where
  vertices : String × String
  weight : Nat

def make_spanning_tree (edges : List Edge) (tree_type : String) : List Edge :=
  sorry

theorem spanning_tree_subset {edges : List Edge} {tree_type : String} :
  let result := make_spanning_tree edges tree_type
  ∀ e ∈ result, e ∈ edges := by
  sorry

theorem spanning_tree_no_duplicates {edges : List Edge} {tree_type : String} :
  let result := make_spanning_tree edges tree_type
  let result_edges := result.map (·.vertices)
  result_edges.length = result_edges.eraseDups.length := by
  sorry

theorem spanning_tree_no_self_loops {edges : List Edge} {tree_type : String} :
  let result := make_spanning_tree edges tree_type
  ∀ e ∈ result, e.vertices.1 ≠ e.vertices.2 := by
  sorry

theorem spanning_tree_min_property {edges : List Edge} 
  (h : make_spanning_tree edges "min" ≠ []) :
  let result := make_spanning_tree edges "min"
  let result_weights := result.map (·.weight)
  let valid_edges := edges.filter (λ e => e.vertices.1 ≠ e.vertices.2)
  let edge_weights := valid_edges.map (·.weight)
  (result_weights.minimum?.get! : Nat) ≥ edge_weights.minimum?.get! := by
  sorry

theorem spanning_tree_max_property {edges : List Edge}
  (h : make_spanning_tree edges "max" ≠ []) :
  let result := make_spanning_tree edges "max"
  let result_weights := result.map (·.weight)
  let valid_edges := edges.filter (λ e => e.vertices.1 ≠ e.vertices.2)
  let edge_weights := valid_edges.map (·.weight)
  (result_weights.maximum?.get! : Nat) ≤ edge_weights.maximum?.get! := by
  sorry
