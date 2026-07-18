import Mathlib

def lowest_temp (s : String) : Option Int := sorry 

theorem lowest_temp_empty: lowest_temp "" = none := sorry

theorem lowest_temp_single (n : Int) (h : -100 ≤ n ∧ n ≤ 100) :
  lowest_temp (toString n) = some n := sorry

theorem lowest_temp_properties (s : String) :
  match lowest_temp s with
  | none => s = ""
  | some result =>
    ∃ nums : List Int,
      (∀ n ∈ nums, -100 ≤ n ∧ n ≤ 100) ∧
      result = nums.minimum?.get! ∧
      nums ≠ []
  := sorry
