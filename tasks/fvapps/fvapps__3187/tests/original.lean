import Mathlib

def sumNested : List (List Int) → Int
  | _ => sorry

def flatten : List (List Int) → List Int
  | _ => sorry

def listSum : List Int → Int
  | [] => 0
  | h :: t => h + listSum t

/-- Sum of nested lists equals the sum of flattened list -/
theorem sum_nested_equals_flatten_sum (l : List (List Int)) :
  sumNested l = listSum (flatten l) := by
  sorry

/-- Sum of empty nested lists is zero -/
theorem sum_nested_empty_lists (l : List (List Int)) (h : ∀ x ∈ l, x = []) :
  sumNested l = 0 := by
  sorry

/-- Sum of singleton list equals its element -/
theorem sum_nested_singleton (n : Int) :
  sumNested [[n]] = n := by
  sorry
