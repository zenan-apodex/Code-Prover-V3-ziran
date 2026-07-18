import Mathlib

@[reducible]
def Dict := List (String × (String ⊕ Int))

def solution (d : Dict) : String :=
  sorry

def isSorted (xs : List String) : Prop :=
  ∀ i j, i < j → j < xs.length → xs[i]! ≤ xs[j]!

theorem solution_output_sorted (d : Dict) (h : d.length > 0) : 
  let result := solution d
  let pairs := result.splitOn ","
  isSorted pairs := by
  sorry

theorem solution_contains_all_pairs (d : Dict) (h : d.length > 0) : 
  let result := solution d
  let pairs := result.splitOn ","  
  ∀ p ∈ d, ∃ pair ∈ pairs, 
    match p.2 with
    | Sum.inl s => pair = s!"{p.1} = {s}"
    | Sum.inr n => pair = s!"{p.1} = {n}" := by
  sorry 

theorem solution_empty (d : Dict) (h : d = []) :
  solution d = "" := by
  sorry
