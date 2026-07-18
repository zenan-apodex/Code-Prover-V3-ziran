import Mathlib

def unique_in_order {α} [BEq α] (xs : List α) : List α := sorry

theorem no_consecutive_duplicates {α} [BEq α] [Inhabited α] (xs : List α) :
  let result := unique_in_order xs
  ∀ i, i < result.length - 1 → result.get! i ≠ result.get! (i+1) := sorry

theorem elements_from_input {α} [BEq α] (xs : List α) :
  let result := unique_in_order xs
  ∀ x ∈ result, x ∈ xs := sorry

theorem maintains_relative_order {α} [BEq α] [Inhabited α] (xs : List α) :
  let result := unique_in_order xs
  xs ≠ [] ∧ result ≠ [] →
  ∀ i j, i < j → i < xs.length → j < xs.length → 
  xs[i]! = xs[j]! → result.indexOf (xs[i]!) < result.indexOf (xs[j]!) := sorry

theorem length_bounded {α} [BEq α] (xs : List α) :
  (unique_in_order xs).length ≤ xs.length := sorry

theorem empty_input_empty_output {α} [BEq α] :
  unique_in_order ([] : List α) = [] := sorry
