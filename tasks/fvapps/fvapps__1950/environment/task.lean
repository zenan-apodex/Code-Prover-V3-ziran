import Mathlib

inductive ListNode where
  | mk : Int → Option ListNode → ListNode
deriving Repr

def array_to_list : List Int → Option ListNode := 
  sorry

def list_to_array : Option ListNode → List Int :=
  sorry

def deleteDuplicates : Option ListNode → Option ListNode :=
  sorry

theorem output_is_subset_of_input (arr : List Int) : 
  let result := list_to_array (deleteDuplicates (array_to_list arr))
  ∀ x, x ∈ result → x ∈ arr :=
sorry

theorem empty_list_gives_empty_result (arr : List Int) :
  arr = [] → list_to_array (deleteDuplicates (array_to_list arr)) = [] :=
sorry

theorem singleton_values_preserved (arr : List Int) (val : Int) :
  arr ≠ [] →
  List.countP (· = val) arr = 1 → 
  val ∈ list_to_array (deleteDuplicates (array_to_list arr)) :=
sorry
