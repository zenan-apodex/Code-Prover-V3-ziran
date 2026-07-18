import Mathlib

def well (arr: List (List String)) : String := sorry

theorem well_output_is_valid (arr: List (List String)) : 
  well arr = "Fail!" ∨ well arr = "Publish!" ∨ well arr = "I smell a series!" := sorry

theorem well_count_good_matches (arr: List (List String)) :
  let goodCount := (arr.join.filter (fun x => x.toLower = "good")).length
  well arr = (if goodCount > 2 then "I smell a series!"
             else if goodCount > 0 then "Publish!"
             else "Fail!") := sorry

theorem well_all_bad (arr: List (List String))
  (h: ∀ l ∈ arr, ∀ s ∈ l, s = "bad") : 
  well arr = "Fail!" := sorry

theorem well_all_good (arr: List (List String))
  (h: ∀ l ∈ arr, ∀ s ∈ l, s = "good") :
  let totalGood := arr.join.length
  well arr = (if totalGood > 2 then "I smell a series!" else "Publish!") := sorry
