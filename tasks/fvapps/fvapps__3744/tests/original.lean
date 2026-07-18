import Mathlib

def get_oddity (n : Int) : Int :=
  sorry

def oddest (nums : List Int) : Option Int :=
  sorry

theorem oddest_empty (nums : List Int) :
  nums = [] → oddest nums = none :=
  sorry

theorem oddest_in_list {nums : List Int} {result : Int} :
  oddest nums = some result → result ∈ nums :=
  sorry

theorem oddest_null_tie_or_even {nums : List Int} :
  nums ≠ [] →
  oddest nums = none →
  let oddities := nums.map get_oddity
  let max_odd := oddities.maximum?
  match max_odd with
  | none => True 
  | some m => 
    (oddities.filter (·= m)).length > 1 ∨ m = 0 :=
  sorry

theorem oddest_output_type (nums : List Int) :
  oddest nums = none ∨ (∃ x, oddest nums = some x) :=
  sorry
