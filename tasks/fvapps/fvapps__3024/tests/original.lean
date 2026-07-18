import Mathlib

def friend (names: List String) : List String := sorry

theorem friend_property (names: List String) :
  let result := friend names
  (∀ n ∈ result, String.length n = 4) ∧ 
  (∀ n ∈ result, n ∈ names) ∧
  (∀ n ∈ names, String.length n = 4 → n ∈ result) := by
  sorry

theorem friend_preserves_order (names: List String) :
  friend names = names.filter (fun n => String.length n = 4) := by
  sorry

theorem friend_handles_empty_strings (names: List String) :
  let result := friend names
  (∀ n ∈ result, String.length n = 4) ∧
  (∀ n ∈ result, n ∈ names) := by
  sorry
