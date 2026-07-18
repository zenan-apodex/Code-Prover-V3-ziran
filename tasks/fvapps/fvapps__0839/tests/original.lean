import Mathlib

def sumList (list : List Int) : Int :=
  sorry

def isSubsetSum (arr : List Int) (n : Int) (k : Int) : Bool :=
  sorry

def can_eat_chocolates (k : Int) (n : Int) (arr : List Int) : Int :=
  sorry

theorem sum_less_than_k_returns_0 (arr : List Int) (k : Int):
  arr.length > 0 → 
  (∀ x ∈ arr, x > 0 ∧ x ≤ 100) →
  k > 0 →
  k ≤ 1000 →
  sumList arr < k →
  can_eat_chocolates k arr.length arr = 0 :=
  sorry

theorem target_sum_of_array_is_possible (arr : List Int):
  arr.length > 0 →
  (∀ x ∈ arr, x > 0 ∧ x ≤ 100) →
  can_eat_chocolates (sumList arr) arr.length arr = 1 :=
  sorry

theorem k_less_than_min_returns_0 (arr : List Int):
  arr.length > 0 →
  (∀ x ∈ arr, x > 0 ∧ x ≤ 100) →
  let k := (arr.minimum?.getD 0) - 1
  k > 0 →
  can_eat_chocolates k arr.length arr = 0 :=
  sorry

theorem subset_sum_matches_chocolates (arr : List Int) (k : Int):
  arr.length > 0 →
  (∀ x ∈ arr, x > 0 ∧ x ≤ 100) →
  k > 0 →
  k ≤ 1000 →
  (can_eat_chocolates k arr.length arr = 1) = isSubsetSum arr arr.length k :=
  sorry

theorem single_matching_element_returns_1 (arr : List Int):
  arr.length > 0 →
  (∀ x ∈ arr, x > 0 ∧ x ≤ 100) →
  let k := arr[0]!
  can_eat_chocolates k arr.length arr = 1 :=
  sorry
