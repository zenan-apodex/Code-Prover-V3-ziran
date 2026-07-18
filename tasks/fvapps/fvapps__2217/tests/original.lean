import Mathlib

variable (solve_graph_subset : Nat → Nat → List Int → List (Nat × Nat) → List Nat)

theorem empty_graph_theorem (n : Nat) (degrees : List Int) :
  n > 0 →
  degrees.length ≤ n →
  List.Mem (1 : Int) degrees →
  solve_graph_subset n 0 degrees [] = [(0:Nat)] := sorry

theorem empty_graph_valid_theorem (n : Nat) (degrees : List Int) :
  n > 0 → 
  degrees.length ≤ n →
  ¬List.Mem (1 : Int) degrees →
  solve_graph_subset n 0 degrees [] = [] := sorry

theorem valid_solution_edges_theorem (n m : Nat) (degrees : List Int) (edges : List (Nat × Nat)) :
  n ≥ 2 →
  degrees.length = n →
  edges.length = m →
  (∀ (e : Nat × Nat), List.Mem e edges → e.1 ≠ e.2) →
  (∀ (e : Nat × Nat), List.Mem e edges → e.1 ≤ n ∧ e.2 ≤ n) →
  List.Nodup edges →
  let result := solve_graph_subset n m degrees edges
  result ≠ [(0:Nat)] →
  (∀ e, List.Mem e result → e ≤ m ∧ e ≥ 1) ∧ List.Nodup result := sorry
