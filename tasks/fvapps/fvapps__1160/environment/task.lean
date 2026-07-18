import Mathlib

def find_zigzag_intervals (trees : List (Int × Int)) : List (Nat × (Nat ⊕ Unit)) :=
  sorry

theorem output_format (trees : List (Int × Int)) :
  let result := find_zigzag_intervals trees
  (∀ interval ∈ result,
    ∃ (start : Nat) (endVal : Nat ⊕ Unit),
      interval = (start, endVal) ∧
      (match endVal with
        | Sum.inl n => n ≥ start
        | Sum.inr _ => True)) :=
  sorry

theorem single_tree (tree : Int × Int) :
  find_zigzag_intervals [tree] = [(0, Sum.inr ())] :=
  sorry

theorem sorted_intervals (trees : List (Int × Int)) :
  let result := find_zigzag_intervals trees
  ∀ (i j : Nat),
    i < j →
    j < result.length →
    i < result.length →
    ∀ (n : Nat) (start : Nat),
    (result.get! i).2 = Sum.inl n →
    (result.get! j).1 = start →
    n < start :=
  sorry

theorem interval_bounds (trees : List (Int × Int)) :
  let result := find_zigzag_intervals trees
  ∀ interval ∈ result,
    match interval with
    | (start, Sum.inl endVal) => 0 ≤ start ∧ start ≤ endVal ∧ endVal < 10^20
    | (start, Sum.inr _) => 0 ≤ start :=
  sorry
