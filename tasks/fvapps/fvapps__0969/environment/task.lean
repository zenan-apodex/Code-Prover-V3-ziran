import Mathlib

def Activity := String × Nat

def calculate_max_months (input : List String) : List Nat :=
  sorry



theorem multiple_test_cases_properties
  (n : Nat)
  (h : n > 0 ∧ n ≤ 5) :
  let result := calculate_max_months ([toString n] ++ 
    (List.range n).bind (fun i => 
      [s!"1 {if i % 2 = 0 then "INDIAN" else "NON_INDIAN"}", 
       "BUG_FOUND 1000"]))
  result.length = n ∧
  (∀ i, i < n → result[i]! > 0) ∧
  (∀ i, 0 < i → i < n → i % 2 = 1 → result[i]! ≤ result[i-1]!) :=
sorry

theorem contest_won_rank_bonus
  (rank : Nat)
  (h : rank > 0 ∧ rank ≤ 20) :
  let result := calculate_max_months ["1", "2 INDIAN", s!"CONTEST_WON {rank}", "CONTEST_WON 21"]
  let worse_result := calculate_max_months ["1", "2 INDIAN", "CONTEST_WON 21", "CONTEST_WON 21"]
  result[0]! ≥ worse_result[0]! :=
sorry
