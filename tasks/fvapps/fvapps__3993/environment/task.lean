import Mathlib

def solve (arr : List (Sum Int String)) : Int := sorry

theorem solve_matches_even_odd_difference (arr : List (Sum Int String)) :
  solve arr = 
    (List.filter (fun x => match x with
      | Sum.inl n => n % 2 = 0
      | Sum.inr _ => false) arr).length -
    (List.filter (fun x => match x with
      | Sum.inl n => n % 2 = 1
      | Sum.inr _ => false) arr).length :=
sorry

theorem solve_all_strings (arr : List String) :
  solve (arr.map Sum.inr) = 0 :=
sorry

theorem solve_bounded_by_length (arr : List Int) :
  -arr.length ≤ solve (arr.map Sum.inl) ∧ 
  solve (arr.map Sum.inl) ≤ arr.length :=
sorry
