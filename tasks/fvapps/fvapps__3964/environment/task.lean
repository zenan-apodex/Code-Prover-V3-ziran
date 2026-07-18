import Mathlib

def rank_of_element (arr : List Int) (i : Nat) : Nat :=
  sorry

theorem rank_within_bounds {arr : List Int} {i : Nat} (h : i < arr.length) :
  let rank := rank_of_element arr i
  0 ≤ rank ∧ rank ≤ arr.length :=
sorry

theorem rank_exceeds_strictly_less {arr : List Int} {i : Nat} (h : i < arr.length) :
  let rank := rank_of_element arr i
  let target := arr[i]
  let strictly_less := (List.enum arr).filter (fun p => p.2 < target ∧ p.1 ≠ i) |>.length
  rank ≥ strictly_less :=
sorry
