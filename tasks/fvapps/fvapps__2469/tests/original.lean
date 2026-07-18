import Mathlib

def check_if_exist (arr : List Int) : Bool :=
  sorry

theorem check_if_exist_symmetric {arr : List Int} (n : Int) :
  arr ≠ [] →
  check_if_exist (arr ++ [2 * n]) = true :=
sorry

theorem check_if_exist_no_doubles (arr : List Int) :
  (∀ x ∈ arr, ∀ y ∈ arr, x ≠ 2 * y ∧ 2 * x ≠ y) →
  check_if_exist arr = false :=
sorry

theorem check_if_exist_zero (arr : List Int) :
  arr ≠ [] →
  check_if_exist (arr ++ [0, 0]) = true :=
sorry

theorem check_if_exist_empty :
  check_if_exist ([] : List Int) = false :=
sorry
