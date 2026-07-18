import Mathlib

def largest_pair_sum (l : List Int) : Int :=
  sorry

theorem output_greater_than_min_pair
  {l : List Int} (h : l.length ≥ 2) :
  largest_pair_sum l ≥ 2 * (l.minimum?.getD 0) :=
sorry

theorem output_less_than_max_pair 
  {l : List Int} (h : l.length ≥ 2) :
  largest_pair_sum l ≤ 2 * (l.maximum?.getD 0) :=
sorry

def isSorted (l : List Int) : Bool :=
  sorry

theorem sorted_input_same_output 
  {l : List Int} (h : l.length ≥ 2) (sorted : List Int) (h₂ : isSorted sorted) :
  largest_pair_sum l = largest_pair_sum sorted :=
sorry

theorem reversed_input_same_output
  {l : List Int} (h : l.length ≥ 2) :
  largest_pair_sum l = largest_pair_sum l.reverse :=
sorry

theorem non_negative_sum_non_negative
  {l : List Int} (h : l.length ≥ 2) (h₂ : ∀ x ∈ l, x ≥ 0) :
  largest_pair_sum l ≥ 0 :=
sorry
