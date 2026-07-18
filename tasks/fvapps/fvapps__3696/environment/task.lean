import Mathlib

namespace AddSpec

def add (nums: List Int) : List Int :=
  sorry

@[simp]
theorem add_length_preservation: 
  ∀ (nums: List Int), 
  List.length (add nums) = List.length nums := 
  sorry

@[simp]
theorem add_cumulative_property:
  ∀ (nums: List Int),
  nums ≠ [] →
  let result := add nums
  (List.get! result 0 = List.get! nums 0) ∧ 
  ∀ (i: Nat), 0 < i → i < nums.length → 
    List.get! result i = List.get! result (i-1) + List.get! nums i :=
  sorry

@[simp]
theorem add_monotonic_for_nonnegative:
  ∀ (nums: List Int),
  (∀ x, x ∈ nums → 0 ≤ x) →
  let result := add nums
  ∀ (i j: Nat), i < j → j < result.length → 
    List.get! result i ≤ List.get! result j :=
  sorry

@[simp]
theorem add_invalid_input:
  ∀ (s: String), add [] = [] :=
  sorry

end AddSpec
