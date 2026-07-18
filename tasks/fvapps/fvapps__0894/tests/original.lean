import Mathlib

def Matrix (α : Type) := List (List α)
def LabelList := List Nat

def solve_graph_similarity (n : Nat) (g1 : Matrix Nat) (g2 : Matrix Nat) : LabelList × LabelList :=
  sorry

theorem solve_graph_similarity_output_length {n : Nat} {g1 g2 : Matrix Nat}:
  let (r1, r2) := solve_graph_similarity n g1 g2
  r1.length = n ∧ r2.length = n :=
  sorry

theorem solve_graph_similarity_output_values {n : Nat} {g1 g2 : Matrix Nat}:
  let (r1, r2) := solve_graph_similarity n g1 g2
  r1.foldl (fun acc x => x::acc) [] = List.range n ∧ 
  r2.foldl (fun acc x => x::acc) [] = List.range n :=
  sorry

theorem solve_graph_similarity_r1_equals_range {n : Nat} {g1 g2 : Matrix Nat}:
  let (r1, _) := solve_graph_similarity n g1 g2
  r1 = List.range n :=
  sorry
