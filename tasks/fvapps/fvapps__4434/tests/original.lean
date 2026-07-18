import Mathlib

def first_non_repeated (s : String) : Option Char := sorry

theorem first_non_repeated_all_repeated (s : String) :
  first_non_repeated (s ++ s) = none := sorry

theorem first_non_repeated_single_unique (s : String) (h : s.length > 0) 
  (unique : Char) (h2 : ∀ c ∈ s.data, c ≠ unique) :
  first_non_repeated (s ++ s ++ toString unique ++ s ++ s) = some unique := sorry

theorem first_non_repeated_empty :
  first_non_repeated "" = none := sorry

theorem first_non_repeated_count_one {s : String} {c : Char} 
  (h : first_non_repeated s = some c) :
  (s.data.count c = 1) ∧ 
  (c ∈ s.data) ∧
  (∀ i : Nat, i < s.data.indexOf c → s.data[i]?.map (fun x => s.data.count x) ≠ some 1) := sorry
