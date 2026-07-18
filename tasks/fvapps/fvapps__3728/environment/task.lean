import Mathlib

def describeList (lst : List Int) : String :=
  sorry

theorem list_description_properties (lst : List Int) :
  describeList lst = match lst with
  | [] => "empty"
  | [_] => "singleton"
  | _ => "longer"
  :=
  sorry

theorem output_is_valid_string (lst : List Int) :
  describeList lst ∈ ["empty", "singleton", "longer"] :=
  sorry
